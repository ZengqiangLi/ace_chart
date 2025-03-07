
import 'package:flutter/material.dart';

mixin AceLine {
  final Paint _linePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..filterQuality = FilterQuality.high;

  void drawLine({
    required Canvas canvas,
    required double startX,
    required double startY,
    required double endX,
    required double endY,
    required double strokeWidth,
    required Color color,
  }) {
    _linePaint.strokeWidth = strokeWidth;
    _linePaint.color = color;
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), _linePaint);
  }
}
