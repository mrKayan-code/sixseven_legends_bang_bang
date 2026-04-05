import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/features/pathfinding/presentation/provider/pathfinding_provider.dart';

class MapControls extends StatelessWidget {
  const MapControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ModeButton(
            icon: Icons.flag,
            color: Colors.green,
            label: 'Точка А',
            mode: SelectionMode.start,
          ),
          _ModeButton(
            icon: Icons.flag,
            color: Colors.red,
            label: 'Точка Б',
            mode: SelectionMode.end,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => context.read<PathfindingProvider>().clear(),
            tooltip: 'Очистить',
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final SelectionMode mode;

  const _ModeButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PathfindingProvider>(
      builder: (context, provider, _) {
        final active = provider.mode == mode;
        return IconButton(
          icon: Icon(icon, color: active ? color : null),
          onPressed: () {
            provider.setMode(mode);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Выберите $label')),
            );
          },
          tooltip: label,
        );
      },
    );
  }
}