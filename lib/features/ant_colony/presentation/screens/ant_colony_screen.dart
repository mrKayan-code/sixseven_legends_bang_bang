import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/core/routes/app_routes.dart';
import 'package:mapjacks/core/widgets/scaffold_with_navbar.dart';
import 'package:mapjacks/features/ant_colony/presentation/provider/ant_colony_provider.dart';
import 'package:mapjacks/features/pathfinding/presentation/provider/pathfinding_provider.dart';
import 'package:mapjacks/features/ant_colony/presentation/widgets/ant_colony_map_canvas.dart';

class AntColonyScreen extends StatefulWidget {
  const AntColonyScreen({super.key});
  @override
  State<AntColonyScreen> createState() => _AntColonyScreenState();
}

class _AntColonyScreenState extends State<AntColonyScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pathProvider = context.read<PathfindingProvider>();
    if (pathProvider.grid == null) pathProvider.load('assets/map/map_config.json');
  }

  @override
  Widget build(BuildContext context) {
    final antProvider = context.watch<AntColonyProvider>();
    final pathProvider = context.watch<PathfindingProvider>();

    return ScaffoldWithNavBar(
      currentRoute: AppRoutes.antColony,
      appBar: AppBar(title: const Text('Муравьиный алгоритм')),
      body: pathProvider.grid == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(12),
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  child: Text(
                    antProvider.selectedPoints.isEmpty ? '📍 Укажите ваше положение' : '🚩 Добавьте достопримечательности',
                    textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(child: AntColonyMapCanvas(imagePath: 'assets/map/map.png')),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: antProvider.selectedPoints.isEmpty ? null : () => antProvider.clearPoints(),
                        style: OutlinedButton.styleFrom(minimumSize: const Size(60, 50), foregroundColor: Colors.red),
                        child: const Icon(Icons.delete_outline),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(minimumSize: const Size(0, 50)),
                          onPressed: antProvider.selectedPoints.length >= 2 && !antProvider.isCalculating
                              ? () => antProvider.calculateRoute() : null,
                          icon: antProvider.isCalculating ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.play_arrow),
                          label: const Text('ПОСТРОИТЬ МАРШРУТ'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}