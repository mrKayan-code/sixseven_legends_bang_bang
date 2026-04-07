import 'package:flutter/material.dart';
import 'package:mapjacks/core/routes/app_routes.dart';
import 'package:mapjacks/core/widgets/scaffold_with_navbar.dart';
import 'package:mapjacks/features/clustering/presentation/screens/clustering_screen.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = context.read<PathfindingProvider>();

    if (provider.grid == null && provider.status == PathStatus.initial) {
      provider.load('assets/map/map_config.json');
    }
  }

  // @override
  // void initState() {
  //   super.initState();
    

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<PathfindingProvider>().load('assets/map/map_config.json');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavBar(
      currentRoute: AppRoutes.pathfinding, 
      appBar: AppBar(
        title: const Text('А*'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<PathfindingProvider>(
        builder: (context, provider, _) {
          return switch (provider.status) {
            PathStatus.loading => const _LoadingView(),
            PathStatus.initial || PathStatus.success => _buildMapUI(provider),
            PathStatus.error => _ErrorView(message: provider.error,)
          };
        },
      ),
    );
    
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('А*'),
    //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //   ),
    //   body: Column(
    //     children: const [
    //       MapStatus(),
    //       Divider(height: 1),
    //       MapControls(),
    //       Expanded(child: MapCanvas(imagePath: 'assets/map/map.png')),
    //     ],
    //   ),
    // );
  }

  Widget _buildMapUI(PathfindingProvider provider) {
    if (provider.grid == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return const Column(
      children: [
        MapStatus(),
        Divider(height: 1),
        MapControls(),
        Expanded(child: MapCanvas(imagePath: 'assets/map/map.png')),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(),
      SizedBox(height: 16),
      Text('Загрузка карты...'),
    ]),
  );
}

class _ErrorView extends StatelessWidget {
  final String? message;
  const _ErrorView({this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Не удалось загрузить карту: ${message ?? "ошибка"}',
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<PathfindingProvider>().clear(),
            child: const Text('Попробовать снова'),
          ),
        ],
      ),
    ),
  );
}