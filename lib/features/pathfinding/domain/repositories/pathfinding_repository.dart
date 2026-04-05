import 'package:dartz/dartz.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/map_grid.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/path.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';

abstract class PathfindingRepository {
  Future<Either<Failure, MapGrid>> loadMap(String assetPath);
  Future<Either<Failure, Path>> findPath({
    required Point start,
    required Point end,
    required MapGrid grid,
  });
}