import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';

abstract class DistanceMetric {
  double calculate(FoodPoint a, FoodPoint b);
  
  double calculateToCentroid(FoodPoint point, int centroidRow, int centroidCol);
}