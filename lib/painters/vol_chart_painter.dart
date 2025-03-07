import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/painters/bar_chart_painter.dart';
import 'package:flutter/material.dart';

class VolChartPainter extends BarChartPainter<AceEntity> {
  final double maStrokeWidth;
  final Color ma5LineColor;
  final Color ma10LineColor;

  final bool showMaLine;

  VolChartPainter({
    required super.values,
    required super.paddingTop,
    required super.scrollX,
    required super.scale,
    required super.pointSpace,
    required super.pointWidth,
    super.pressOffset,
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
    required this.maStrokeWidth,
    required this.ma5LineColor,
    required this.ma10LineColor,
    required this.showMaLine,
    required super.textStyle,
    required super.showText,
  });

  @override
  void onDraw(Canvas canvas) {
    super.onDraw(canvas);
    drawMa(canvas);
  }

  void drawMa(Canvas canvas) {
    if (!showMaLine) {
      return;
    }
    canvas.save();
    canvas.translate(scrollX, 0);
    double? m5StartX;
    double? m5StartY;
    double? m10StartX;
    double? m10StartY;
    for (int i = 0, len = values.length; i < len; i++) {
      AceEntity item = values[i];
      if (item.ma5Volume != null) {
        double x = indexToX(i) * scale + (getRealItemWidth() / 2) * scale;
        if (item.ma5Volume! > 0) {
          double m5Y = valueToY(item.ma5Volume!);
          if (m5StartX == null || m5StartY == null) {
            m5StartX = x;
            m5StartY = m5Y;
          }
          drawLine(
              canvas: canvas,
              startX: m5StartX,
              startY: m5StartY,
              endX: x,
              endY: m5Y,
              strokeWidth: maStrokeWidth,
              color: ma5LineColor);

          m5StartX = x;
          m5StartY = m5Y;
        }

        if (item.ma10Volume! > 0) {
          double m10Y = valueToY(item.ma10Volume!);
          if (m10StartX == null || m10StartY == null) {
            m10StartX = x;
            m10StartY = m10Y;
          }

          drawLine(
              canvas: canvas,
              startX: m10StartX,
              startY: m10StartY,
              endX: x,
              endY: m10Y,
              strokeWidth: maStrokeWidth,
              color: ma10LineColor);

          m10StartX = x;
          m10StartY = m10Y;
        }
      }
    }

    canvas.restore();
  }
}
