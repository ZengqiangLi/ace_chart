import 'dart:math' as math;
import 'package:ace_chart/mixins/ace_histogram.dart';
import 'package:ace_chart/painters/ace_painter.dart';
import 'package:ace_chart/utils/utils.dart';
import 'package:flutter/material.dart';

class KChartPainter extends AcePainter with AceHistogram {
  final Color upperColor;
  final Color lowerColor;
  final PaintingStyle upperStyle;
  final PaintingStyle lowerStyle;
  final double strokeWidth;

  final Color highMarkColor;
  final Color lowMarkColor;
  final double markSize;
  final bool showCrossText;

  late double _radio;
  late double realItemWidth;

  late double _drawMaxValue;
  late double _drawMinValue;
  late int _drawMaxIndex;
  late int _drawMinIndex;
  KChartPainter({
    required super.values,
    required super.scrollX,
    required super.scale,
    required super.pointSpace,
    required super.pointWidth,
    super.pressOffset,
    required super.paddingTop,
    required super.gridTextStyle,
    required super.gridUpperStyle,
    required super.gridlowerStyle,
    required super.gridLineColor,
    required super.gridVerticalGrids,
    required super.gridHorizontalGrids,
    required super.gridLineWidth,
    required super.horizontalTextStyle,
    required super.maDayColors,
    required super.maStrokeWidth,
    required super.crossUpperTextStyle,
    required super.crossLowerTextStyle,
    required super.crossTextBgColor,
    required super.crossTextBorderColor,
    required super.crossLineColor,
    required super.crossLineWidth,
    required super.onDrawCross,
    required super.transformTime,
    required super.averageLineColor,
    required this.upperColor,
    required this.lowerColor,
    required this.upperStyle,
    required this.lowerStyle,
    required this.strokeWidth,
    required this.highMarkColor,
    required this.lowMarkColor,
    required this.markSize,
    required this.showCrossText,
    required super.average,
  }) {
    realItemWidth = pointWidth * 0.8;
  }

  @override
  double getRealItemWidth() {
    return realItemWidth;
  }

  @override
  void onCompute(Size size) {
    super.onCompute(size);
    if (getValues().isNotEmpty) {
      List<double> originLows = values.map((e) => e.low).toList();
      List<double> lows = originLows.sublist(startIndex, endIndex);
      double lowsMin = lows.reduce(math.min);
      double lowsMax = lows.reduce(math.max);
      if (lowsMax > maxValue) {
        maxValue = lowsMax;
        _drawMaxIndex = originLows.indexOf(maxValue);
      } else {
        _drawMaxIndex = getValues().indexOf(maxValue);
      }
      if (lowsMin < minValue) {
        minValue = lowsMin;
        _drawMinIndex = originLows.indexOf(minValue);
      } else {
        _drawMinIndex = getValues().indexOf(minValue);
      }
      _drawMaxValue = maxValue;
      _drawMinValue = minValue;

      double abs = (maxValue - minValue).abs() * 1.2;
      double mx = minValue + abs;
      double mi = maxValue - abs;
      maxValue = mx;
      minValue = mi;
      _radio = contentHeight / (maxValue - minValue);
    }
  }

