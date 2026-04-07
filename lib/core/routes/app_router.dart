import 'package:flutter/material.dart';
import 'package:mapjacks/core/routes/app_routes.dart';
import 'package:mapjacks/features/pathfinding/presentation/screens/pathfinding_screen.dart';
import 'package:mapjacks/features/clustering/presentation/screens/clustering_screen.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    debugPrint('переход в ${settings.name}');
    
    switch (settings.name) {
      case AppRoutes.pathfinding:
        return _buildRoute(const PathfindingScreen(), settings);
      
      case AppRoutes.clustering:
        return _buildRoute(const ClusteringScreen(), settings);
      
      default:
        return _buildErrorRoute('Маршрут не найден: ${settings.name}');
    }
  }
  
  static MaterialPageRoute<T> _buildRoute<T>(Widget page, RouteSettings settings) {
    return MaterialPageRoute<T>(
      builder: (_) => page,
      settings: settings,
    );
  }
  
  static MaterialPageRoute _buildErrorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Ошибка')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('На главную'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}