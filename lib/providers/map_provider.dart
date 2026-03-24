import 'package:flutter/material.dart';
import '../models/map/map_layout.dart';

class MapProvider extends ChangeNotifier {
  MapLayout? _mapLayout;


  (int, int)? _startPoint;
  (int, int)? _endPoint;

  List<(int, int)>? _path;


  
  
  MapLayout? get mapLayout => _mapLayout;

  (int, int)? get startPoint =>  _startPoint;
  (int, int)? get endPoint =>_endPoint;

  List<(int, int)>? get path => _path;

  void handleMapTap(double mapX, double mapY) {
    if (_mapLayout == null) {
      return;
    }

    int row = (mapY / _mapLayout!.cellSize).floor();
    int col = (mapX / _mapLayout!.cellSize).floor();

    if (!_mapLayout!.isValidCell(row, col)) {
      return;
    }
  }


  Future<void> _tryFindPath() async {

    // TODO(колл  request await service response)
    // TODO(состояние поиска)
  }



}