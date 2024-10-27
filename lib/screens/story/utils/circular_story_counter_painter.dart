import 'dart:math';

import 'package:flutter/cupertino.dart';

class CircularStoryCounterPainter extends CustomPainter {
  final int storyCount;
  final double progress; // Between 0.0 and 1.0 (overall progress)
  final Color backgroundColor;
  final Color storyColor;
  final double thickness;

  CircularStoryCounterPainter({
    required this.storyCount,
    required this.progress,
    required this.backgroundColor,
    required this.storyColor,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - thickness / 2;

    // Draw the background circle
    canvas.drawCircle(center, radius, paint);

    // Calculate arc angle per story
    final double arcAngle = 2 * pi / (storyCount > 0 ? storyCount : 1);

    // Draw story arcs based on progress
    for (int i = 0; i < storyCount; i++) {
      final double currentProgress =  progress * arcAngle;
      final arcPaint = Paint()
        ..color = storyColor
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + i * arcAngle, // Adjust start angle for each arc
        currentProgress,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CircularStoryCounterPainter oldDelegate) =>
      storyCount != oldDelegate.storyCount ||
          progress != oldDelegate.progress ||
          backgroundColor != oldDelegate.backgroundColor ||
          storyColor != oldDelegate.storyColor ||
          thickness != oldDelegate.thickness;
}
