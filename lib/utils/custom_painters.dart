import 'package:flutter/material.dart';

class DiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF00f5d4),
          Color(0xFF00d4aa),
          Color(0xFF009688),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    // Create diamond shape
    path.moveTo(center.dx, 10); // Top
    path.lineTo(size.width - 10, center.dy); // Right
    path.lineTo(center.dx, size.height - 10); // Bottom
    path.lineTo(10, center.dy); // Left
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class InnerElementsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw triangle
    final trianglePath = Path();
    trianglePath.moveTo(center.dx, center.dy - 15);
    trianglePath.lineTo(center.dx - 12, center.dy + 8);
    trianglePath.lineTo(center.dx + 12, center.dy + 8);
    trianglePath.close();
    canvas.drawPath(trianglePath, paint);

    // Draw circle
    canvas.drawCircle(
      Offset(center.dx, center.dy - 8),
      3,
      paint,
    );

    // Draw square
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 3),
        width: 4,
        height: 4,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CornerBracketPainter extends CustomPainter {
  final bool isTopLeft;
  final bool isTopRight;
  final bool isBottomLeft;
  final bool isBottomRight;

  CornerBracketPainter({
    this.isTopLeft = false,
    this.isTopRight = false,
    this.isBottomLeft = false,
    this.isBottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00d4aa)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (isTopLeft) {
      path.moveTo(0, 15);
      path.lineTo(0, 0);
      path.lineTo(15, 0);
    } else if (isTopRight) {
      path.moveTo(15, 0);
      path.lineTo(30, 0);
      path.lineTo(30, 15);
    } else if (isBottomLeft) {
      path.moveTo(0, 15);
      path.lineTo(0, 30);
      path.lineTo(15, 30);
    } else if (isBottomRight) {
      path.moveTo(15, 30);
      path.lineTo(30, 30);
      path.lineTo(30, 15);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
