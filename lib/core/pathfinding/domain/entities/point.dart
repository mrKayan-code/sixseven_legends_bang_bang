import 'package:equatable/equatable.dart';

class Point extends Equatable {
  final int row;
  final int col;

  const Point({required this.row, required this.col});

  @override
  List<Object> get props => [row, col];
  
  Point copyWith({int? row, int? col}) => 
      Point(row: row ?? this.row, col: col ?? this.col);
}