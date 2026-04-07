import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NeuralNetwork {
  late List<List<double>> _w1;
  late List<double> _b1;
  late List<List<double>> _w2;
  late List<double> _b2;

  bool _loaded = false;
  double lastConfidence = 0.0;

  Future<void> loadWeights({
    String assetPath = 'assets/mnist_weights.json',
  }) async {
    try {
      final String raw = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> json =
          jsonDecode(raw) as Map<String, dynamic>;

      if (!json.containsKey('fc1') || !json.containsKey('fc2')) {
        throw Exception('Файл весов пустой или имеет неверный формат. '
            'Запустите python_tools/train_and_export.py');
      }

      _parseWeights(json);
      _loaded = true;
      debugPrint('[NeuralNetwork] Веса загружены: '
          'w1=${_w1.length}×${_w1[0].length}, '
          'w2=${_w2.length}×${_w2[0].length}');
    } catch (e) {
      debugPrint('[NeuralNetwork] Ошибка: $e');
      debugPrint('[NeuralNetwork] Случайные веса (режим разработки).');
      _initRandom();
      _loaded = true;
    }
  }

  void _parseWeights(Map<String, dynamic> json) {
    final fc1 = json['fc1'] as Map<String, dynamic>;
    _w1 = _mat(fc1['weights'] as List);
    _b1 = _vec(fc1['biases'] as List);

    final fc2 = json['fc2'] as Map<String, dynamic>;
    _w2 = _mat(fc2['weights'] as List);
    _b2 = _vec(fc2['biases'] as List);

    if (_w1[0].length != 784) {
      throw Exception(
          'w1 должна иметь 784 столбца (28×28), получено ${_w1[0].length}. '
          'Перегенерируйте mnist_weights.json скриптом train_and_export.py');
    }
    if (_w2[0].length != _w1.length) {
      throw Exception(
          'w2 столбцов (${_w2[0].length}) ≠ w1 строк (${_w1.length})');
    }
    if (_w2.length != 10) {
      throw Exception('w2 должна иметь 10 строк, получено ${_w2.length}');
    }
  }

  List<List<double>> _mat(List raw) => raw
      .map((row) =>
          (row as List).map((v) => (v as num).toDouble()).toList())
      .toList();

  List<double> _vec(List raw) =>
      raw.map((v) => (v as num).toDouble()).toList();

  void _initRandom() {
    const int hidden = 128;
    final rng = math.Random(42);
    double r() => (rng.nextDouble() - 0.5) * 0.1;

    _w1 = List.generate(hidden, (_) => List.generate(784, (_) => r()));
    _b1 = List.generate(hidden, (_) => r());
    _w2 = List.generate(10, (_) => List.generate(hidden, (_) => r()));
    _b2 = List.generate(10, (_) => r());
  }

  int predict(List<double> grid50x50) {
    assert(grid50x50.length == kGridSize * kGridSize);
    if (!_loaded) return -1;

    final List<double> input28 = _downsample(grid50x50, 50, 28);

    final List<double> h1     = _relu(_linear(_w1, input28, _b1));
    final List<double> logits = _linear(_w2, h1, _b2);
    final List<double> probs  = _softmax(logits);

    final int digit = _argmax(probs);
    lastConfidence = probs[digit];
    return digit;
  }

  List<double> _downsample(List<double> src, int srcW, int dstW) {
    final List<double> dst = List<double>.filled(dstW * dstW, 0.0);
    final double scale = srcW / dstW;

    for (int dy = 0; dy < dstW; dy++) {
      for (int dx = 0; dx < dstW; dx++) {
        final double x0 = dx * scale;
        final double y0 = dy * scale;
        final double x1 = x0 + scale;
        final double y1 = y0 + scale;

        double sum = 0.0, weight = 0.0;
        for (int sy = y0.floor(); sy < y1.ceil(); sy++) {
          for (int sx = x0.floor(); sx < x1.ceil(); sx++) {
            if (sx < 0 || sx >= srcW || sy < 0 || sy >= srcW) continue;
            final double wx =
                math.min(sx + 1.0, x1) - math.max(sx.toDouble(), x0);
            final double wy =
                math.min(sy + 1.0, y1) - math.max(sy.toDouble(), y0);
            final double w = wx * wy;
            sum += src[sy * srcW + sx] * w;
            weight += w;
          }
        }
        dst[dy * dstW + dx] = weight > 0 ? sum / weight : 0.0;
      }
    }
    return dst;
  }

  List<double> _linear(
      List<List<double>> weights, List<double> input, List<double> bias) {
    final int outN = weights.length;
    final List<double> out = List<double>.filled(outN, 0.0);
    for (int i = 0; i < outN; i++) {
      double s = bias[i];
      final List<double> row = weights[i];
      for (int j = 0; j < input.length; j++) {
        s += row[j] * input[j];
      }
      out[i] = s;
    }
    return out;
  }

  List<double> _relu(List<double> x) =>
      x.map((v) => v > 0.0 ? v : 0.0).toList();

  List<double> _softmax(List<double> x) {
    final double m = x.reduce(math.max);
    final exps = x.map((v) => math.exp(v - m)).toList();
    final double sum = exps.reduce((a, b) => a + b);
    return exps.map((v) => v / sum).toList();
  }

  int _argmax(List<double> x) {
    int best = 0;
    for (int i = 1; i < x.length; i++) {
      if (x[i] > x[best]) best = i;
    }
    return best;
  }
}

const int kGridSize = 50;
