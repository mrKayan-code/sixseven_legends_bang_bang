import 'dart:math';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';

class AntColonyService {
  final int numAnts = 15;
  final int maxIterations = 50;
  final double alpha = 1.0;
  final double beta = 3.0;
  final double evaporationRate = 0.5;
  final double q = 100.0;

  List<Point> findOptimalRoute(List<Point> nodes) {
    if (nodes.length <= 2) return nodes;

    int n = nodes.length;
    List<List<double>> distances = List.generate(n, (_) => List.filled(n, 0.0));
    List<List<double>> pheromones = List.generate(n, (_) => List.filled(n, 1.0));

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (i != j) {
          distances[i][j] = sqrt(pow(nodes[i].row - nodes[j].row, 2) + pow(nodes[i].col - nodes[j].col, 2));
        }
      }
    }

    List<int> bestGlobalPath = [];
    double bestGlobalLength = double.infinity;
    final random = Random();

    for (int iter = 0; iter < maxIterations; iter++) {
      List<List<int>> antPaths = [];
      List<double> antLengths = [];

      for (int ant = 0; ant < numAnts; ant++) {
        List<int> path = [];
        List<bool> visited = List.filled(n, false);

        int currentNode = 0;
        path.add(currentNode);
        visited[currentNode] = true;

        for (int step = 1; step < n; step++) {
          int nextNode = _selectNextNode(currentNode, visited, n, pheromones, distances, random);
          path.add(nextNode);
          visited[nextNode] = true;
          currentNode = nextNode;
        }

        double length = _calculatePathLength(path, distances);
        antPaths.add(path);
        antLengths.add(length);

        if (length < bestGlobalLength) {
          bestGlobalLength = length;
          bestGlobalPath = List.from(path);
        }
      }

      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          pheromones[i][j] *= (1.0 - evaporationRate);
        }
      }
      for (int k = 0; k < numAnts; k++) {
        double pheromoneDelta = q / antLengths[k];
        List<int> path = antPaths[k];
        for (int i = 0; i < path.length - 1; i++) {
          int from = path[i];
          int to = path[i + 1];
          pheromones[from][to] += pheromoneDelta;
          pheromones[to][from] += pheromoneDelta;
        }
      }
    }

    return bestGlobalPath.map((index) => nodes[index]).toList();
  }

  int _selectNextNode(int current, List<bool> visited, int n, List<List<double>> pheromones, List<List<double>> distances, Random random) {
    List<double> probabilities = List.filled(n, 0.0);
    double sum = 0.0;

    for (int i = 0; i < n; i++) {
      if (!visited[i]) {
        double pheromone = pow(pheromones[current][i], alpha).toDouble();
        double visibility = pow(1.0 / distances[current][i], beta).toDouble();
        probabilities[i] = pheromone * visibility;
        sum += probabilities[i];
      }
    }

    double randVal = random.nextDouble() * sum;
    double cumulative = 0.0;
    for (int i = 0; i < n; i++) {
      if (!visited[i]) {
        cumulative += probabilities[i];
        if (randVal <= cumulative) return i;
      }
    }
    for (int i = 0; i < n; i++) {
      if (!visited[i]) return i;
    }
    return -1;
  }

  double _calculatePathLength(List<int> path, List<List<double>> distances) {
    double len = 0.0;
    for (int i = 0; i < path.length - 1; i++) {
      len += distances[path[i]][path[i + 1]];
    }
    return len;
  }
}