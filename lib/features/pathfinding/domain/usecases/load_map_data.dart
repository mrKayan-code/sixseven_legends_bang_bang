import 'package:dartz/dartz.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/map_grid.dart';
import 'package:mapjacks/features/pathfinding/domain/repositories/pathfinding_repository.dart';

class LoadMap {
  final PathfindingRepository _repository;

  LoadMap(this._repository);

  Future<Either<Failure, MapGrid>> call(String assetPath) =>
      _repository.loadMap(assetPath);
}