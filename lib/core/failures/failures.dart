abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class MapLoadFailure extends Failure {
  const MapLoadFailure({required super.message});
}

class PathfindingFailure extends Failure {
  const PathfindingFailure({required super.message});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}