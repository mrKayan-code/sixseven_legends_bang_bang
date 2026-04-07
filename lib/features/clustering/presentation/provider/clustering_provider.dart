import 'package:flutter/material.dart';
import 'package:mapjacks/features/clustering/data/datasources/food_points_data_source.dart';

import 'package:mapjacks/features/clustering/domain/entities/food_point.dart';
import 'package:mapjacks/features/clustering/domain/entities/clustering_result.dart';
import 'package:mapjacks/features/clustering/domain/usecases/cluster_food_points.dart';

enum ClusteringStatus { initial, loading, success, error }

class ClusteringProvider extends ChangeNotifier {
  final ClusterFoodPoints _clusterFoodPoints;

  List<FoodPoint> _points = [];
  ClusteringResult? _result;
  ClusteringStatus _status = ClusteringStatus.initial;
  String? _error;
  int _k = 3;
  bool _useAStar = false;

  List<FoodPoint> get points => _points;
  ClusteringResult? get result => _result;
  ClusteringStatus get status => _status;
  String? get error => _error;
  int get k => _k;
  bool get useAStar => _useAStar;
  bool get isReady => _points.isNotEmpty;

  ClusteringProvider({required ClusterFoodPoints clusterFoodPoints})
      : _clusterFoodPoints = clusterFoodPoints;

  Future<void> loadFoodPoints(String assetPath) async {
    _status = ClusteringStatus.loading;
    notifyListeners();

    try {
      final dataSource = FoodPointsDataSourceImpl();
      _points = await dataSource.loadFoodPoints(assetPath);
      
      debugPrint('Загружено ${_points.length} заведений');
      _status = ClusteringStatus.initial;
    } catch (e) {
      _status = ClusteringStatus.error;
      _error = e.toString();
      debugPrint('Ошибка загрузки: $e');
    }
    
    notifyListeners();
  }

  Future<void> runClustering() async {
    if (_points.isEmpty) {
      _error = 'Нет данных';
      notifyListeners();
      return;
    }

    _status = ClusteringStatus.loading;
    notifyListeners();

    final result = await _clusterFoodPoints(
      points: _points,
      k: _k,
      useAStar: _useAStar,
    );

    result.fold(
      (failure) {
        _status = ClusteringStatus.error;
        _error = failure.message;
        debugPrint('Ошибка кластеризации: ${failure.message}');
      },
      (clusteringResult) {
        _result = clusteringResult;
        _status = ClusteringStatus.success;
        debugPrint('Кластеризация ${clusteringResult.clusters.length} кластеров, '
              '${clusteringResult.iterations} итераций');
      },
    );

    notifyListeners();
  }

  void setK(int value) {
    _k = value;
    notifyListeners();
  }

  void setUseAStar(bool value) {
    _useAStar = value;
    notifyListeners();
  }

  void clear() {
    _result = null;
    _status = ClusteringStatus.initial;
    _error = null;
    notifyListeners();
  }
}