import 'package:flutter/material.dart';
import 'package:mapjacks/features/ant_colony/data/services/ant_colony_service.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';

class AntColonyProvider extends ChangeNotifier {
  final AntColonyService _service;

  AntColonyProvider(this._service);

  List<Point> selectedPoints = [];
  List<Point> optimalRoute = [];
  bool isCalculating = false;

  void addPoint(Point point) {
    selectedPoints.add(point);
    optimalRoute.clear();
    notifyListeners();
  }

  void clearPoints() {
    selectedPoints.clear();
    optimalRoute.clear();
    notifyListeners();
  }

  void calculateRoute() async {
    if (selectedPoints.length < 2) return;

    isCalculating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    optimalRoute = _service.findOptimalRoute(selectedPoints);
    
    isCalculating = false;
    notifyListeners();
  }
}