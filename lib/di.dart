import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:mapjacks/features/pathfinding/data/datasources/map_local_data_source.dart';
import 'package:mapjacks/features/pathfinding/data/repositories/pathfinding_repository_impl.dart';
import 'package:mapjacks/features/pathfinding/data/services/a_star_service.dart';
import 'package:mapjacks/features/pathfinding/domain/repositories/pathfinding_repository.dart';
import 'package:mapjacks/features/pathfinding/domain/usecases/find_path.dart';
import 'package:mapjacks/features/pathfinding/domain/usecases/load_map_data.dart';
import 'package:mapjacks/features/pathfinding/presentation/provider/pathfinding_provider.dart';

import 'package:mapjacks/features/clustering/data/datasources/food_points_data_source.dart';
import 'package:mapjacks/features/clustering/data/repositories/clustering_repository_impl.dart';
import 'package:mapjacks/features/clustering/data/services/clustering_service.dart';
import 'package:mapjacks/features/clustering/domain/repositories/clustering_repository.dart';
import 'package:mapjacks/features/clustering/domain/usecases/cluster_food_points.dart';
import 'package:mapjacks/features/clustering/presentation/provider/clustering_provider.dart';
import 'package:mapjacks/features/rating/presentation/provider/rating_provider.dart';
Future<void> init() async {
  //TODO(перенести сюда инит стейты)
}


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

  Provider<FoodPointsDataSource>(
    create: (_) => FoodPointsDataSourceImpl(),
  ),
  
  Provider<ClusteringService>(
    create: (_) => ClusteringService(),
  ),
  
  Provider<ClusteringRepository>(
    create: (ctx) => ClusteringRepositoryImpl(
      dataSource: ctx.read<FoodPointsDataSource>(),
      clusteringService: ctx.read<ClusteringService>(),
    ),
  ),
  
  Provider<ClusterFoodPoints>(
    create: (ctx) => ClusterFoodPoints(ctx.read<ClusteringRepository>()),
  ),
  
  ChangeNotifierProvider<ClusteringProvider>(
    create: (ctx) => ClusteringProvider(
      clusterFoodPoints: ctx.read<ClusterFoodPoints>(),
    ),
  ),

  ChangeNotifierProvider<RatingProvider>(
    create: (_) => RatingProvider(),
  ),
];