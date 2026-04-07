import 'package:flutter/material.dart';
import '../../data/services/neural_network.dart';

class PlaceRating {
  final String placeName;
  final int rating;
  PlaceRating(this.placeName, this.rating);
}

class RatingProvider extends ChangeNotifier {
  final NeuralNetwork _nn = NeuralNetwork();

  bool isReady = false;
  List<double> pixels = List<double>.filled(50 * 50, 0.0);
  int? predictedRating;

  final List<PlaceRating> savedRatings = [];

  RatingProvider() {
    _initNN();
  }

  Future<void> _initNN() async {
    await _nn.loadWeights(); 
    isReady = true;
    notifyListeners();
  }

  void updatePixels(List<double> newPixels) {
    pixels = newPixels;
    notifyListeners();
  }

  void predictRating() {
    if (!isReady) return;
    predictedRating = _nn.predict(List<double>.from(pixels));
    notifyListeners();
  }

  void clearCanvas() {
    pixels = List<double>.filled(50 * 50, 0.0);
    predictedRating = null;
    notifyListeners();
  }

  void saveCurrentRating(String placeName) {
    if (predictedRating != null && placeName.isNotEmpty) {
      savedRatings.add(PlaceRating(placeName, predictedRating!));
      clearCanvas();
    }
  }
}