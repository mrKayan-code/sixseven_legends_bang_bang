import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/point.dart';
import '../provider/pathfinding_provider.dart';

class MapCanvas extends StatelessWidget {
  final String imagePath;
  const MapCanvas({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Consumer<PathfindingProvider>(
      builder: (context, provider, _) {
        final grid = provider.grid;
        if (grid == null) {
          return const Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Загрузка карты...'),
            ]),
          );
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
            _MapImage(imagePath: imagePath, size: size),
            _PathOverlay(
              size: size,
              cellSize: grid.cellSize.toDouble(),
              path: provider.path?.points,
              start: provider.start,
              end: provider.end,
            ),
            _TapHandler(
              size: size,
              cellSize: grid.cellSize.toDouble(),
              onTap: (r, c) => provider.onMapTap(r, c),
            ),
          ]),
        );
      },
    );
  }
}

class _MapImage extends StatelessWidget {
  final String imagePath;
  final Size size;
  const _MapImage({required this.imagePath, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size.width, height: size.height,
        child: Image.asset(imagePath, fit: BoxFit.contain));
  }
}

class _PathOverlay extends StatelessWidget {
  final Size size;
  final double cellSize;
  final List<Point>? path;
  final Point? start, end;

  const _PathOverlay({
    required this.size,
    required this.cellSize,
    this.path,
    this.start,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _PathPainter(cellSize, path, start, end),
    );
  }
}

class _PathPainter extends CustomPainter {
  final double cellSize;
  final List<Point>? path;
  final Point? start, end;

  _PathPainter(this.cellSize, this.path, this.start, this.end);

  @override
  void paint(Canvas c, Size s) {
    if (path != null && path!.length > 1) _drawPath(c);
    if (start != null) _drawDot(start!, Colors.green, c);
    if (end != null) _drawDot(end!, Colors.red, c);
  }

  void _drawPath(Canvas c) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pts = path!
        .map((p) => Offset(p.col * cellSize + cellSize/2, p.row * cellSize + cellSize/2))
        .toList();

    for (var i = 0; i < pts.length - 1; i++) {
      c.drawLine(pts[i], pts[i+1], paint);
    }
    
    for (final pt in pts) {
      c.drawCircle(pt, 4, Paint()..color = Colors.blue);
    }
  }

  void _drawDot(Point p, Color color, Canvas c) {
    final center = Offset(p.col * cellSize + cellSize/2, p.row * cellSize + cellSize/2);
    final r = cellSize / 2;
    c.drawCircle(center, r, Paint()..color = color);
    c.drawCircle(center, r, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _PathPainter o) =>
      o.path != path || o.start != start || o.end != end;
}

class _TapHandler extends StatelessWidget {
  final Size size;
  final double cellSize;
  final void Function(int, int) onTap;

  const _TapHandler({required this.size, required this.cellSize, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size.width, height: size.height,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (d) {
          final c = (d.localPosition.dx / cellSize).floor();
          final r = (d.localPosition.dy / cellSize).floor();
          onTap(r, c);
        },
      ),
    );
  }
}