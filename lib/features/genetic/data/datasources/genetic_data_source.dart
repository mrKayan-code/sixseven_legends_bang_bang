import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/clustering/data/models/food_point_model.dart';

abstract class GeneticDataSource {
  Future<List<FoodPointModel>> loadFoodPointsWithMenu(String assetPath);
}

class GeneticDataSourceImpl implements GeneticDataSource {
  @override
  Future<List<FoodPointModel>> loadFoodPointsWithMenu(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as List<dynamic>;
      return FoodPointModel.fromJsonList(jsonData);
    } on PlatformException {
      throw GeneticFailure(message: 'Не удалось загрузить файл: $assetPath');
    } on FormatException {
      throw GeneticFailure(message: 'Неверный формат JSON: $assetPath');
    }
  }
}