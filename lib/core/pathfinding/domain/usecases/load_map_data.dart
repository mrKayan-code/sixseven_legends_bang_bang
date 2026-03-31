import 'package:dartz/dartz.dart';
import '../../../failures/failures.dart';
import '../entities/map_grid.dart';
import '../repositories/pathfinding_repository.dart';

class LoadMap {
  final PathfindingRepository _repository;

  LoadMap(this._repository);

  Future<Either<Failure, MapGrid>> call(String assetPath) =>
      _repository.loadMap(assetPath);
}