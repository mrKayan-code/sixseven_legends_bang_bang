import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapjacks/features/ant_colony/presentation/provider/ant_colony_provider.dart';
import 'package:mapjacks/features/pathfinding/domain/entities/point.dart';
import 'package:mapjacks/features/pathfinding/presentation/provider/pathfinding_provider.dart';

class AntColonyMapCanvas extends StatelessWidget {
  final String imagePath;
  
  const AntColonyMapCanvas({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final pathProvider = context.watch<PathfindingProvider>();
    final antProvider = context.watch<AntColonyProvider>();

    final grid = pathProvider.grid;
    
    if (grid == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final size = Size(
      grid.cols * grid.cellSize.toDouble(),
      grid.rows * grid.cellSize.toDouble(),
    );

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(100),
      constrained: false,
      minScale: 0.5,
      maxScale: 4.0,
      child: Stack(children: [
        SizedBox(
          width: size.width, 
          height: size.height,
          child: Image.asset(imagePath, fit: BoxFit.contain)
        ),
        
        CustomPaint(
          size: size,
          painter: _AntColonyPainter(
            cellSize: grid.cellSize.toDouble(),
            points: antProvider.selectedPoints,
            route: antProvider.optimalRoute,
          ),
        ),
        
        SizedBox(
          width: size.width, 
          height: size.height,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapUp: (d) {
              final c = (d.localPosition.dx / grid.cellSize).floor();
              final r = (d.localPosition.dy / grid.cellSize).floor();
              antProvider.addPoint(Point(row: r, col: c));
            },
          ),
        ),
      ]),
    );
  }
}

class _AntColonyPainter extends CustomPainter {
  final double cellSize;
  final List<Point> points;
  final List<Point> route;

  _AntColonyPainter({
    required this.cellSize,
    required this.points,
    required this.route,
  });

  @override
  void paint(Canvas c, Size s) {
    if (route.isNotEmpty && route.length > 1) _drawRoute(c);
    
    for (int i = 0; i < points.length; i++) {
      _drawDot(points[i], i == 0 ? Colors.blue : Colors.green, c);
    }
  }

  void _drawRoute(Canvas c) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pts = route
        .map((p) => Offset(p.col * cellSize + cellSize/2, p.row * cellSize + cellSize/2))
        .toList();

    for (var i = 0; i < pts.length - 1; i++) {
      c.drawLine(pts[i], pts[i+1], paint);
    }
    // c.drawLine(pts.last, pts.first, paint);
  }

  void _drawDot(Point p, Color color, Canvas c) {
    final center = Offset(p.col * cellSize + cellSize/2, p.row * cellSize + cellSize/2);
    final r = cellSize / 2;
    c.drawCircle(center, r, Paint()..color = color);
    c.drawCircle(center, r, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _AntColonyPainter oldDelegate) => true; 
}