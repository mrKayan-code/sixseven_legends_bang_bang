import 'dart:math';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/genetic/domain/entities/food_item.dart';
import 'package:mapjacks/features/genetic/domain/entities/route.dart';
import 'package:mapjacks/features/genetic/domain/entities/genetic_result.dart';

class GeneticAlgorithmService {
  static const double _walkingSpeed = 5000 / 60;
  static const int _defaultPopulationSize = 50;
  static const int _defaultMaxGenerations = 100;
  static const double _defaultMutationRate = 0.1;

  Future<GeneticResult> findOptimalRoute({
    required List<FoodPoint> allPoints,
    required List<FoodItemType> requiredItems,
    required Point start,
    int populationSize = _defaultPopulationSize,
    int maxGenerations = _defaultMaxGenerations,
    double mutationRate = _defaultMutationRate,
  }) async {
    final itemToPoints = <FoodItemType, List<FoodPoint>>{};
    for (final item in requiredItems) {
      final points = allPoints.where((p) => p.hasItem(item)).toList();
      itemToPoints[item] = points;
    }

    var population = _createInitialPopulation(
      itemToPoints: itemToPoints,
      start: start,
      size: populationSize,
    );

    var bestRoute = population.first;
    var bestFitness = _calculateFitness(bestRoute, start);
    var averageFitness = bestFitness;

    for (var generation = 0; generation < maxGenerations; generation++) {
      population.sort((a, b) => _calculateFitness(b, start).compareTo(_calculateFitness(a, start)));
      final topHalf = population.take(population.length ~/ 2).toList();

      final newPopulation = <Route>[...topHalf];
      while (newPopulation.length < populationSize) {
        final parent1 = topHalf[Random().nextInt(topHalf.length)];
        final parent2 = topHalf[Random().nextInt(topHalf.length)];
        var child = _crossover(parent1, parent2);
        child = _mutate(child, mutationRate);
        newPopulation.add(child);
      }

      population = newPopulation;

      final currentBest = population.reduce((a, b) => 
        _calculateFitness(a, start) > _calculateFitness(b, start) ? a : b);
      final currentFitness = _calculateFitness(currentBest, start);
      
      if (currentFitness > bestFitness) {
        bestRoute = currentBest;
        bestFitness = currentFitness;
      }
      
      averageFitness = population.map((r) => _calculateFitness(r, start)).reduce((a, b) => a + b) / population.length;
    }

    final finalRoute = _calculateRouteDistances(bestRoute, start);

    return GeneticResult(
      bestRoute: finalRoute,
      generations: maxGenerations,
      bestFitness: bestFitness,
      averageFitness: averageFitness,
    );
  }

  List<Route> _createInitialPopulation({
    required Map<FoodItemType, List<FoodPoint>> itemToPoints,
    required Point start,
    required int size,
  }) {
    final population = <Route>[];
    final random = Random();

    for (var i = 0; i < size; i++) {
      final points = <FoodPoint>[];
      final usedIds = <String>{};

      itemToPoints.forEach((item, options) {
        final available = options.where((p) => !usedIds.contains(p.id)).toList();
        if (available.isNotEmpty) {
          final selected = available[random.nextInt(available.length)];
          points.add(selected);
          usedIds.add(selected.id);
        } else if (options.isNotEmpty) {
          points.add(options[random.nextInt(options.length)]);
        }
      });

      points.shuffle(random);
      population.add(Route(points: points));
    }

    return population;
  }

  Route _crossover(Route parent1, Route parent2) {
    if (parent1.points.isEmpty || parent2.points.isEmpty) {
      return parent1;
    }

    final random = Random();
    final crossPoint = random.nextInt(parent1.points.length);
    
    final childPoints = <FoodPoint>[
      ...parent1.points.take(crossPoint),
      ...parent2.points.skip(crossPoint),
    ];

    final uniquePoints = <FoodPoint>[];
    final seenIds = <String>{};
    for (final p in childPoints) {
      if (!seenIds.contains(p.id)) {
        uniquePoints.add(p);
        seenIds.add(p.id);
      }
    }

    final parent1Ids = parent1.points.map((p) => p.id).toSet();
    for (final p in parent2.points) {
      if (!seenIds.contains(p.id) && parent1Ids.contains(p.id)) {
        uniquePoints.add(p);
        seenIds.add(p.id);
      }
    }

    return Route(points: uniquePoints);
  }

  Route _mutate(Route route, double mutationRate) {
    if (route.points.length < 2) return route;

    final random = Random();
    final points = [...route.points];

    if (random.nextDouble() < mutationRate) {
      final i = random.nextInt(points.length);
      final j = random.nextInt(points.length);
      if (i != j) {
        final temp = points[i];
        points[i] = points[j];
        points[j] = temp;
      }
    }

    return Route(points: points);
  }

  double _calculateFitness(Route route, Point start) {
    if (route.points.isEmpty) return 0;
    
    var totalDistance = 0.0;
    var current = start;

    for (final point in route.points) {
      final dx = (point.col - current.col).toDouble();
      final dy = (point.row - current.row).toDouble();
      totalDistance += sqrt(dx * dx + dy * dy);
      current = Point(row: point.row, col: point.col);
    }

    return totalDistance > 0 ? 1000 / totalDistance : 0;
  }

  Route _calculateRouteDistances(Route route, Point start) {
    if (route.points.isEmpty) return route;

    var totalDistance = 0.0;
    var current = start;

    for (final point in route.points) {
      final dx = (point.col - current.col).toDouble();
      final dy = (point.row - current.row).toDouble();
      totalDistance += sqrt(dx * dx + dy * dy);
      current = Point(row: point.row, col: point.col);
    }

    final estimatedTime = totalDistance / _walkingSpeed;

    return Route(
      points: route.points,
      totalDistance: totalDistance,
      estimatedTime: estimatedTime,
    );
  }
}