  @override
  void onDrawCart(Canvas canvas) {
    if (getValues().isEmpty) {
      return;
    }
    int length = values.length;
    if (getRealItemWidth() * scale < 1.5) {
      drawLineCart(
          canvas: canvas,
          maxLength: length,
          strokeWidth: strokeWidth,
          lineColor: upperColor);
    } else {
      List<double>? maStartYs;
      double startX = 0;
      for (int i = 0; i < length; i++) {
        final item = values[i];
        var high = valueToY(item.high);
        var low = valueToY(item.low);
        double x = indexToX(i) * scale;
        double open = valueToY(item.open);
        double close = valueToY(item.close);
        double cndleHeight = close - open;
        if (cndleHeight.abs() < 1) {
          open = cndleHeight < 0 ? close + 1 : close - 1;
        }

        Color color;
        PaintingStyle style;
        if (item.close >= item.open) {
          color = upperColor;
          style = upperStyle;
        } else {
          color = lowerColor;
          style = lowerStyle;
        }
        drawCandle(
            canvas: canvas,
            style: style,
            strokeWidth: strokeWidth,
            scale: scale,
            color: color,
            dx: x,
            width: getRealItemWidth(),
            highY: high,
            lowY: low,
            closeY: close,
            openY: open);

        if (item.mas != null) {
          double mx = x + getRealItemWidth() / 2 * scale;
          maStartYs ??= List.filled(item.mas!.length, 0);
          for (int m = 0, len = item.mas!.length; m < len; m++) {
            double ma = item.mas![m];
            if (ma > 0) {
              double my = valueToY(ma);
              if (maStartYs[m] == 0) {
                maStartYs[m] = my;
                startX = mx;
              }

              drawLine(
                  canvas: canvas,
                  startX: startX,
                  startY: maStartYs[m],
                  endX: mx,
                  endY: my,
                  strokeWidth: maStrokeWidth,
                  color: maDayColors[m]);
              maStartYs[m] = my;
            }
          }
          startX = mx;
        }
      }
    }

    drawHighAndLowMark(canvas);
  }

  @override
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
    if (showCrossText) {
      super.drawCrossText(
          canvas: canvas,
          canvasWidth: canvasWidth,
          canvasHeight: canvasHeight,
          scrollX: scrollX,
          scale: scale,
          dx: dx,
          dy: dy,
          pressX: pressX,
          yText: yText,
          xText: xText,
          style: style,
          bgColor: bgColor,
          borderColor: borderColor);
    }
  }

  @override
  double indexToX(int index) {
    return index *
            (getRealItemWidth() +
                pointSpace +
                (pointWidth - getRealItemWidth())) +
        (pointWidth - getRealItemWidth()) / 2;
  }

  @override
  List<double> transformValues() {
    return values.map((e) => e.high).toList();
  }

  @override
  double valueToY(double value) {
    return (maxValue - value) * _radio + paddingTop;
  }

  @override
  int getCrossIndex() {
    double bw = getRealItemWidth() / 2;
    double dx = dxToTransformX(pressOffset!.dx) - bw;
    int index = transformXToIndex(dx);
    return index;
  }

  @override
  double getCrossDx(int index) {
    double bw = getRealItemWidth() / 2;
    double dx = indexToX(index) + bw;
    return dx;
  }

  void _drawValueMark({
    required Canvas canvas,
    required int index,
    required double value,
    required bool isMin,
  }) {
    double vLineH = isMin ? 2 : -2;
    double lineWidth = 10;
    double x = indexToX(index) * scale + getRealItemWidth() * scale / 2;
    double y = valueToY(value) + vLineH;
    Color color = isMin ? lowMarkColor : highMarkColor;
    TextPainter maxText = createText(
        text: Utils.toStringAsFixed(value),
        style: TextStyle(color: color, fontSize: markSize));
    bool alignRight = x + scrollX < canvasWidth / 2;
    Offset p1 = Offset(x, y);
    Offset p2 = p1 + Offset(0, vLineH);
    Offset p3;
    Offset p4;
    if (alignRight) {
      p3 = p2 + Offset(lineWidth, 0);
      p4 = p3 + Offset(0, -maxText.height / 2);
    } else {
      p3 = p2 + Offset(-lineWidth, 0);
      p4 = p3 + Offset(-maxText.width, -maxText.height / 2);
    }
    Paint paint = Paint()..color = color;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p2, p3, paint);
    maxText.paint(canvas, p4);
  }

  /// 绘制最高和最低值文字标示
  void drawHighAndLowMark(Canvas canvas) {
    _drawValueMark(
        canvas: canvas,
        index: _drawMaxIndex,
        value: _drawMaxValue,
        isMin: false);
    _drawValueMark(
        canvas: canvas,
        index: _drawMinIndex,
        value: _drawMinValue,
        isMin: true);
  }
}
