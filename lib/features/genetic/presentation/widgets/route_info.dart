import 'package:flutter/material.dart';
import 'package:mapjacks/features/genetic/domain/entities/genetic_result.dart';

class RouteInfo extends StatelessWidget {
  final GeneticResult result;
  const RouteInfo({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final route = result.bestRoute;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Оптимальный маршрут',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _StatRow('Заведений', '${route.pointsCount}'),
            _StatRow('Расстояние', '${route.totalDistance.toStringAsFixed(0)} м'),
            _StatRow('Время', '~${route.estimatedTime.toStringAsFixed(0)} мин'),
            _StatRow('Поколений', '${result.generations}'),
            const SizedBox(height: 12),
            ...route.points.asMap().entries.map((e) => _PointTile(e.key + 1, e.value)),
          ],
        ),
      ),
    );
  }

  Widget _StatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _PointTile(int index, dynamic point) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 12,
        child: Text('$index', style: const TextStyle(fontSize: 12)),
      ),
      title: Text(point.name),
      subtitle: Text('${point.menu.length} блюд'),
    );
  }
}