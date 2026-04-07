import 'package:flutter/material.dart';
import 'package:mapjacks/core/widgets/scaffold_with_navbar.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/core/routes/app_routes.dart';
import 'package:mapjacks/features/pathfinding/presentation/provider/pathfinding_provider.dart';
import 'package:mapjacks/features/clustering/presentation/provider/clustering_provider.dart';
import 'package:mapjacks/features/clustering/presentation/widgets/cluster_map.dart';
import 'package:mapjacks/features/clustering/presentation/widgets/cluster_legend.dart';

class ClusteringScreen extends StatefulWidget {
  const ClusteringScreen({super.key});

  @override
  State<ClusteringScreen> createState() => _ClusteringScreenState();
}

class _ClusteringScreenState extends State<ClusteringScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final clusteringProvider = context.read<ClusteringProvider>();
    final pathfindingProvider = context.read<PathfindingProvider>();
    
    if (pathfindingProvider.grid == null) {
      pathfindingProvider.load('assets/map/map_config.json');
    }
    
    if (clusteringProvider.points.isEmpty) {
      clusteringProvider.loadFoodPoints('assets/map/food_points.json');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavBar(
      currentRoute: AppRoutes.clustering,
      appBar: AppBar(
        title: const Text('Зоны питания'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<PathfindingProvider, ClusteringProvider>(
        builder: (context, pathfindingProvider, clusteringProvider, _) {
          return Column(
            children: [
              _buildControls(clusteringProvider),
              
              if (clusteringProvider.result != null)
                ClusterLegend(clusters: clusteringProvider.result!.clusters),
              
              Expanded(
                child: ClusterMap(imagePath: 'assets/map/map.png'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControls(ClusteringProvider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        children: [
          const Text('K: ', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<int>(
            value: provider.k,
            items: [1, 2, 3, 4, 5].map((k) => 
              DropdownMenuItem(value: k, child: Text('$k'))).toList(),
            onChanged: (v) => v != null ? provider.setK(v) : null,
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: provider.status == ClusteringStatus.loading 
                ? null
                : (provider.result == null 
                    ? () => provider.runClustering()
                    : () => provider.clear()),
            icon: Icon(
              provider.status == ClusteringStatus.loading 
                  ? Icons.hourglass_empty
                  : (provider.result == null ? Icons.play_arrow : Icons.refresh),
            ),
            label: Text(
              provider.status == ClusteringStatus.loading 
                  ? '...'
                  : (provider.result == null ? 'Кластеризовать' : 'Сбросить'),
            ),
          ),
        ],
      ),
    );
  }
}