import 'package:ace_chart/ace_chart.dart';
import 'package:ace_chart/ace_state.dart';
import 'package:ace_chart/ace_widget.dart';
import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:ace_chart/painters/k_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KChart extends AceWidget<AceEntity> {
  final double paddingTop;
  final double strokeWidth;
  final Color gridLineColor;
  final double gridLineWidth;
  final int gridHorizontalGrids;
  final int gridVerticalGrids;
  final TextStyle gridTextStyle;
  final TextStyle gridUpperStyle;
  final TextStyle gridlowerStyle;
  final TextStyle horizontalTextStyle;
  final TextStyle crossUpperTextStyle;
  final TextStyle crossLowerTextStyle;
  final Color crossTextBgColor;
  final Color crossTextBorderColor;
  final Color crossLineColor;
  final double crossLineWidth;
  final List<Color> maDayColors;
  final double maStrokeWidth;
  final Color highMarkColor;
  final Color lowMarkColor;
  final double markSize;
  final Color upperColor;
  final Color lowerColor;
  final PaintingStyle upperStyle;
  final PaintingStyle lowerStyle;
  final bool showCrossText;
  final Color averageLineColor;
  final String Function(int time) transformTime;
  final void Function(int index, MainAxisAlignment alignment)? onCrossChange;
  const KChart({
    super.key,
    super.child,
    this.paddingTop = 0,
    this.strokeWidth = 1,
    this.gridLineColor = Colors.black12,
    this.gridLineWidth = 0.5,
    this.gridHorizontalGrids = 3,
    this.gridVerticalGrids = 3,
    this.gridTextStyle = const TextStyle(color: Colors.black45, fontSize: 8),
    this.gridUpperStyle = const TextStyle(color: Colors.black45, fontSize: 8),
    this.gridlowerStyle = const TextStyle(color: Colors.black45, fontSize: 8),
    this.averageLineColor = Colors.red,
    this.upperColor = Colors.red,
    this.lowerColor = Colors.green,
    this.upperStyle = PaintingStyle.stroke,
    this.lowerStyle = PaintingStyle.fill,
    this.horizontalTextStyle =
        const TextStyle(color: Colors.black45, fontSize: 8),
    this.maDayColors = const [
      Colors.yellow,
      Colors.blue,
      Colors.deepOrange,
      Colors.indigo
    ],
    this.maStrokeWidth = 0.5,
    this.crossLowerTextStyle = const TextStyle(fontSize: 8),
    this.crossUpperTextStyle = const TextStyle(fontSize: 8),
    this.crossTextBgColor = Colors.green,
    this.crossTextBorderColor = Colors.black,
    this.crossLineColor = Colors.red,
    this.crossLineWidth = 0.5,
    this.onCrossChange,
    this.highMarkColor = Colors.black,
    this.lowMarkColor = Colors.black,
    this.markSize = 7,
    this.showCrossText = true,
    required this.transformTime,
  });

  @override
  State<StatefulWidget> createState() => KChartState();
}

class KChartState extends AceState<KChart, AceEntity> {
  int? _crossIndex;
  @override
  BasePainter builder(BuildContext context) {
    final data = watchController();
    double average = 0;
    if (data is AceStockMetricController && data.average != null) {
      average = data.average!;
    }

    final painter = KChartPainter(
        transformTime: widget.transformTime,
        showCrossText: widget.showCrossText,
        pointSpace: data.getSpace(),
        scrollX: data.getScrollX(),
        scale: data.getScale(),
        pressOffset: data.getPressOffset(),
        average: average,
        averageLineColor: widget.averageLineColor,
        values: data.values,
        pointWidth: data.pointWidth,
        paddingTop: widget.paddingTop,
        gridLineWidth: widget.gridLineWidth,
        gridLineColor: widget.gridLineColor,
        gridHorizontalGrids: widget.gridHorizontalGrids,
        gridTextStyle: widget.gridTextStyle,
        gridVerticalGrids: widget.gridVerticalGrids,
        gridUpperStyle: widget.gridUpperStyle,
        gridlowerStyle: widget.gridlowerStyle,
        horizontalTextStyle: widget.horizontalTextStyle,
        crossLineColor: widget.crossLineColor,
        crossLineWidth: widget.crossLineWidth,
        crossTextBgColor: widget.crossTextBgColor,
        crossTextBorderColor: widget.crossTextBorderColor,
        crossLowerTextStyle: widget.crossLowerTextStyle,
        crossUpperTextStyle: widget.crossUpperTextStyle,
        maDayColors: widget.maDayColors,
        strokeWidth: widget.strokeWidth,
        maStrokeWidth: widget.maStrokeWidth,
        upperColor: widget.upperColor,
        upperStyle: widget.upperStyle,
        lowerColor: widget.lowerColor,
        lowerStyle: widget.lowerStyle,
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
        highMarkColor: widget.highMarkColor,
        lowMarkColor: widget.lowMarkColor,
        markSize: widget.markSize);
    return painter;
  }
}
