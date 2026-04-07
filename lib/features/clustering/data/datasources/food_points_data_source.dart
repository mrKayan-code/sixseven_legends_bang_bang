import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/clustering/data/models/food_point_model.dart';

abstract class FoodPointsDataSource {
  Future<List<FoodPointModel>> loadFoodPoints(String assetPath);
}

class FoodPointsDataSourceImpl implements FoodPointsDataSource {
  @override
  Future<List<FoodPointModel>> loadFoodPoints(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as List<dynamic>;
      return FoodPointModel.fromJsonList(jsonData);
    } on PlatformException {
      throw MapLoadFailure(message: 'Не удалось загрузить файл: $assetPath');
    } on FormatException {
      throw MapLoadFailure(message: 'Неверный формат JSON: $assetPath');
    }
  }
}