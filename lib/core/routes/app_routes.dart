import 'package:flutter/material.dart';

abstract class AppRoutes {
  static const String pathfinding = '/pathfinding';
  static const String clustering = '/clustering';
  static const String rating = '/rating';
  static const String decisionTree = '/decision_tree';
  static const String antColony = '/ant_colony';
  static const String genetic = '/genetic';
}

class RouteMeta {
  final String name;
  final String label;
  final IconData icon;
  
  const RouteMeta({
    required this.name,
    required this.label,
    required this.icon,
  });
}

const List<RouteMeta> availableRoutes = [
  RouteMeta(
    name: AppRoutes.pathfinding,
    label: 'Навигация',
    icon: Icons.map,
  ),
  RouteMeta(
    name: AppRoutes.clustering,
    label: 'Зоны питания',
    icon: Icons.restaurant,
  ),
  RouteMeta(
    name: AppRoutes.rating,
    label: 'Оценка',
    icon: Icons.star_border_rounded,
  ),

  RouteMeta(
    name: AppRoutes.decisionTree,
    label: 'Советник',
    icon: Icons.psychology_alt,
  ),

  RouteMeta(
    name: AppRoutes.antColony,
    label: 'Муравьи',
    icon: Icons.route,
  ),

  RouteMeta(
    name: AppRoutes.genetic, 
    label: 'Маршрут', 
    icon: Icons.coronavirus),
];

