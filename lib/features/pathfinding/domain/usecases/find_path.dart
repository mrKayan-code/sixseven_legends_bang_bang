import 'package:dartz/dartz.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/path.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:mapjacks/features/pathfinding/domain/repositories/pathfinding_repository.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/map_grid.dart';

class FindPath {
  final PathfindingRepository _repository;

  FindPath(this._repository);

  Future<Either<Failure, Path>> call({
    required Point start,
    required Point end,
    required MapGrid grid,
  }) => _repository.findPath(start: start, end: end, grid: grid);
}