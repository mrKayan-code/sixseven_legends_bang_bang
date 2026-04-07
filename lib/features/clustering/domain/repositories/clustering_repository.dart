import 'package:dartz/dartz.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/clustering/domain/entities/clustering_result.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';

abstract class ClusteringRepository {
  Future<Either<Failure, List<FoodPoint>>> loadFoodPoints(String assetPath);

  Future<Either<Failure, ClusteringResult>> clusterPoints({
    required List<FoodPoint> points,
    required int k,
    bool useAStar = false,
  });
}