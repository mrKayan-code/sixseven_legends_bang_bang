import 'package:flutter/material.dart';
import 'package:mapjacks/core/routes/app_routes.dart';

class AppNavBar extends StatelessWidget {
  final String currentRoute;
  
  const AppNavBar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _getCurrentIndex(),
      onDestinationSelected: (index) => _onItemSelected(context, index),
      destinations: availableRoutes.map(_buildDestination).toList(),
    );
  }
  
  NavigationDestination _buildDestination(RouteMeta route) {
    return NavigationDestination(
      icon: Icon(route.icon),
      label: route.label,
      //TODO() tooltip: 
    );
  }
  
  int _getCurrentIndex() {
    final index = availableRoutes.indexWhere((r) => r.name == currentRoute);
    return index >= 0 ? index : 0;
  }
  
  void _onItemSelected(BuildContext context, int index) {
    final selectedRoute = availableRoutes[index].name;
    
    if (selectedRoute == currentRoute) return;
    
    Navigator.pushReplacementNamed(context, selectedRoute);
  }
}