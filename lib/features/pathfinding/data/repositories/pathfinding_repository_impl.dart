import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/map_grid.dart';
import '../../domain/entities/path.dart';
import '../../domain/entities/point.dart';
import '../../domain/repositories/pathfinding_repository.dart';
import '../datasources/map_local_data_source.dart';
import '../services/a_star_service.dart';

class PathfindingRepositoryImpl implements PathfindingRepository {
  final MapLocalDataSource local;
  final AStarService aStarService;

  PathfindingRepositoryImpl({required this.local, required this.aStarService});

  @override
  Future<Either<Failure, MapGrid>> loadMap(String path) async {
    try {
      return Right(await local.loadMap(path));
    } on Failure catch (f) {
      return Left(f);
    } catch (_) {
      return Left(MapLoadFailure(message: 'Ошибка загрузки'));
    }
  }

  @override
  Future<Either<Failure, Path>> findPath({
    required Point start,
    required Point end,
    required MapGrid grid,
  }) async {
    try {
      final path = await aStarService.find(start: start, end: end, grid: grid);
    
      if (!path.isValid) {
        return Left(PathfindingFailure(message: 'Маршрут не найден'));
      }
      return Right(path);
    } catch (_) {
      return Left(PathfindingFailure(message: 'Ошибка поиска пути'));
    }
  }
}