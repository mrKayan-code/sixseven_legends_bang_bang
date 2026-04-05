import 'package:collection/collection.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/map_grid.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/path.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';

class _Node {
  final Point point;
  final int g, h;
  final _Node? parent;
  
  _Node({required this.point, required this.g, required this.h, this.parent});

  int get f => g + h;
  
  @override
  bool operator ==(Object o) => o is _Node && o.point == point;
  @override
  int get hashCode => (point.row << 16) | point.col;
}

class AStarService {
  static const _straight = 10, _diagonal = 14, _maxIter = 130000;
  static const _dirs = [(-1,0),(1,0),(0,-1),(0,1),(-1,-1),(-1,1),(1,-1),(1,1)];

  Future<Path> find({
    required Point start,
    required Point end,
    required MapGrid grid,
  }) async {
    if (!grid.isValidCell(start.row, start.col) || 
        !grid.isValidCell(end.row, end.col)) {
      return const Path(points: []);
    }

    final openSet = PriorityQueue<_Node>((a, b) => a.f.compareTo(b.f));
    final closedSet = <int>{};
    var iter = 0;

    openSet.add(_Node(point: start, g: 0, h: _heuristic(start, end, grid)));

    while (openSet.isNotEmpty && iter < _maxIter) {
      iter++;
      await Future.microtask(() {});

      final current = openSet.removeFirst();
      if (current.point == end) {
        return Path(
          points: _reconstructPath(current),
          totalCost: current.g,
          iterations: iter,
        );
      }

      final hash = current.hashCode;
      if (closedSet.contains(hash)) continue;
      closedSet.add(hash);

      for (final neighbor in _neighbors(current.point, grid)) {
        if (closedSet.contains(neighbor.hashCode)) continue;
        
        final cost = _transitionCost(current.point, neighbor, grid);
        openSet.add(_Node(
          point: neighbor,
          g: current.g + cost,
          h: _heuristic(neighbor, end, grid),
          parent: current,
        ));
      }
    }
    return const Path(points: []);
  }

  List<Point> _reconstructPath(_Node? node) {
    final path = <Point>[];
    while (node != null) {
      path.add(node.point);
      node = node.parent;
    }
    return path.reversed.toList();
  }

  int _heuristic(Point a, Point b, MapGrid g) {
    final dx = (b.col - a.col).abs(), dy = (b.row - a.row).abs();
    return (dx + dy) * _straight + g.getCellWeight(a.row, a.col);
  }

  List<Point> _neighbors(Point p, MapGrid g) {
    return _dirs
        .map((d) => Point(row: p.row + d.$1, col: p.col + d.$2))
        .where((pt) => g.isValidCell(pt.row, pt.col))
        .toList();
  }

  int _transitionCost(Point from, Point to, MapGrid g) {
    final diag = (to.row - from.row).abs() + (to.col - from.col).abs() > 1;
    final base = diag ? _diagonal : _straight;
    return base + (g.getCellWeight(to.row, to.col) * _straight ~/ 100);
  }
}