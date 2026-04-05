import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/features/pathfinding/presentation/provider/pathfinding_provider.dart';

class MapStatus extends StatelessWidget {
  const MapStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PathfindingProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Text('А: ', provider.start?.toString() ?? 'не выбрана'),
              _Text('Б: ', provider.end?.toString() ?? 'не выбрана'),
              if (provider.path?.isValid == true)
                _Text('Путь: ', '${provider.path!.points.length} клеток',
                    color: Theme.of(context).colorScheme.primary, bold: true),
              if (provider.status == PathStatus.loading)
                const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
        );
      },
    );
  }
}

class _Text extends StatelessWidget {
  final String label, value;
  final Color? color;
  final bool bold;

  const _Text(this.label, this.value, {this.color, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: color ?? Theme.of(context).colorScheme.onSurface,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
        children: [
          TextSpan(text: label),
          TextSpan(text: value),
        ],
      ),
    );
  }
}