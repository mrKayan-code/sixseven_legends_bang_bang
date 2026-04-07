import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'dart:math';

class Cluster extends Equatable {
  final int id;
  final Point centroid;
  final List<FoodPoint> points;
  final Color color;

  const Cluster({
    required this.id,
    required this.centroid,
    required this.points,
    required this.color,
  });

  double get avgDistanceToCentroid {
    if (points.isEmpty) return 0;
    var total = 0.0;
    for (final p in points) {
      final dx = (p.col - centroid.col).abs();
      final dy = (p.row - centroid.row).abs();
      total += sqrt((dx * dx + dy * dy));
    }
    return total / points.length;
  }

  @override
  List<Object?> get props => [id, centroid, points];

  @override
  String toString() => 'cluster $id, ${points.length} points';
}