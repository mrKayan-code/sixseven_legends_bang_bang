import 'package:equatable/equatable.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';

class FoodPoint extends Equatable {
  final String id;
  final String name;
  final int row;
  final int col;
  final String type;

  const FoodPoint({
    required this.id,
    required this.name,
    required this.row,
    required this.col,
    required this.type,
  });

  Point toPoint() => Point(row: row, col: col);

  @override
  List<Object> get props => [id, row, col];

  @override
  String toString() => '($id) food point $name $row:$col $type';
}