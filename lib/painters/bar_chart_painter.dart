import 'package:ace_chart/mixins/ace_line.dart';
import 'package:ace_chart/mixins/ace_cross.dart';
import 'package:ace_chart/mixins/ace_grid.dart';
import 'package:ace_chart/mixins/ace_histogram.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:flutter/material.dart';

class BarChartPainter<T> extends BasePainter
    with AceCross, AceLine, AceHistogram, AceGrid {
  final List<T> values;
  final Color upperColor;
  final Color fairColor;
  final Color lowerColor;
  final double strokeWidth;
  final PaintingStyle upperStyle;
  final PaintingStyle fairStyle;
  final PaintingStyle lowerStyle;
  final TextStyle textStyle;
  final bool showText;

  /// 网格线颜色
  final Color gridLineColor;

  /// 网格垂直分成几格
  final int gridVerticalGrids;

  /// 网格水平分成几格
  final int gridHorizontalGrids;
  final double gridLineWidth;

  /// 交叉线样式
  final Color crossLineColor;
  final double crossLineWidth;
  final List<double> Function(List<T> values) transform;
  final BarStyle Function(T item) transformBarStyle;

  late double _width;
  late double contentHeight;
  late double _radio;
  BarChartPainter(
      {required this.values,
      required super.paddingTop,
      required super.scrollX,
      required super.scale,
      required super.pointSpace,
      required super.pointWidth,
      required this.strokeWidth,
      required this.upperStyle,
      required this.fairStyle,
      required this.lowerStyle,
      required this.upperColor,
      required this.fairColor,
      required this.lowerColor,
      required this.crossLineColor,
      required this.crossLineWidth,
      required this.gridHorizontalGrids,
      required this.gridVerticalGrids,
      required this.gridLineColor,
      required this.gridLineWidth,
      required this.transform,
      required this.transformBarStyle,
      required this.textStyle,
      required this.showText,
      super.pressOffset}) {
    _width = pointWidth * 0.5;
  }

  @override
  void onCompute(Size size) {
    super.onCompute(size);
    contentHeight = canvasHeight - paddingTop;
    _radio = contentHeight / maxValue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    drawCross(canvas);
  }

  @override
  void onDraw(Canvas canvas) {
    drawGrid(
        canvas: canvas,
        canvasHeight: canvasHeight,
        canvasWidth: canvasWidth,
        paddingTop: 0,
        verticalGrids: gridVerticalGrids,
        horizontalGrids: gridHorizontalGrids,
        strokeWidth: gridLineWidth,
        lineColor: gridLineColor);
    drawChart(canvas);
    if (showText) {
      drawText(canvas);
    }
  }

  void drawText(Canvas canvas) {
    drawGridText(
      canvas: canvas,
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
      verticalGrids: 1,
      horizontalGrids: 0,
      maxValue: maxValue,
      minValue: minValue,
      paddingTop: 0,
      lowerStyle: textStyle,
      upperStyle: textStyle,
    );
  }

  void drawChart(Canvas canvas) {
    if (getValues().isEmpty) {
      return;
    }
    canvas.save();
    canvas.translate(scrollX, 0);
    for (int i = 0, len = getValues().length; i < len; i++) {
      double value = getValues()[i];
      if (value != 0) {
        double y = valueToY(value);
        double x = indexToX(i) * scale;
        Color color;
        PaintingStyle style;
        BarStyle barStyle = transformBarStyle(values[i]);
        if (barStyle == BarStyle.lower) {
          color = lowerColor;
          style = lowerStyle;
        } else if (barStyle == BarStyle.upper) {
          color = upperColor;
          style = upperStyle;
        } else {
          color = fairColor;
          style = fairStyle;
        }

        drawHistogram(
            canvas: canvas,
            scale: scale,
            style: style,
            strokeWidth: strokeWidth,
            rect: Rect.fromLTRB(x, y, x + _width * scale, canvasHeight),
            color: color);
      }
    }

    canvas.restore();
  }

  /// 绘制交叉线
  void drawCross(Canvas canvas) {
    if (pressOffset == null) {
      return;
    }
    double bw = _width / 2;

    /// 二分法查找当前选中索引
    double dx = dxToTransformX(pressOffset!.dx) - bw;
    int index = transformXToIndex(dx);

    dx = indexToX(index) + bw;
    drawCrossLine(
        canvas: canvas,
        canvasWidth: canvasWidth,
        canvasHeight: canvasHeight,
        scrollX: scrollX,
        scale: scale,
        dx: dx,
        dy: -10,
        strokeWidth: crossLineWidth,
        color: crossLineColor);
  }

  @override
  double indexToX(int index) {
    return index * (_width + pointSpace + (pointWidth - _width)) +
        (pointWidth - _width) / 2;
  }

  @override
  double valueToY(double value) {
    return canvasHeight - (value) * _radio;
  }

  double getRealItemWidth() {
    return _width;
  }

  @override
  List<double> transformValues() => transform(values);
}

enum BarStyle { lower, upper, fair }
