import 'package:flutter/material.dart';

abstract class AppRoutes {
  static const String pathfinding = '/pathfinding';
  static const String clustering = '/clustering';
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
];