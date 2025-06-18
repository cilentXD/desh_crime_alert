import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final double gridSize;
  final Color gridColor;
  final double strokeWidth;

  GridPainter({
    this.gridSize = 50.0, // Default grid size
    this.gridColor = Colors.grey, // Default grid color
    this.strokeWidth = 0.5, // Default stroke width
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor.withOpacity(0.2) // Make grid lines less prominent
      ..strokeWidth = strokeWidth;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
