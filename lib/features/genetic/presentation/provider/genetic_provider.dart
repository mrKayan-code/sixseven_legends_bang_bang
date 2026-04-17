import 'package:flutter/material.dart';
import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:mapjacks/features/genetic/domain/entities/food_item.dart';
import 'package:mapjacks/features/genetic/domain/entities/genetic_result.dart';
import 'package:mapjacks/features/genetic/domain/usecases/find_optimal_route.dart';
import 'package:mapjacks/features/genetic/data/datasources/genetic_data_source.dart';

enum GeneticStatus { initial, loading, success, error }

class GeneticProvider extends ChangeNotifier {
  final FindOptimalRoute _findOptimalRoute;

  List<FoodPoint> _allPoints = [];
  List<FoodItemType> _selectedItems = [];
  GeneticResult? _result;
  GeneticStatus _status = GeneticStatus.initial;
  String? _error;
  bool _requireUtensils = false;
  Point? _startPoint;

  List<FoodPoint> get allPoints => _allPoints;
  List<FoodItemType> get selectedItems => _selectedItems;
  GeneticResult? get result => _result;
  GeneticStatus get status => _status;
  String? get error => _error;
  bool get requireUtensils => _requireUtensils;
  Point? get startPoint => _startPoint;
  bool get isReady => _allPoints.isNotEmpty;

  GeneticProvider({required FindOptimalRoute findOptimalRoute})
      : _findOptimalRoute = findOptimalRoute;

  Future<void> loadFoodPoints(String assetPath) async {
    _status = GeneticStatus.loading;
    notifyListeners();

    try {
      final dataSource = GeneticDataSourceImpl();
      _allPoints = await dataSource.loadFoodPointsWithMenu(assetPath);
      _status = GeneticStatus.initial;
      debugPrint('Загружено ${_allPoints.length} заведений');
    } catch (e) {
      _status = GeneticStatus.error;
      _error = e.toString();
      debugPrint('Ошибка: $e');
    }
    notifyListeners();
  }

  void toggleItem(FoodItemType item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    _result = null;
    notifyListeners();
  }

  void setPreset(List<FoodItemType> preset) {
    _selectedItems = [...preset];
    _result = null;
    notifyListeners();
  }

  void setRequireUtensils(bool value) {
    _requireUtensils = value;
    notifyListeners();
  }

  void setStartPoint(Point point) {
    _startPoint = point;
    notifyListeners();
  }

  Future<void> findRoute() async {
    if (_allPoints.isEmpty || _selectedItems.isEmpty) {
      _error = 'Выберите блюда для поиска маршрута';
      notifyListeners();
      return;
    }

    _status = GeneticStatus.loading;
    notifyListeners();

    final start = _startPoint ?? Point(row: 100, col: 150);

    final result = await _findOptimalRoute(
      points: _allPoints,
      items: _selectedItems,
      start: start,
      requireUtensils: _requireUtensils,
    );

    result.fold(
      (failure) {
        _status = GeneticStatus.error;
        _error = failure.message;
      },
      (geneticResult) {
        _result = geneticResult;
        _status = GeneticStatus.success;
        print('Маршрут найден: ${geneticResult.bestRoute.pointsCount} точек, '
              '${geneticResult.bestRoute.totalDistance.toStringAsFixed(0)}м');
      },
    );
    notifyListeners();
  }

  void clear() {
    _result = null;
    _selectedItems = [];
    _status = GeneticStatus.initial;
    _error = null;
    notifyListeners();
  }
}