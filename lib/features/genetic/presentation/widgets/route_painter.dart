import 'package:flutter/material.dart' hide Route;
import 'package:mapjacks/features/genetic/domain/entities/route.dart';

class RoutePainter extends CustomPainter {
  final Route route;
  final double cellSize;

  RoutePainter({required this.route, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    if (route.points.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    Offset? last;

    for (final point in route.points) {
      final x = point.col * cellSize + cellSize / 2;
      final y = point.row * cellSize + cellSize / 2;
      final offset = Offset(x, y);

      if (last == null) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      last = offset;
    }

    canvas.drawPath(path, paint);

    for (var i = 0; i < route.points.length; i++) {
      final point = route.points[i];
      final x = point.col * cellSize + cellSize / 2;
      final y = point.row * cellSize + cellSize / 2;

      final pointPaint = Paint()..color = Colors.blue;
      canvas.drawCircle(Offset(x, y), cellSize * 0.8, pointPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - 6, y - 8));
    }
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) {
    return oldDelegate.route != route;
  }
}