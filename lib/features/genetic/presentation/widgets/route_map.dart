import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/features/pathfinding/presentation/provider/pathfinding_provider.dart';
import 'package:mapjacks/features/genetic/presentation/provider/genetic_provider.dart';
import 'package:mapjacks/features/genetic/presentation/widgets/route_painter.dart';

class RouteMap extends StatelessWidget {
  final String imagePath;
  const RouteMap({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PathfindingProvider, GeneticProvider>(
      builder: (context, pathfindingProvider, geneticProvider, _) {
        final mapGrid = pathfindingProvider.grid;
        if (mapGrid == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final result = geneticProvider.result;
        if (result == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Маршрут не построен'),
              ],
            ),
          );
        }

        final gridWidth = mapGrid.cols * mapGrid.cellSize.toDouble();
        final gridHeight = mapGrid.rows * mapGrid.cellSize.toDouble();

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
                  painter: RoutePainter(
                    route: result.bestRoute,
                    cellSize: mapGrid.cellSize.toDouble(),
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