import 'package:equatable/equatable.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';

class Path extends Equatable {
  final List<Point> points;
  final int totalCost;
  final int iterations;

  const Path({
    required this.points,
    this.totalCost = 0,
    this.iterations = 0,
  });

  bool get isValid => points.length > 1;

  @override
  List<Object?> get props => [points, totalCost, iterations];
}