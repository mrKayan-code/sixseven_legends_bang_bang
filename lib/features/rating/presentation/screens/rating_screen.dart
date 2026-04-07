import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/rating_provider.dart';
import 'package:mapjacks/core/widgets/scaffold_with_navbar.dart';
import 'package:mapjacks/core/routes/app_routes.dart';

class GridPainter extends CustomPainter {
  final List<double> pixels;
  const GridPainter(this.pixels);

  @override
  void paint(Canvas canvas, Size size) {
    final double cw = size.width / 50;
    final double ch = size.height / 50;
    final Paint p = Paint()..isAntiAlias = false;

    p.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), p);

    for (int y = 0; y < 50; y++) {
      for (int x = 0; x < 50; x++) {
        final double v = pixels[y * 50 + x];
        if (v == 0.0) continue;
        final int g = (255 * (1.0 - v)).round().clamp(0, 255);
        p.color = Color.fromARGB(255, g, g, g);
        canvas.drawRect(Rect.fromLTWH(x * cw, y * ch, cw + 0.5, ch + 0.5), p);
      }
    }

    p..color = const Color(0x18000000)..strokeWidth = 0.3..style = PaintingStyle.stroke;
    for (int i = 0; i <= 50; i++) {
      canvas.drawLine(Offset(i * cw, 0), Offset(i * cw, size.height), p);
      canvas.drawLine(Offset(0, i * ch), Offset(size.width, i * ch), p);
    }
  }

  @override
  bool shouldRepaint(GridPainter _) => true;
}

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final TextEditingController _placeController = TextEditingController();
  int? _prevGx, _prevGy;

  void _paintAt(int gx, int gy, List<double> currentPixels) {
    final strokes = [
      [0, 0, 1.0], [-1, 0, 0.6], [1, 0, 0.6], [0, -1, 0.6], [0, 1, 0.6],
      [-1, -1, 0.3], [1, -1, 0.3], [-1, 1, 0.3], [1, 1, 0.3],
    ];
    for (final s in strokes) {
      final int nx = gx + (s[0] as int);
      final int ny = gy + (s[1] as int);
      final double val = s[2] as double;
      if (nx < 0 || nx >= 50 || ny < 0 || ny >= 50) continue;
      final int idx = ny * 50 + nx;
      if (currentPixels[idx] < val) currentPixels[idx] = val;
    }
  }

  void _bresenham(int x0, int y0, int x1, int y1, List<double> currentPixels) {
    int dx = (x1 - x0).abs(), dy = (y1 - y0).abs();
    int sx = x0 < x1 ? 1 : -1, sy = y0 < y1 ? 1 : -1;
    int err = dx - dy;
    while (true) {
      _paintAt(x0, y0, currentPixels);
      if (x0 == x1 && y0 == y1) break;
      int e2 = 2 * err;
      if (e2 > -dy) { err -= dy; x0 += sx; }
      if (e2 < dx)  { err += dx; y0 += sy; }
    }
  }

  void _handlePan(Offset pos, double side, RatingProvider provider) {
    final double cell = side / 50;
    final int gx = (pos.dx / cell).floor().clamp(0, 49);
    final int gy = (pos.dy / cell).floor().clamp(0, 49);

    List<double> currentPixels = List.from(provider.pixels);

    if (_prevGx != null && _prevGy != null) {
      _bresenham(_prevGx!, _prevGy!, gx, gy, currentPixels);
    } else {
      _paintAt(gx, gy, currentPixels);
    }

    provider.updatePixels(currentPixels);
    _prevGx = gx;
    _prevGy = gy;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RatingProvider>();
    final size = MediaQuery.of(context).size;
    final double canvasSide = (size.width * 0.7).clamp(200.0, 400.0);

    return ScaffoldWithNavBar(
      currentRoute: AppRoutes.rating,
      appBar: AppBar(title: const Text('Оценить заведение')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _placeController,
              decoration: const InputDecoration(
                labelText: 'Название (напр. Ярче)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.storefront),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Нарисуйте оценку (цифру):', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            Container(
              width: canvasSide, height: canvasSide,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: GestureDetector(
                onPanStart: (d) { _prevGx = null; _prevGy = null; },
                onPanUpdate: (d) => _handlePan(d.localPosition, canvasSide, provider),
                onPanEnd: (_) {
                  _prevGx = null; _prevGy = null;
                  provider.predictRating(); 
                },
                child: CustomPaint(
                  painter: GridPainter(provider.pixels),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (provider.predictedRating != null) ...[
              Text(
                'Нейросеть видит оценку: ${provider.predictedRating}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  if (_placeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Сначала введите название заведения!')),
                    );
                    return;
                  }
                  provider.saveCurrentRating(_placeController.text);
                  _placeController.clear();
                },
                icon: const Icon(Icons.save),
                label: const Text('Сохранить оценку'),
              )
            ],

            TextButton.icon(
              onPressed: provider.clearCanvas,
              icon: const Icon(Icons.refresh),
              label: const Text('Очистить холст'),
            ),

            const Divider(height: 40),
            const Text('Последние оценки:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ...provider.savedRatings.map((e) => ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: Text(e.placeName),
              trailing: Text(e.rating.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ),
    );
  }
}