import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:equatable/equatable.dart';
import 'food_point.dart';
import 'package:flutter/material.dart';

class Cluster extends Equatable {
  final int id;
  final Point centroid;
  final List<FoodPoint> points;
  final Color color;
  
  const Cluster({
    required this.id,
    required this.centroid,
    required this.points,
    required this.color,
  });
  
  @override
  List<Object?> get props => [id, centroid, points];
}