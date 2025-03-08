import 'dart:math' as math;
import 'package:ace_chart/painters/ace_painter.dart';
import 'package:flutter/material.dart';

class LineChartPainter extends AcePainter {
  final int maxLength;
  final double strokeWidth;
  final Color lineColor;

  /// 中轴线颜色
  final Color centralAxisColor;
  final TextStyle centralAxisStyle;

  Shader? chartShader;
  late double _radio;
  LineChartPainter(
      {required this.maxLength,
      required super.values,
      required super.scrollX,
      required super.scale,
      required super.pointWidth,
      required super.pointSpace,
      super.pressOffset,
      required this.strokeWidth,
      required double lastClose,
      required super.paddingTop,
      required this.lineColor,
      required super.gridLineColor,
      required super.gridVerticalGrids,
      required super.gridHorizontalGrids,
      required super.gridTextStyle,
      required super.gridUpperStyle,
      required super.gridlowerStyle,
      required super.gridLineWidth,
      required this.centralAxisColor,
      required this.centralAxisStyle,
      required super.horizontalTextStyle,
      required super.crossUpperTextStyle,
      required super.crossLowerTextStyle,
      required super.crossTextBgColor,
      required super.crossTextBorderColor,
      required super.crossLineColor,
      required super.crossLineWidth,
      required super.maDayColors,
      required super.maStrokeWidth,
      required super.transformTime,
      required super.averageLineColor,
      required super.average,
      super.onDrawCross})
      : super(lastClose: lastClose);

  @override
  List<double> transformValues() {
    return values.map((e) => e.close).toList();
  }

  @override
  double indexToX(int index) {
    return ((pointWidth + pointSpace) * index) + pointWidth / 2;
  }

  @override
  double valueToY(double value) {
    return (maxValue - value) * _radio + paddingTop;
  }

  @override
  int getCrossIndex() {
    double dx = dxToTransformX(pressOffset!.dx);
    int index = transformXToIndex(dx);
    return index;
  }

  @override
  double getCrossDx(int index) {
    double dx = indexToX(index);
    return dx;
  }

  @override
  void onCompute(Size size) {
    super.onCompute(size);
    double diff =
        math.max((maxValue - lastClose!).abs(), (minValue - lastClose!).abs()) *
            1.5;
    if (diff < 1) {
      diff = 1;
    }
    maxValue = lastClose! + diff;
    minValue = lastClose! - diff;
    _radio = contentHeight / (maxValue - minValue);
  }

  @override
  void onDraw(Canvas canvas) {
    chartShader ??= LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.clamp,
      colors: [lineColor.withOpacity(0.2), lineColor.withOpacity(0.05)],
    ).createShader(Rect.fromLTRB(0, 0, canvasWidth, contentHeight));
    drawCentralAxis(canvas);

    super.onDraw(canvas);
  }

  /// 绘制中轴线
  void drawCentralAxis(Canvas canvas) {
    canvas.save();
    canvas.translate(scrollX, 0);
    canvas.scale(scale, 1);
    drawVerticalDottedLine(
      canvas: canvas,
      canvasWidth: dxToTransformX(canvasWidth),
      scale: scale,
      color: centralAxisColor,
      y: valueToY(lastClose!),
    );

    canvas.restore();
    drawGridVerticalText(
      canvas: canvas,
      canvasWidth: canvasWidth,
      canvasHeight: contentHeight,
      value: lastClose!,
      dy: valueToY(lastClose!),
      lastClose: lastClose,
      style: centralAxisStyle,
    );
  }

  /// 绘制曲线

  @override
  void onDrawCart(Canvas canvas) {
    drawLineCart(
        canvas: canvas,
        maxLength: maxLength,
        strokeWidth: strokeWidth,
        lineColor: lineColor,
        chartShader: chartShader);
  }
}
