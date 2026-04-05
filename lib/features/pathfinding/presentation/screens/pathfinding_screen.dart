import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/features/pathfinding/presentation/provider/pathfinding_provider.dart';
import 'package:mapjacks/features/pathfinding/presentation/widgets/map_canvas.dart';
import 'package:mapjacks/features/pathfinding/presentation/widgets/map_controls.dart';
import 'package:mapjacks/features/pathfinding/presentation/widgets/map_status.dart';

class PathfindingScreen extends StatefulWidget {
  const PathfindingScreen({super.key});
  @override
  State<PathfindingScreen> createState() => _PathfindingScreenState();
}

class _PathfindingScreenState extends State<PathfindingScreen> {
  @override
  void initState() {
    super.initState();
    

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PathfindingProvider>().load('assets/map/map_config.json');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('А*'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: const [
          MapStatus(),
          Divider(height: 1),
          MapControls(),
          Expanded(child: MapCanvas(imagePath: 'assets/map/map.png')),
        ],
      ),
    );
  }
}