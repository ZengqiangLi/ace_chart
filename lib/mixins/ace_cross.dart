import 'package:ace_chart/utils/utils.dart';
import 'package:flutter/material.dart';

mixin AceCross {
  final Paint _paint = Paint()..style = PaintingStyle.fill;
  void _drawBorderRRect({
    required Canvas canvas,
    required RRect rrect,
    required Color bgColor,
    required Color borderColor,
    double borderWidth = 0.3,
  }) {
    _paint.color = bgColor;
    _paint.style = PaintingStyle.fill;
    _paint.strokeWidth = 1;
    canvas.drawRRect(rrect, _paint);
    _paint.color = borderColor;
    _paint.strokeWidth = borderWidth;
    _paint.style = PaintingStyle.stroke;
    canvas.drawRRect(rrect, _paint);
  }

  /// 交叉线
  void drawCrossLine(
      {required Canvas canvas,
      required double canvasWidth,
      required double canvasHeight,
      required double scrollX,
      required double scale,
      required double dx,
      required double dy,
      required Color color,
      required double strokeWidth}) {
    double min = scrollX.abs() / scale;
    double max = min + canvasWidth / scale;
    if (dx < min) {
      dx = min;
    } else if (dx > max) {
      dx = max;
    }
    canvas.save();
    canvas.translate(scrollX, 0);
    canvas.scale(scale, 1);
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill
      ..color = color;

    /// 绘制线
    canvas.drawLine(Offset(0, dy),
        Offset(canvasWidth / scale + (-scrollX / scale), dy), paint);
    paint.strokeWidth /= scale;
    canvas.drawLine(Offset(dx, 0), Offset(dx, canvasHeight), paint);
    canvas.restore();

    /// 绘制交叉圆点
    canvas.save();
    canvas.translate(scrollX, 0);
    canvas.scale(scale);
    canvas.drawCircle(Offset(dx, dy / scale), 2 / scale, paint);
    canvas.restore();
  }

  /// 绘制交叉点文字
  void drawCrossText(
      {required Canvas canvas,
      required double canvasWidth,
      required double canvasHeight,
      required double scrollX,
      required double scale,
      required double dx,
      required double dy,
      required double pressX,
      required String yText,
      required String xText,
      required TextStyle style,
      required Color bgColor,
      required Color borderColor}) {
    canvas.save();
    canvas.translate(scrollX, 0);
    final valueText = Utils.createText(xText, style);
    final timeText = Utils.createText(yText, style);

    double pd = 3;
    double valueDy = dy - valueText.height / 2;
    double valueDx = -scrollX;
    double timeDx = dx * scale - timeText.width / 2;
    if (pressX < canvasWidth / 2) {
      valueDx += (canvasWidth - valueText.width - pd * 2);
    }

    final valueRect = RRect.fromLTRBR(
        valueDx,
        valueDy,
        valueDx + valueText.width + pd * 2,
        valueDy + valueText.height,
        const Radius.circular(1));
    double tLeft = timeDx - pd;
    double tRight = timeDx + timeText.width + pd;
    double min = scrollX.abs();
    double max = min + canvasWidth;
    if (tLeft < min) {
      double w = min - tLeft;
      tLeft += w;
      timeDx += w;
      tRight += w;
    } else if (tRight > max) {
      double w = max - tRight;
      timeDx += w;
      tLeft += w;
      tRight += w;
    }

    final timeRect = RRect.fromLTRBR(tLeft, canvasHeight - timeText.height,
        tRight, canvasHeight, const Radius.circular(1));

    _drawBorderRRect(
        canvas: canvas,
        rrect: valueRect,
        bgColor: bgColor,
        borderColor: borderColor);
    _drawBorderRRect(
        canvas: canvas,
        rrect: timeRect,
        bgColor: bgColor,
        borderColor: borderColor);

    valueText.paint(canvas, Offset(valueRect.left + pd, valueRect.top));
    timeText.paint(canvas, Offset(timeDx, canvasHeight - timeText.height));
    canvas.restore();
  }
}
