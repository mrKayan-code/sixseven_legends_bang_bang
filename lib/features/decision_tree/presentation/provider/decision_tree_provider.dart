import 'package:flutter/material.dart';
import '../../domain/entities/decision_tree_node.dart';
import '../../data/services/decision_tree_service.dart';
import '../../data/datasources/csv_parser.dart';

class DecisionTreeProvider extends ChangeNotifier {
  DecisionTreeNode? _rootNode;
  String _predictionResult = '';

  String defaultCsvData = '''location,budget,time_available,food_type,queue_tolerance,weather,recommended_place
main_building,low,medium,full_meal,medium,good,Main_Cafeteria
main_building,low,short,snack,low,good,Yarche
main_building,medium,short,coffee,low,good,Bus_Stop_Coffee
main_building,high,medium,coffee,medium,good,Starbooks
second_building,low,very_short,snack,low,good,Vending_Machine
second_building,medium,short,coffee,medium,good,Second_Building_Cafe
second_building,medium,medium,full_meal,medium,good,Main_Cafeteria
second_building,low,short,snack,low,bad,Vending_Machine
campus_center,medium,short,pancakes,medium,good,Siberian_Pancakes''';

  DecisionTreeNode? get rootNode => _rootNode;
  String get predictionResult => _predictionResult;

  void trainTree(String csvText) {
    final parsedData = CsvParser.parse(csvText);
    final features = CsvParser.getFeatures(csvText, 'recommended_place');

    final service = DecisionTreeService(targetColumn: 'recommended_place');
    _rootNode = service.buildTree(parsedData, features);

    notifyListeners();
  }

  void makePrediction(Map<String, String> userInput) {
    if (_rootNode == null) {
      _predictionResult = 'Сначала нужно построить дерево!';
      notifyListeners();
      return;
    }

    final service = DecisionTreeService(targetColumn: 'recommended_place');
    _predictionResult = service.predict(_rootNode!, userInput);

    notifyListeners();
  }
}