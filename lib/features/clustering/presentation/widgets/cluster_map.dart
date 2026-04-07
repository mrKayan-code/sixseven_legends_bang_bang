import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/features/pathfinding/presentation/provider/pathfinding_provider.dart';
import 'package:mapjacks/features/clustering/presentation/provider/clustering_provider.dart';
import 'package:mapjacks/features/clustering/presentation/widgets/cluster_point_painter.dart';

class ClusterMap extends StatelessWidget {
  final String imagePath;
  
  const ClusterMap({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<PathfindingProvider, ClusteringProvider>(
      builder: (context, pathfindingProvider, clusteringProvider, _) {
        final mapConfig = pathfindingProvider.grid;
        if (mapConfig == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Загрузка карты...'),
              ],
            ),
          );
        }

        if (clusteringProvider.points.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Нет данных о заведениях'),
              ],
            ),
          );
        }

        final gridWidth = mapConfig.cols * mapConfig.cellSize.toDouble();
        final gridHeight = mapConfig.rows * mapConfig.cellSize.toDouble();

        return InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(100),
          constrained: false,
          minScale: 0.5,
          maxScale: 4.0,
          child: Stack(
            children: [
              SizedBox(
                width: gridWidth,
                height: gridHeight,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              
              SizedBox(
                width: gridWidth,
                height: gridHeight,
                child: CustomPaint(
                  painter: ClusterPointPainter(
                    points: clusteringProvider.points,
                    result: clusteringProvider.result,
                    cellSize: mapConfig.cellSize.toDouble(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}