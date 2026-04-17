import 'package:dartz/dartz.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/genetic/domain/entities/food_item.dart';
import 'package:mapjacks/features/genetic/domain/entities/genetic_result.dart';

abstract class GeneticRepository {
  Future<Either<Failure, List<FoodPoint>>> loadFoodPointsWithMenu(String assetPath);

  Future<Either<Failure, List<FoodPoint>>> findPointsWithItem(
    List<FoodPoint> points,
    FoodItemType item,
  );

  Future<Either<Failure, GeneticResult>> findOptimalRoute({
    required List<FoodPoint> points,
    required List<FoodItemType> items,
    required Point start,
    bool requireUtensils = false,
    int populationSize = 50,
    int maxGenerations = 100,
    double mutationRate = 0.1,
  });
}