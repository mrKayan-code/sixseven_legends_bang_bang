import 'package:equatable/equatable.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';

class Route extends Equatable {
  final List<FoodPoint> points;
  final double totalDistance;
  final double estimatedTime;

  const Route({
    required this.points,
    this.totalDistance = 0,
    this.estimatedTime = 0,
  });

  bool get isValid => points.isNotEmpty;
  int get pointsCount => points.length;

  @override
  List<Object?> get props => [points, totalDistance, estimatedTime];
}