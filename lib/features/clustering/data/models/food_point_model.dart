import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/genetic/domain/entities/food_item.dart';

class FoodPointModel extends FoodPoint {

  const FoodPointModel({
    required super.id,
    required super.name,
    required super.row,
    required super.col,
    required super.type,
    super.menu,
    super.hasUtensils,
  });

  factory FoodPointModel.fromJson(Map<String, dynamic> json) {
    final menuJson = json['menu'] as List<dynamic>? ?? [];
    final menu = menuJson
        .map((item) => FoodItemTypeExtension.fromString(item as String))
        .whereType<FoodItemType>()
        .toList();

    return FoodPointModel(
      id: json['id'] as String,
      name: json['name'] as String,
      row: json['row'] as int,
      col: json['col'] as int,
      type: json['type'] as String,
      menu: menu,
      hasUtensils: json['has_utensils'] as bool? ?? false,
    );
  }

  static List<FoodPointModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => FoodPointModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}