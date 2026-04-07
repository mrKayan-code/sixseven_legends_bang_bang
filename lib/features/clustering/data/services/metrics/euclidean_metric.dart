import 'dart:math';

import 'package:mapjacks/features/clustering/data/services/metrics/distance_metric.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';

class EuclideanMetric implements DistanceMetric {
  @override
  double calculate(FoodPoint a, FoodPoint b) {
    final dx = (b.col - a.col).toDouble();
    final dy = (b.row - a.row).toDouble();
    return sqrt(dx * dx + dy * dy);
  }

  @override
  double calculateToCentroid(FoodPoint point, int centroidRow, int centroidCol) {
    final dx = (centroidCol - point.col).toDouble();
    final dy = (centroidRow - point.row).toDouble();
    return sqrt(dx * dx + dy * dy);
  }
}