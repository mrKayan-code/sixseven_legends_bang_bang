import 'package:flutter/material.dart';
import 'package:mapjacks/core/widgets/app_navbar.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final String currentRoute;
  final Widget body;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;

  const ScaffoldWithNavBar({
    super.key,
    required this.currentRoute,
    required this.body,
    this.floatingActionButton,
    this.appBar,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      bottomNavigationBar: AppNavBar(currentRoute: currentRoute),
    );
  }
}