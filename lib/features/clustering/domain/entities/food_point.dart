import 'package:equatable/equatable.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:mapjacks/features/genetic/domain/entities/food_item.dart';

class FoodPoint extends Equatable {
  final String id;
  final String name;
  final int row;
  final int col;
  final String type;
  final List<FoodItemType> menu;
  final bool hasUtensils;

  const FoodPoint({
    required this.id,
    required this.name,
    required this.row,
    required this.col,
    required this.type,
    this.menu = const [],
    this.hasUtensils = false,
  });

  Point toPoint() => Point(row: row, col: col);

  bool hasItem(FoodItemType item) => menu.contains(item);

  bool hasAllItems(List<FoodItemType> items) => 
      items.every((item) => menu.contains(item));

  @override
  List<Object?> get props => [id, row, col, type, menu, hasUtensils];

  @override
  String toString() => '($id) food point $name $row:$col $type';
}