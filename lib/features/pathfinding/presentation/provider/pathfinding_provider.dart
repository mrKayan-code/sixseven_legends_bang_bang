import 'package:flutter/foundation.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/map_grid.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/path.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:mapjacks/features/pathfinding/domain/usecases/find_path.dart';
import 'package:mapjacks/features/pathfinding/domain/usecases/load_map_data.dart';

enum SelectionMode { none, start, end }
enum PathStatus { initial, loading, success, error }

class PathfindingProvider extends ChangeNotifier {
  final LoadMap _loadMap;
  final FindPath _findPath;

  MapGrid? _grid;
  Point? _start, _end;
  Path? _path;
  SelectionMode _mode = SelectionMode.none;
  PathStatus _status = PathStatus.initial;
  String? _error;

  MapGrid? get grid => _grid;
  Point? get start => _start;
  Point? get end => _end;
  Path? get path => _path;
  SelectionMode get mode => _mode;
  PathStatus get status => _status;
  String? get error => _error;

  PathfindingProvider({
    required LoadMap loadMap,
    required FindPath findPath,
  })  : _loadMap = loadMap,
        _findPath = findPath;

  Future<void> load(String assetPath) async {
    _status = PathStatus.loading;
    notifyListeners();

    final result = await _loadMap(assetPath);
    result.fold(
      (failure) {
        _status = PathStatus.error;
        _error = failure.message;
      },
      (grid) => _grid = grid,
    );
    notifyListeners();
  }

  void setMode(SelectionMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void onMapTap(int row, int col) {
    if (_grid == null || !_grid!.isValidCell(row, col)) return;
    final point = Point(row: row, col: col);

    switch (_mode) {
      case SelectionMode.start:
        _start = point;
        _tryFind();
        break;
      case SelectionMode.end:
        _end = point;
        _tryFind();
        break;
      case SelectionMode.none:
        break;
    }
    notifyListeners();
  }

  void _tryFind() {
    if (_start == null || _end == null || _grid == null) return;
    
    _status = PathStatus.loading;
    _error = null;
    notifyListeners();

    _findPath(start: _start!, end: _end!, grid: _grid!).then((result) {
      result.fold(
        (failure) {
          _status = PathStatus.error;
          _error = failure.message;
        },
        (path) {
          if (path.isValid) {
            _path = path;
            _status = PathStatus.success;
          } else {
            _status = PathStatus.error;
            _error = 'Маршрут не найден';
          }
        },
      );
      notifyListeners();
    });
  }

  void clear() {
    _start = _end = _path = null;
    _mode = SelectionMode.none;
    _status = PathStatus.initial;
    _error = null;
    notifyListeners();
  }
}