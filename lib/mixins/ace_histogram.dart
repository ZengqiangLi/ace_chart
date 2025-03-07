import 'package:flutter/material.dart';

mixin AceHistogram {
  final _paint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high;
  void drawHistogram(
      {required Canvas canvas,
      required PaintingStyle style,
      required double strokeWidth,
      required double scale,
      required Color color,
      required Rect rect}) {
    _paint.style = style;
    _paint.color = color;
    if (style == PaintingStyle.fill) {
      _paint.strokeWidth = strokeWidth;
      canvas.drawRect(rect, _paint);
    } else {
      if (rect.width + _paint.strokeWidth * 2 > strokeWidth) {
        double sc = rect.width / (rect.width + _paint.strokeWidth * 2);
        strokeWidth = strokeWidth.clamp(0, strokeWidth * sc);
      }

      /// 上下横线
      _paint.strokeWidth = strokeWidth;
      canvas.drawLine(rect.topLeft, rect.topRight, _paint);
      canvas.drawLine(rect.bottomLeft, rect.bottomRight, _paint);

      /// 左右横线

      canvas.drawLine(rect.topLeft, rect.bottomLeft, _paint);
      canvas.drawLine(rect.topRight, rect.bottomRight, _paint);
    }
  }

  void drawCandle(
      {required Canvas canvas,
      required PaintingStyle style,
      required double strokeWidth,
      required double scale,
      required Color color,
      required double dx,
      required double width,
      required double highY,
      required double lowY,
      required double closeY,
      required double openY}) {
    if (highY.isNaN || highY.isInfinite) {
      return;
    }
    _paint.style = style;
    _paint.color = color;
    _paint.strokeWidth = 1;
    double candleX = dx + width * scale / 2;
    if (closeY > openY) {
      canvas.drawLine(Offset(candleX, highY), Offset(candleX, openY), _paint);
      canvas.drawLine(Offset(candleX, lowY), Offset(candleX, closeY), _paint);
    } else {
      canvas.drawLine(Offset(candleX, lowY), Offset(candleX, openY), _paint);

      canvas.drawLine(Offset(candleX, highY), Offset(candleX, closeY), _paint);
    }
    drawHistogram(
        canvas: canvas,
        style: style,
        strokeWidth: strokeWidth,
        scale: scale,
        color: color,
        rect: Rect.fromLTRB(dx, openY, dx + width * scale, closeY));
  }
}
