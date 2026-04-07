import 'package:dartz/dartz.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/clustering/domain/entities/clustering_result.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/clustering/domain/repositories/clustering_repository.dart';
import 'package:mapjacks/features/clustering/data/datasources/food_points_data_source.dart';
import 'package:mapjacks/features/clustering/data/services/clustering_service.dart';
import 'package:mapjacks/features/clustering/data/services/metrics/euclidean_metric.dart';

class ClusteringRepositoryImpl implements ClusteringRepository {
  final FoodPointsDataSource _dataSource;
  final ClusteringService _clusteringService;

  ClusteringRepositoryImpl({
    required FoodPointsDataSource dataSource,
    required ClusteringService clusteringService,
  })  : _dataSource = dataSource,
        _clusteringService = clusteringService;

  @override
  Future<Either<Failure, List<FoodPoint>>> loadFoodPoints(String assetPath) async {
    try {
      final points = await _dataSource.loadFoodPoints(assetPath);
      return Right(points);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(MapLoadFailure(message: 'Ошибка загрузки: $e'));
    }
  }

  @override
  Future<Either<Failure, ClusteringResult>> clusterPoints({
    required List<FoodPoint> points,
    required int k,
    bool useAStar = false,
  }) async {
    try {
      final metric = useAStar 
          ? throw UnimplementedError('потом') 
          : EuclideanMetric();
      
      final result = await _clusteringService.cluster(
        points: points,
        k: k,
        metric: metric,
      );
      
      return Right(result);
    } catch (e) {
      return Left(ClusteringFailure(message: 'Ошибка кластеризации: $e'));
    }
  }
}