import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';

class FoodPointModel extends FoodPoint {

  const FoodPointModel({
    required super.id,
    required super.name,
    required super.row,
    required super.col,
    required super.type
  });

  factory FoodPointModel.fromJson(Map<String, dynamic> json) {
    return FoodPointModel(
      id: json['id'] as String,
      name: json['name'] as String,
      row: json['row'] as int,
      col: json['col'] as int,
      type: json['type'] as String,
    );
  }

  static List<FoodPointModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => FoodPointModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}