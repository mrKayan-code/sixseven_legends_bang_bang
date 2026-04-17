import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/core/widgets/scaffold_with_navbar.dart';
import 'package:mapjacks/core/routes/app_routes.dart';
import 'package:mapjacks/features/genetic/presentation/provider/genetic_provider.dart';
import 'package:mapjacks/features/genetic/presentation/widgets/preset_selector.dart';
import 'package:mapjacks/features/genetic/presentation/widgets/food_selector.dart';
import 'package:mapjacks/features/genetic/presentation/widgets/route_map.dart';
import 'package:mapjacks/features/genetic/presentation/widgets/route_info.dart';

class GeneticScreen extends StatefulWidget {
  const GeneticScreen({super.key});

  @override
  State<GeneticScreen> createState() => _GeneticScreenState();
}

class _GeneticScreenState extends State<GeneticScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<GeneticProvider>();
    if (provider.allPoints.isEmpty) {
      provider.loadFoodPoints('assets/map/food_points.json');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavBar(
      currentRoute: AppRoutes.genetic,
      appBar: AppBar(
        title: const Text('Маршрут за едой чтоб поесть'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<GeneticProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Пресеты
              Padding(
                padding: const EdgeInsets.all(12),
                child: PresetSelector(
                  onPresetSelected: (preset) => provider.setPreset(preset),
                ),
              ),
              
              // Выбор блюд
              FoodSelector(
                selectedItems: provider.selectedItems,
                onToggle: (item) => provider.toggleItem(item),
              ),
              
              // Опции
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Checkbox(
                      value: provider.requireUtensils,
                      onChanged: (v) => provider.setRequireUtensils(v ?? false),
                    ),
                    const Text('Я без посуды'),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: provider.status == GeneticStatus.loading
                          ? null
                          : (provider.result == null
                              ? () => provider.findRoute()
                              : () => provider.clear()),
                      icon: Icon(
                        provider.status == GeneticStatus.loading
                            ? Icons.hourglass_empty
                            : (provider.result == null ? Icons.play_arrow : Icons.refresh),
                      ),
                      label: Text(
                        provider.status == GeneticStatus.loading
                            ? '...'
                            : (provider.result == null ? 'Найти маршрут' : 'Сбросить'),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Карта или информация
              Expanded(
                child: provider.result != null
                    ? RouteInfo(result: provider.result!)
                    : RouteMap(imagePath: 'assets/map/map.png'),
              ),
            ],
          );
        },
      ),
    );
  }
}