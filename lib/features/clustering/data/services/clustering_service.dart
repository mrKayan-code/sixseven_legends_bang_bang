import 'dart:math';

import 'package:flutter/material.dart';

import 'package:mapjacks/features/clustering/domain/entities/cluster.dart';
import 'package:mapjacks/features/clustering/domain/entities/clustering_result.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/clustering/data/services/metrics/distance_metric.dart';
import 'package:mapjacks/features/clustering/data/services/metrics/euclidean_metric.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';

class ClusteringService {
  static const int _maxIterations = 100;
  
  static const List<Color> _clusterColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.brown,
  ];

  Future<ClusteringResult> cluster({
    required List<FoodPoint> points,
    required int k,
    DistanceMetric? metric,
  }) async {
    final distanceMetric = metric ?? EuclideanMetric();
    
    var iterations = 0;
    var converged = false;
    
    var centroids = _initializeCentroids(points, k);
    
    List<int> assignments = List.filled(points.length, 0);
    
    for (var iter = 0; iter < _maxIterations; iter++) {
      iterations = iter + 1;
      
      await Future.microtask(() {});

      final newAssignments = _assignPoints(points, centroids, distanceMetric);
      
      if (_listsEqual(assignments, newAssignments)) {
        converged = true;
        assignments = newAssignments;
        break;
      }
      
      assignments = newAssignments;

      centroids = _recalculateCentroids(points, assignments, k);
    }
    
    final clusters = _buildClusters(assignments, points, centroids);
    
    return ClusteringResult(
      clusters: clusters,
      iterations: iterations,
      converged: converged,
    );
  }

  List<Point> _initializeCentroids(List<FoodPoint> points, int k) {
    final random = Random();
    final indices = <int>{};
    
    List<FoodPoint> copy = points.toList();
    
    while (indices.length < k) {
      int idx = random.nextInt(copy.length);
      copy.removeAt(idx);
      indices.add(idx);
    }
    
    return indices
        .map((i) => Point(row: points[i].col, col: points[i].row))
        .toList();
  }

  List<int> _assignPoints(
    List<FoodPoint> points,
    List<Point> centroids,
    DistanceMetric metric,
  ) {
    return points.map((point) {
      var minDistance = double.infinity;
      var closestCentroid = 0;
      
      for (var i = 0; i < centroids.length; i++) {
        final distance = metric.calculateToCentroid(
          point,
          centroids[i].row,
          centroids[i].col,
        );
        
        if (distance < minDistance) {
          minDistance = distance;
          closestCentroid = i;
        }
      }
      
      return closestCentroid;
    }).toList();
  }

  List<Point> _recalculateCentroids(
    List<FoodPoint> points,
    List<int> assignments,
    int k,
  ) {
    final centroids = <Point>[];
    
    for (var clusterId = 0; clusterId < k; clusterId++) {
      final clusterPoints = points.asMap().entries
        .where((entry) => assignments[entry.key] == clusterId)
        .map((entry) => entry.value)
        .toList();
      
      if (clusterPoints.isEmpty) {
        centroids.add(Point(row: 0, col: 0));
      } else {
        final avgRow = clusterPoints.map((p) => p.row).reduce((a, b) => a + b) ~/ clusterPoints.length;
        final avgCol = clusterPoints.map((p) => p.col).reduce((a, b) => a + b) ~/ clusterPoints.length;
        centroids.add(Point(row: avgRow, col: avgCol));
      }
    }
    
    return centroids;
  }

  List<Cluster> _buildClusters(
    List<int> assignments,
    List<FoodPoint> points,
    List<Point> centroids,
  ) {
    final k = centroids.length;
    final clusters = <Cluster>[];
    
    for (var clusterId = 0; clusterId < k; clusterId++) {
      final clusterPoints = points.asMap().entries
        .where((entry) => assignments[entry.key] == clusterId)
        .map((entry) => entry.value)
        .toList();
      
      clusters.add(Cluster(
        id: clusterId,
        centroid: centroids[clusterId],
        points: clusterPoints,
        color: _clusterColors[clusterId % _clusterColors.length],
      ));
    }
    
    return clusters;
  }

  bool _listsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}