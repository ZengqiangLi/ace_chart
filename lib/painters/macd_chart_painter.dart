import 'dart:math' as math;
import 'dart:ui';

import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/painters/bipolar_chart_painter.dart';
import 'package:flutter/material.dart';

class MacdChartPainter extends BipolarChartPainter<AceEntity> {
  final double difAndDeaLineWidth;
  final Color difLineColor;
  final Color deaLineColor;
  MacdChartPainter(
      {required this.difAndDeaLineWidth,
      required this.difLineColor,
      required this.deaLineColor,
      required super.paddingTop,
      required super.values,
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
      super.pressOffset,
      required super.textStyle,
      required super.showText});

  @override
  void onCompute(Size size) {
    super.onCompute(size);
    if (getValues().isNotEmpty) {
      List<double> difs =
          values.map((e) => e.dif!).toList().sublist(startIndex, endIndex);
      List<double> deas =
          values.map((e) => e.dea!).toList().sublist(startIndex, endIndex);
      double minDif = difs.reduce(math.min);
      double minDea = deas.reduce(math.min);
      double maxDif = difs.reduce(math.max);
      double maxDea = deas.reduce(math.max);
      minValue = [minDif, minDea, minValue].reduce(math.min);
      maxValue = [maxDif, maxDea, maxValue].reduce(math.max);

      ratio = zeroLineY / math.max(minValue.abs(), maxValue.abs());
    }
  }

  @override
  void onDraw(Canvas canvas) {
    super.onDraw(canvas);
    drawMa(canvas);
  }

  void drawMa(Canvas canvas) {
    canvas.save();
    canvas.translate(scrollX, 0);
    double? difStartX;
    double? difStartY;
    double? deaStartX;
    double? deaStartY;
    for (int i = 0, len = values.length; i < len; i++) {
      AceEntity item = values[i];
      if (item.macd != null && item.macd! != 0) {
        double x = indexToX(i) * scale + (getRealItemWidth() / 2) * scale;
        double difY = valueToY(item.dif!);
        if (difStartX == null || difStartY == null) {
          difStartX = x;
          difStartY = difY;
        }

        drawLine(
            canvas: canvas,
            startX: difStartX,
            startY: difStartY,
            endX: x,
            endY: difY,
            strokeWidth: difAndDeaLineWidth,
            color: difLineColor);

        difStartX = x;
        difStartY = difY;

        double deaY = valueToY(item.dea!);
        if (deaStartX == null || deaStartY == null) {
          deaStartX = x;
          deaStartY = deaY;
        }
        drawLine(
            canvas: canvas,
            startX: deaStartX,
            startY: deaStartY,
            endX: x,
            endY: deaY,
            strokeWidth: difAndDeaLineWidth,
            color: deaLineColor);

        deaStartX = x;
        deaStartY = deaY;
      }
    }

    canvas.restore();
  }
}
