import 'package:ace_chart/painters/base_painter.dart';
import 'package:ace_chart/utils/utils.dart';
import 'package:flutter/material.dart';

mixin AceGrid on BasePainter {
  Paint? _paint;

  void drawGrid({
    required Canvas canvas,
    required double canvasWidth,
    required double canvasHeight,
    required int verticalGrids,
    required int horizontalGrids,
    required Color lineColor,
    required double strokeWidth,
    required double paddingTop,
  }) {
    _paint ??= Paint()
      ..isAntiAlias = true
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..filterQuality = FilterQuality.high;
    double horizontalSpace = canvasWidth / horizontalGrids;
    for (int i = 1; i < horizontalGrids; i++) {
      double x = horizontalSpace * i;
      canvas.drawLine(
          Offset(x, 0), Offset(x, canvasHeight + paddingTop), _paint!);
    }

    double verticalSpace = canvasHeight / verticalGrids;
    for (int i = 1; i <= verticalGrids; i++) {
      double y = verticalSpace * i + paddingTop;
      canvas.drawLine(Offset(0, y), Offset(canvasWidth, y), _paint!);
    }
  }

  /// 绘制网格文字
  void drawGridText({
    required Canvas canvas,
    required double canvasWidth,
    required double canvasHeight,
    required int verticalGrids,
    required int horizontalGrids,
    required double maxValue,
    required double minValue,
    required double paddingTop,
    required TextStyle lowerStyle,
    required TextStyle upperStyle,
    double? lastClose,
  }) {
    /// 绘制网格垂直线文字和涨跌比率
    double diff = maxValue - minValue;
    double space = diff / verticalGrids;
    double verticalSpace = canvasHeight / verticalGrids;
    for (int i = 0; i <= verticalGrids; i++) {
      double y = verticalSpace * i + paddingTop;
      double value = maxValue - space * i;
      TextStyle style =
          lastClose != null && value < lastClose ? lowerStyle : upperStyle;
      drawGridVerticalText(
          canvas: canvas,
          canvasWidth: canvasWidth,
          canvasHeight: canvasHeight + paddingTop,
          value: value,
          lastClose: lastClose,
          dy: y,
          style: style);
    }
  }

  /// 绘制垂直文字
  void drawGridVerticalText(
      {required Canvas canvas,
      required double canvasWidth,
      required double canvasHeight,
      required double value,
      required double dy,
      required TextStyle style,
      double? lastClose}) {
    if (dy.isNaN) {
      return;
    }
    String maxText = Utils.toStringAsFixed(value);

    TextPainter painter = createText(text: maxText, style: style);
    double y;
    if (dy + painter.height > canvasHeight) {
      y = canvasHeight - painter.height;
    } else {
      y = dy - painter.height;
      if (y < 0) {
        y = 0;
      }
    }

    painter.paint(canvas, Offset(0, y));
    ///// 绘制涨跌比率文字
    if (lastClose != null) {
      String maxRatioText = Utils.calcStockPriceRatio(lastClose, value);

      TextPainter painter = createText(text: maxRatioText, style: style);
      painter.paint(canvas, Offset(canvasWidth - painter.width, y));
    }
  }

  /// 绘制横虚线
  void drawVerticalDottedLine(
      {required Canvas canvas,
      required double canvasWidth,
      required double y,
      required Color color,
      double scale = 1}) {
    if (y.isNaN) {
      return;
    }
    double w = 5 / scale;
    double pd = 2 / scale;
    int num = (canvasWidth / (w + pd)).ceil();
    double startX = 0;
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < num; i++) {
      double next = startX + w;
      canvas.drawLine(Offset(startX, y), Offset(next, y), paint);
      next += pd;
      startX = next;
    }
  }
}
