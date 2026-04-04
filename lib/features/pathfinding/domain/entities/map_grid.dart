import 'package:equatable/equatable.dart';

class MapGrid extends Equatable {
  final List<List<int>> matrix;
  final int cellSize;
  final int rows;
  final int cols;

  const MapGrid({
    required this.matrix,
    required this.cellSize,
    required this.rows,
    required this.cols,
  });

  bool isValidCell(int row, int col) =>
      row >= 0 && row < rows && col >= 0 && col < cols;

  int getCellWeight(int row, int col) {
    if (!isValidCell(row, col)) return 999;
    return matrix[row][col];
  }

  @override
  List<Object> get props => [matrix, cellSize, rows, cols];
}