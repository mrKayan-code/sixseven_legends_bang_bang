import 'package:dartz/dartz.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/genetic/domain/entities/food_item.dart';
import 'package:mapjacks/features/genetic/domain/entities/genetic_result.dart';
import 'package:mapjacks/features/genetic/domain/repositories/genetic_repository.dart';
import 'package:mapjacks/features/genetic/data/datasources/genetic_data_source.dart';
import 'package:mapjacks/features/genetic/data/services/genetic_algorithm_service.dart';

class GeneticRepositoryImpl implements GeneticRepository {
  final GeneticDataSource _dataSource;
  final GeneticAlgorithmService _geneticService;

  GeneticRepositoryImpl({
    required GeneticDataSource dataSource,
    required GeneticAlgorithmService geneticService,
  })  : _dataSource = dataSource,
        _geneticService = geneticService;

  @override
  Future<Either<Failure, List<FoodPoint>>> loadFoodPointsWithMenu(String assetPath) async {
    try {
      final points = await _dataSource.loadFoodPointsWithMenu(assetPath);
      return Right(points);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(GeneticFailure(message: 'Ошибка загрузки: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FoodPoint>>> findPointsWithItem(
    List<FoodPoint> points,
    FoodItemType item,
  ) async {
    try {
      final filtered = points.where((p) => p.hasItem(item)).toList();
      if (filtered.isEmpty) {
        return Left(GeneticFailure(message: 'Нет заведений с блюдом: ${item.displayName}'));
      }
      return Right(filtered);
    } catch (e) {
      return Left(GeneticFailure(message: 'Ошибка фильтрации: $e'));
    }
  }

  @override
  Future<Either<Failure, GeneticResult>> findOptimalRoute({
    required List<FoodPoint> points,
    required List<FoodItemType> items,
    required Point start,
    bool requireUtensils = false,
    int populationSize = 50,
    int maxGenerations = 100,
    double mutationRate = 0.1,
  }) async {
    try {
      final result = await _geneticService.findOptimalRoute(
        allPoints: points,
        requiredItems: items,
        start: start,
        populationSize: populationSize,
        maxGenerations: maxGenerations,
        mutationRate: mutationRate,
      );
      return Right(result);
    } catch (e) {
      return Left(GeneticFailure(message: 'Ошибка генетического алгоритма: $e'));
    }
  }
}