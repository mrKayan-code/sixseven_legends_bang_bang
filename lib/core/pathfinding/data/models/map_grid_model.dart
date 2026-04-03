import '../../domain/entities/map_grid.dart';

class MapGridModel extends MapGrid {
  const MapGridModel({
    required super.matrix,
    required super.cellSize,
    required super.rows,
    required super.cols,
  });

  factory MapGridModel.fromJson(Map<String, dynamic> json) {
    final matrixJson = json['matrix'] as List;
    final config = json['config'] as Map<String, dynamic>;
    
    final matrix = matrixJson
        .map((row) => (row as List).map((e) => e as int).toList())
        .toList();

    return MapGridModel(
      matrix: matrix,
      cellSize: config['cellSize'] as int,
      rows: config['rows'] as int,
      cols: config['cols'] as int,
    );
  }
}