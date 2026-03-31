import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di.dart';
import 'core/pathfinding/presentation/screens/pathfinding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders(),
      child: MaterialApp(
        title: 'ТГУ кампус 67',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const PathfindingScreen(),
      ),
    );
  }
}