import 'package:flutter/material.dart';
class MapLayout{
  final List<List<int>> matrix;
  final int cellSize;
  final int rows;
  final int cols;

  MapLayout({
    required this.matrix,
    required this.cellSize,
    required this.rows,
    required this.cols,
  });

  factory MapLayout.fromJson(Map<String, dynamic> json) {
    List<List<int>> matrix = [];
    var matrixJson = json['matrix'] as List;

    for (var row in matrixJson) {
      if (row is List) {

        matrix.add(row.map((e) => (e as int)).toList());
      }
    }

    // if (matrix.isNotEmpty) {
    //   debugPrint('карта загрузилась и она не пустая');
    // }

    var config = json['config'] as Map<String, dynamic>;

    return MapLayout(
      matrix: matrix,
      cellSize: config['cellSize'] as int,
      rows: config['rows'] as int,
      cols: config['cols'] as int
    );
  }

  bool isValidCell(int row, int col) {
    if (row < 0 || row >= rows || col < 0 || col >= cols) {
      return false;
    }
    
    return true;
  }

  int getCellWeight(int row, int col) => matrix[row][col];

}