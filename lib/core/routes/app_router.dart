import 'package:flutter/material.dart';
import 'package:mapjacks/core/routes/app_routes.dart';
import 'package:mapjacks/features/pathfinding/presentation/screens/pathfinding_screen.dart';
import 'package:mapjacks/features/clustering/presentation/screens/clustering_screen.dart';
import 'package:mapjacks/features/rating/presentation/screens/rating_screen.dart';
import '../../features/decision_tree/presentation/screens/decision_tree_screen.dart';
import 'package:mapjacks/features/ant_colony/presentation/screens/ant_colony_screen.dart';
import 'package:mapjacks/features/decision_tree/presentation/screens/decision_tree_screen.dart';
import 'package:mapjacks/features/genetic/presentation/screens/genetic_screens.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    debugPrint('переход в ${settings.name}');
    
    switch (settings.name) {
      case AppRoutes.pathfinding:
        return _buildRoute(const PathfindingScreen(), settings);
      
      case AppRoutes.clustering:
        return _buildRoute(const ClusteringScreen(), settings);

      case AppRoutes.rating:
        return _buildRoute(const RatingScreen(), settings);

      case AppRoutes.decisionTree:
        return MaterialPageRoute(builder: (_) => const DecisionTreeScreen());

      case AppRoutes.antColony:
      return _buildRoute(const AntColonyScreen(), settings);
    
      case AppRoutes.genetic:
        return _buildRoute(const GeneticScreen(), settings);
      
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