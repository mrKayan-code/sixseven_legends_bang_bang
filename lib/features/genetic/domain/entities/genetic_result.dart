import 'package:equatable/equatable.dart';
import 'route.dart';

class GeneticResult extends Equatable {
  final Route bestRoute;
  final int generations;
  final double bestFitness;
  final double averageFitness;

  const GeneticResult({
    required this.bestRoute,
    required this.generations,
    this.bestFitness = 0,
    this.averageFitness = 0,
  });

  @override
  List<Object?> get props => [bestRoute, generations, bestFitness, averageFitness];
}