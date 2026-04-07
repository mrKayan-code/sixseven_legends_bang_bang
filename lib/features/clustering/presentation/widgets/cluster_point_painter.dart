import 'package:flutter/material.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/clustering/domain/entities/cluster.dart';
import 'package:mapjacks/features/clustering/domain/entities/clustering_result.dart';
import 'dart:math';

class ClusterPointPainter extends CustomPainter {
  final List<FoodPoint> points;
  final ClusteringResult? result;
  final double cellSize;

  ClusterPointPainter({
    required this.points,
    required this.result,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final point in points) {
      _drawPoint(canvas, point);
    }

    if (result != null) {
      for (final cluster in result!.clusters) {
        if (cluster.points.isNotEmpty) {
          _drawCentroid(canvas, cluster);
        }
      }
    }
  }

  void _drawPoint(Canvas canvas, FoodPoint point) {
    if (point.row < 0 || point.col < 0) return;

    final x = point.col * cellSize + cellSize / 2;
    final y = point.row * cellSize + cellSize / 2;

    Color color = Colors.grey.shade700;
    double radius = cellSize * 2;
    
    if (result != null) {
      for (final cluster in result!.clusters) {
        if (cluster.points.any((p) => p.id == point.id)) {
          color = cluster.color;
          radius = cellSize * 5;
          break;
        }
      }
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), radius, paint);
    
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(x, y), radius, borderPaint);
  }

  void _drawCentroid(Canvas canvas, Cluster cluster) {
    final x = cluster.centroid.col * cellSize + cellSize / 2;
    final y = cluster.centroid.row * cellSize + cellSize / 2;

    _drawStar(canvas, Offset(x, y), cluster.color, cellSize * 7);
  }

  void _drawStar(Canvas canvas, Offset center, Color color, double radius) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    const spikes = 5;
    
    for (var i = 0; i < spikes * 2; i++) {
      final r = (i % 2 == 0) ? radius : radius / 2;
      final angle = (i * pi / spikes) - (pi / 2);
      final dx = center.dx + r * cos(angle);
      final dy = center.dy + r * sin(angle);
      
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }
    
    path.close();

    canvas.drawPath(path, paint);
    
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant ClusterPointPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.result != result;
  }
}