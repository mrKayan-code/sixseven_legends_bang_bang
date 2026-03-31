import 'package:dartz/dartz.dart';
import '../../../failures/failures.dart';
import '../entities/path.dart';
import '../entities/point.dart';
import '../repositories/pathfinding_repository.dart';
import '../entities/map_grid.dart';

class FindPath {
  final PathfindingRepository _repository;

  FindPath(this._repository);

  Future<Either<Failure, Path>> call({
    required Point start,
    required Point end,
    required MapGrid grid,
  }) => _repository.findPath(start: start, end: end, grid: grid);
}