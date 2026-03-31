import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../failures/failures.dart';
import '../models/map_config_model.dart';

abstract class MapLocalDataSource {
  Future<MapConfigModel> loadMap(String assetPath);
}

class MapLocalDataSourceImpl implements MapLocalDataSource {
  @override
  Future<MapConfigModel> loadMap(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return MapConfigModel.fromJson(jsonData);
    } on PlatformException {
      throw MapLoadFailure(message: 'Не удалось загрузить файл карты');
    } on FormatException {
      throw MapLoadFailure(message: 'Неверный формат данных карты');
    }
  }
}