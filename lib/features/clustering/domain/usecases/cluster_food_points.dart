import 'package:dartz/dartz.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/clustering/domain/entities/clustering_result.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/clustering/domain/repositories/clustering_repository.dart';

class ClusterFoodPoints {
  final ClusteringRepository _repository;

  ClusterFoodPoints(this._repository);

  Future<Either<Failure, ClusteringResult>> call({
    required List<FoodPoint> points,
    required int k,
    bool useAStar = false,
  }) async {
    if (points.isEmpty) {
      return Left(ClusteringFailure(message: 'Нет точек для кластеризации'));
    }
    if (k < 1 || k > points.length) {
      return Left(ClusteringFailure(message: 'Некорректное число кластеров: $k'));
    }

    return _repository.clusterPoints(
      points: points,
      k: k,
      useAStar: useAStar,
    );
  }
}