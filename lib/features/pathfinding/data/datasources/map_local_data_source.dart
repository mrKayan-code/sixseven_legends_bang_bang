import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mapjacks/core/failures/failures.dart';
import 'package:mapjacks/features/pathfinding/data/models/map_grid_model.dart';

abstract class MapLocalDataSource {
  Future<MapGridModel> loadMap(String assetPath);
}

class MapLocalDataSourceImpl implements MapLocalDataSource {
  @override
  Future<MapGridModel> loadMap(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return MapGridModel.fromJson(jsonData);
    } on PlatformException {
      throw MapLoadFailure(message: 'Не удалось загрузить файл карты');
    } on FormatException {
      throw MapLoadFailure(message: 'Неверный формат данных карты');
    }
  }
}