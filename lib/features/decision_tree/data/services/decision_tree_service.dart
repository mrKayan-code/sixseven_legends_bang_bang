import '../../domain/entities/decision_tree_node.dart';
import 'dart:math';

class DecisionTreeService {
  final String targetColumn;

  DecisionTreeService({required this.targetColumn});

  DecisionTreeNode buildTree(List<Map<String, String>> data, List<String> availableFeatures) {
    final targetValues = data.map((row) => row[targetColumn]!).toList();
    if (targetValues.toSet().length == 1) {
      return DecisionTreeNode(predictedClass: targetValues.first);
    }

    if (availableFeatures.isEmpty) {
      return DecisionTreeNode(predictedClass: _getMostFrequentClass(targetValues));
    }

    String bestFeature = '';
    double maxInfoGain = -double.maxFinite;

    final currentEntropy = _calculateEntropy(targetValues);

    for (var feature in availableFeatures) {
      final infoGain = _calculateInformationGain(data, feature, currentEntropy);
      if (infoGain > maxInfoGain) {
        maxInfoGain = infoGain;
        bestFeature = feature;
      }
    }

    final node = DecisionTreeNode(
      splitFeature: bestFeature,
      children: {},
    );

    final Map<String, List<Map<String, String>>> subsets = _splitData(data, bestFeature);
    final remainingFeatures = List<String>.from(availableFeatures)..remove(bestFeature);

    subsets.forEach((featureValue, subset) {
      node.children![featureValue] = buildTree(subset, remainingFeatures);
    });

    return node;
  }

  double _calculateEntropy(List<String> targetValues) {
    if (targetValues.isEmpty) return 0.0;

    final Map<String, int> counts = {};
    for (var value in targetValues) {
      counts[value] = (counts[value] ?? 0) + 1;
    }

    double entropy = 0.0;
    final total = targetValues.length;
    for (var count in counts.values) {
      final probability = count / total;
      entropy -= probability * (log(probability) / ln2);
    }
    return entropy;
  }

  double _calculateInformationGain(List<Map<String, String>> data, String feature, double currentEntropy) {
    final subsets = _splitData(data, feature);
    double subsetEntropy = 0.0;
    final total = data.length;

    subsets.forEach((_, subset) {
      final weight = subset.length / total;
      final targetValues = subset.map((row) => row[targetColumn]!).toList();
      subsetEntropy += weight * _calculateEntropy(targetValues);
    });

    return currentEntropy - subsetEntropy;
  }

  Map<String, List<Map<String, String>>> _splitData(List<Map<String, String>> data, String feature) {
    final Map<String, List<Map<String, String>>> subsets = {};
    for (var row in data) {
      final val = row[feature]!;
      subsets.putIfAbsent(val, () => []).add(row);
    }
    return subsets;
  }

  String _getMostFrequentClass(List<String> targetValues) {
    final Map<String, int> counts = {};
    for (var value in targetValues) {
      counts[value] = (counts[value] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  String predict(DecisionTreeNode node, Map<String, String> input) {
    if (node.isLeaf) {
      return node.predictedClass!;
    }

    final featureValue = input[node.splitFeature];
    final nextNode = node.children![featureValue];

    if (nextNode == null) {
      return "Неизвестная ситуация (мало данных)"; 
    }

    return predict(nextNode, input);
  }
}