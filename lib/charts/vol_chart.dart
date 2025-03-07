import 'package:ace_chart/ace_state.dart';
import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/painters/bar_chart_painter.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:ace_chart/painters/vol_chart_painter.dart';
import 'package:ace_chart/ace_widget.dart';
import 'package:flutter/material.dart';

class VolChart extends AceWidget<AceEntity> {
  final Color upperColor;
  final Color fairColor;
  final Color lowerColor;
  final Color crossLineColor;
  final double crossLineWidth;
  final double strokeWidth;
  final Color gridLineColor;
  final double gridLineWidth;
  final int gridHorizontalGrids;
  final int gridVerticalGrids;
  final PaintingStyle upperStyle;
  final PaintingStyle fairStyle;
  final PaintingStyle lowerStyle;
  final double maStrokeWidth;
  final Color ma5LineColor;
  final Color ma10LineColor;
  final bool showMaLine;
  final TextStyle textStyle;
  final bool showText;
  final double paddingTop;

  const VolChart({
    super.key,
    super.child,
    this.paddingTop = 0,
    this.upperColor = Colors.red,
    this.fairColor = Colors.black45,
    this.lowerColor = Colors.green,
    this.strokeWidth = 1,
    this.gridLineColor = Colors.black12,
    this.gridLineWidth = 0.5,
    this.gridHorizontalGrids = 3,
    this.gridVerticalGrids = 3,
    this.upperStyle = PaintingStyle.fill,
    this.fairStyle = PaintingStyle.fill,
    this.lowerStyle = PaintingStyle.fill,
    this.maStrokeWidth = 0.5,
    this.ma5LineColor = Colors.yellow,
    this.ma10LineColor = Colors.blue,
    this.showMaLine = false,
    this.crossLineColor = Colors.red,
    this.crossLineWidth = 0.5,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 8),
    this.showText = true,
  });
  @override
  State<StatefulWidget> createState() => VolChartState();
}

class VolChartState extends AceState<VolChart, AceEntity> {
  @override
  BasePainter builder(BuildContext context) {
    final data = watchController();
    double lastClose = 0;
    final painter = VolChartPainter(
      paddingTop: widget.paddingTop,
      pointSpace: data.getSpace(),
      scrollX: data.getScrollX(),
      scale: data.getScale(),
      pressOffset: data.getPressOffset(),
      values: data.values,
      showMaLine: widget.showMaLine,
      pointWidth: data.pointWidth,
      upperStyle: widget.upperStyle,
      fairStyle: widget.fairStyle,
      lowerStyle: widget.lowerStyle,
      upperColor: widget.upperColor,
      fairColor: widget.fairColor,
      lowerColor: widget.lowerColor,
      strokeWidth: widget.strokeWidth,
      gridLineWidth: widget.gridLineWidth,
      gridLineColor: widget.gridLineColor,
      gridHorizontalGrids: widget.gridHorizontalGrids,
      gridVerticalGrids: widget.gridVerticalGrids,
      ma10LineColor: widget.ma10LineColor,
      ma5LineColor: widget.ma5LineColor,
      maStrokeWidth: widget.maStrokeWidth,
      crossLineColor: widget.crossLineColor,
      crossLineWidth: widget.crossLineWidth,
      textStyle: widget.textStyle,
      showText: widget.showText,
      transform: (values) {
        return values.map((e) => e.volume).toList();
      },
      transformBarStyle: (item) {
        BarStyle style;
        if (data.isKChart()) {
          if (item.close >= item.open) {
            style = BarStyle.upper;
          } else {
            style = BarStyle.lower;
          }
        } else {
          if (item.close < lastClose) {
            style = BarStyle.lower;
          } else if (item.close > lastClose) {
            style = BarStyle.upper;
          } else {
            style = BarStyle.fair;
          }

          lastClose = item.close;
        }

        return style;
      },
    );
    return painter;
  }
}
