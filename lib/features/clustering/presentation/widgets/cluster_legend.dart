import 'package:flutter/material.dart';
import 'package:mapjacks/features/clustering/domain/entities/cluster.dart';

class ClusterLegend extends StatelessWidget {
  final List<Cluster> clusters;
  
  const ClusterLegend({
    super.key,
    required this.clusters,
  });

  @override
  Widget build(BuildContext context) {
    if (clusters.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Зоны еды',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...clusters.map((cluster) => _buildLegendItem(cluster, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Cluster cluster, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: cluster.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Кластер ${cluster.id + 1} - ${cluster.points.length} заведений',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}