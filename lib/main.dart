import 'package:flutter/material.dart';
import 'package:mapjacks/core/routes/app_router.dart';
import 'package:mapjacks/core/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/di.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // await init();
  
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

        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRoutes.pathfinding,
        onUnknownRoute: (settings) => AppRouter.generateRoute(
          RouteSettings(name: '/error', arguments: 'Неизвестный маршрут'),
        ),


        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          navigationBarTheme: NavigationBarThemeData(
            indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }
}
