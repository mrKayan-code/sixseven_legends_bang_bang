import '../../domain/entities/map_grid.dart';

class MapConfigModel extends MapGrid {
  const MapConfigModel({
    required super.matrix,
    required super.cellSize,
    required super.rows,
    required super.cols,
  });

  factory MapConfigModel.fromJson(Map<String, dynamic> json) {
    final matrixJson = json['matrix'] as List;
    final config = json['config'] as Map<String, dynamic>;
    
    final matrix = matrixJson
        .map((row) => (row as List).map((e) => e as int).toList())
        .toList();

    return MapConfigModel(
      matrix: matrix,
      cellSize: config['cellSize'] as int,
      rows: config['rows'] as int,
      cols: config['cols'] as int,
    );
  }
}