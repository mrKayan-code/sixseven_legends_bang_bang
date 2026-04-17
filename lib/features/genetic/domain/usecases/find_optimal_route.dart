import 'package:dartz/dartz.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/genetic/domain/entities/food_item.dart';
import 'package:mapjacks/features/genetic/domain/entities/genetic_result.dart';
import 'package:mapjacks/features/genetic/domain/repositories/genetic_repository.dart';

class FindOptimalRoute {
  final GeneticRepository _repository;

  FindOptimalRoute(this._repository);

  Future<Either<Failure, GeneticResult>> call({
    required List<FoodPoint> points,
    required List<FoodItemType> items,
    required Point start,
    bool requireUtensils = false,
    int populationSize = 50,
    int maxGenerations = 100,
    double mutationRate = 0.1,
  }) {
    if (points.isEmpty) {
      return Left(GeneticFailure(message: 'Нет заведений'));
    }
    if (items.isEmpty) {
      return Left(GeneticFailure(message: 'Не выбраны блюда'));
    }

    final filteredPoints = requireUtensils
        ? points.where((p) => p.hasUtensils).toList()
        : points;

    if (filteredPoints.isEmpty && requireUtensils) {
      return Left(GeneticFailure(message: 'Нет заведений с посудой'));
    }

    return _repository.findOptimalRoute(
      points: filteredPoints,
      items: items,
      start: start,
      populationSize: populationSize,
      maxGenerations: maxGenerations,
      mutationRate: mutationRate,
    );
  }
}