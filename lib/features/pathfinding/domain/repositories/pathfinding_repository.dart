import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/map_grid.dart';
import '../entities/path.dart';
import '../entities/point.dart';

abstract class PathfindingRepository {
  Future<Either<Failure, MapGrid>> loadMap(String assetPath);
  Future<Either<Failure, Path>> findPath({
    required Point start,
    required Point end,
    required MapGrid grid,
  });
}