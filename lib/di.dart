import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'core/pathfinding/data/datasources/map_local_data_source.dart';
import 'core/pathfinding/data/repositories/pathfinding_repository_impl.dart';
import 'core/pathfinding/data/services/a_star_service.dart';
import 'core/pathfinding/domain/repositories/pathfinding_repository.dart';
import 'core/pathfinding/domain/usecases/find_path.dart';
import 'core/pathfinding/domain/usecases/load_map_data.dart';
import 'core/pathfinding/presentation/provider/pathfinding_provider.dart';

List<SingleChildWidget> getProviders() => [

  Provider<MapLocalDataSource>(
    create: (_) => MapLocalDataSourceImpl(),
  ),
  Provider<AStarService>(
    create: (_) => AStarService(),
  ),
  
  Provider<PathfindingRepository>(
    create: (ctx) => PathfindingRepositoryImpl(
      local: ctx.read<MapLocalDataSource>(),
      aStarService: ctx.read<AStarService>(),
    ),
  ),
  
  Provider<LoadMap>(
    create: (ctx) => LoadMap(ctx.read<PathfindingRepository>()),
  ),
  Provider<FindPath>(
    create: (ctx) => FindPath(ctx.read<PathfindingRepository>()),
  ),
  
  ChangeNotifierProvider<PathfindingProvider>(
    create: (ctx) => PathfindingProvider(
      loadMap: ctx.read<LoadMap>(),
      findPath: ctx.read<FindPath>(),
    ),
  ),
];