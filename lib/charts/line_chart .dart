import 'package:ace_chart/ace_chart.dart';
import 'package:ace_chart/ace_state.dart';
import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:ace_chart/painters/line_chart_painter.dart';
import 'package:ace_chart/ace_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LineChart extends AceWidget<AceEntity> {
  final double paddingTop;
  final Color lineColor;
  final double lastClose;
  final double strokeWidth;
  final Color gridLineColor;
  final double gridLineWidth;
  final int gridHorizontalGrids;
  final int gridVerticalGrids;
  final TextStyle gridUpperStyle;
  final TextStyle gridlowerStyle;
  final Color centralAxisColor;
  final TextStyle centralAxisStyle;
  final TextStyle horizontalTextStyle;
  final TextStyle crossUpperTextStyle;
  final TextStyle crossLowerTextStyle;
  final Color crossTextBgColor;
  final Color crossTextBorderColor;
  final Color crossLineColor;
  final double crossLineWidth;
  final List<Color> maDayColors;
  final double maStrokeWidth;
  final Color averageLineColor;
  final String Function(int time) transformTime;
  final void Function(int index, MainAxisAlignment alignment)? onCrossChange;

  LineChart(
      {super.key,
      super.child,
      required this.lastClose,
      required this.transformTime,
      this.paddingTop = 0,
      this.lineColor = Colors.green,
      this.strokeWidth = 1,
      this.gridLineColor = Colors.black12,
      this.gridLineWidth = 0.5,
      this.gridHorizontalGrids = 3,
      this.gridVerticalGrids = 3,
      this.gridUpperStyle = const TextStyle(color: Colors.red, fontSize: 8),
      this.gridlowerStyle = const TextStyle(color: Colors.green, fontSize: 8),
      this.centralAxisColor = Colors.black12,
      this.centralAxisStyle =
          const TextStyle(color: Colors.black45, fontSize: 8),
      this.horizontalTextStyle =
          const TextStyle(color: Colors.black45, fontSize: 8),
      this.maDayColors = const [
        Colors.yellow,
        Colors.blue,
        Colors.deepOrange,
        Colors.indigo
      ],
      this.maStrokeWidth = 0.5,
      this.averageLineColor = Colors.red,
      this.crossLowerTextStyle = const TextStyle(fontSize: 8),
      this.crossUpperTextStyle = const TextStyle(fontSize: 8),
      this.crossTextBgColor = Colors.green,
      this.crossTextBorderColor = Colors.black,
      this.crossLineColor = Colors.red,
      this.crossLineWidth = 0.5,
      this.onCrossChange}) {
    assert(
        gridHorizontalGrids != 0, "gridHorizontalGrids cannot be less than 1");
    assert(gridVerticalGrids != 0, "gridVerticalGrids cannot be less than 1");
  }

  @override
  State<StatefulWidget> createState() => LineChartState();
}

class LineChartState extends AceState<LineChart, AceEntity> {
  int? _crossIndex;

  @override
  BasePainter builder(BuildContext context) {
    final data = watchController();
    double average = 0;
    if (data is AceStockMetricController && data.average != null) {
      average = data.average!;
    }

    final painter = LineChartPainter(
        transformTime: widget.transformTime,
        maxLength: data.maxLength,
        pointSpace: data.getSpace(),
        scrollX: data.getScrollX(),
        scale: data.getScale(),
        pressOffset: data.getPressOffset(),
        averageLineColor: widget.averageLineColor,
        average: average,
        values: data.values,
        pointWidth: data.pointWidth,
        strokeWidth: widget.strokeWidth,
        lastClose: widget.lastClose,
        paddingTop: widget.paddingTop,
        lineColor: widget.lineColor,
        gridLineWidth: widget.gridLineWidth,
        gridLineColor: widget.gridLineColor,
        gridHorizontalGrids: widget.gridHorizontalGrids,
        gridVerticalGrids: widget.gridVerticalGrids,
        gridUpperStyle: widget.gridUpperStyle,
        gridlowerStyle: widget.gridlowerStyle,
        centralAxisColor: widget.centralAxisColor,
        centralAxisStyle: widget.centralAxisStyle,
        horizontalTextStyle: widget.horizontalTextStyle,
        crossLineColor: widget.crossLineColor,
        crossLineWidth: widget.crossLineWidth,
        crossTextBgColor: widget.crossTextBgColor,
        crossTextBorderColor: widget.crossTextBorderColor,
        crossLowerTextStyle: widget.crossLowerTextStyle,
        crossUpperTextStyle: widget.crossUpperTextStyle,
        onDrawCross: (
          index,
          alignment,
          pressOffset,
        ) {
          if (_crossIndex == index) {
            return;
          }
          _crossIndex = index;
          HapticFeedback.selectionClick();
          if (widget.onCrossChange == null) {
            return;
          }
          widget.onCrossChange!(index, alignment);
        },
        maDayColors: widget.maDayColors,
        maStrokeWidth: widget.maStrokeWidth);
    return painter;
  }
}
