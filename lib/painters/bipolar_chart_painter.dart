import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:ace_chart/painters/bar_chart_painter.dart';
// 双极图
class BipolarChartPainter<T> extends BarChartPainter<T> {
  late double ratio;
  late double zeroLineY;
  BipolarChartPainter({
    required super.values,
    required super.paddingTop,
    required super.scrollX,
    required super.scale,
    required super.pointSpace,
    required super.pointWidth,
    required super.strokeWidth,
    required super.upperStyle,
    required super.fairStyle,
    required super.lowerStyle,
    required super.upperColor,
    required super.fairColor,
    required super.lowerColor,
    required super.crossLineColor,
    required super.crossLineWidth,
    required super.gridHorizontalGrids,
    required super.gridVerticalGrids,
    required super.gridLineColor,
    required super.gridLineWidth,
    required super.transform,
    required super.transformBarStyle,
    required super.textStyle,
    super.pressOffset,
    required super.showText,
  });

  @override
  void onCompute(Size size) {
    super.onCompute(size);
    zeroLineY = canvasHeight / 2;
    ratio = zeroLineY / math.max(minValue.abs(), maxValue.abs());
  }

  @override
  void drawText(Canvas canvas) {
    super.drawText(canvas);
    TextPainter textPainter = createText(text: '0', style: textStyle);
    textPainter.paint(canvas, Offset(0, zeroLineY - textPainter.height / 2));
  }

  @override
  double valueToY(double value) {
    return zeroLineY - value * ratio;
  }

  @override
  void drawHistogram(
      {required Canvas canvas,
      required PaintingStyle style,
      required double strokeWidth,
      required double scale,
      required Color color,
      required Rect rect}) {
    Rect nr = Rect.fromLTRB(rect.left, rect.top, rect.right, canvasHeight / 2);
    super.drawHistogram(
        canvas: canvas,
        style: style,
        strokeWidth: strokeWidth,
        scale: scale,
        color: color,
        rect: nr);
  }
}
