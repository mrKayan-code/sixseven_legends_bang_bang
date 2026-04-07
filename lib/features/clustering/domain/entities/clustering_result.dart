import 'package:equatable/equatable.dart';
import 'package:mapjacks/features/clustering/domain/entities/cluster.dart';

class ClusteringResult extends Equatable {
  final List<Cluster> clusters;
  final int iterations;
  final bool converged;

  const ClusteringResult({
    required this.clusters,
    required this.iterations,
    this.converged = true,
  });

  int get totalPoints => clusters.fold(0, (sum, c) => sum + c.points.length);

  @override
  List<Object?> get props => [clusters, iterations, converged];
}