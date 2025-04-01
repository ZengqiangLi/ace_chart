import 'dart:math' as math;
import 'dart:ui';

import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/painters/bipolar_chart_painter.dart';
import 'package:flutter/material.dart';

class CapitalFlowChartPainter extends BipolarChartPainter<AceEntity> {
  CapitalFlowChartPainter(
      {required super.paddingTop,
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
      required super.showText,
      super.valueTextFontSize})
      : super(
          showValueText: true,
        );

  @override
  void onCompute(Size size) {
    super.onCompute(size);
    if (getValues().isNotEmpty) {
      ratio = zeroLineY / math.max(minValue.abs(), maxValue.abs());
    }
  }
}
