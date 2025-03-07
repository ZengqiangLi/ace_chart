import 'package:ace_chart/ace_state.dart';
import 'package:ace_chart/ace_widget.dart';
import 'package:ace_chart/painters/bar_chart_painter.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:flutter/material.dart';
export 'package:ace_chart/painters/bar_chart_painter.dart' show BarStyle;

class BarChart<T> extends AceWidget<T> {
  final Color upperColor;
  final Color fairColor;
  final Color lowerColor;
  final double strokeWidth;
  final PaintingStyle upperStyle;
  final PaintingStyle fairStyle;
  final PaintingStyle lowerStyle;

  final TextStyle textStyle;
  final bool showText;
  final double paddingTop;
  final Color gridLineColor;
  final double gridLineWidth;
  final int gridHorizontalGrids;
  final int gridVerticalGrids;

  /// 交叉线样式
  final Color crossLineColor;
  final double crossLineWidth;
  final List<double> Function(List<T> values) transform;
  final BarStyle Function(T item) transformBarStyle;
  const BarChart({
    super.key,
    super.child,
    this.upperColor = Colors.red,
    this.fairColor = Colors.black45,
    this.lowerColor = Colors.green,
    this.strokeWidth = 1,
    this.upperStyle = PaintingStyle.fill,
    this.fairStyle = PaintingStyle.fill,
    this.lowerStyle = PaintingStyle.fill,
    this.crossLineColor = Colors.red,
    this.crossLineWidth = 0.5,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 8),
    this.showText = true,
    this.paddingTop = 0,
    this.gridLineColor = Colors.black12,
    this.gridLineWidth = 0.5,
    this.gridHorizontalGrids = 3,
    this.gridVerticalGrids = 3,
    required this.transform,
    required this.transformBarStyle,
  });

  @override
  State<StatefulWidget> createState() {
    return BarChartState<T>();
  }
}

class BarChartState<T> extends AceState<BarChart<T>, T> {
  @override
  BasePainter builder(BuildContext context) {
    final data = watchController();
    final painter = BarChartPainter(
        paddingTop: widget.paddingTop,
        pointSpace: data.getSpace(),
        scrollX: data.getScrollX(),
        scale: data.getScale(),
        pressOffset: data.getPressOffset(),
        values: data.values,
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
        crossLineColor: widget.crossLineColor,
        crossLineWidth: widget.crossLineWidth,
        textStyle: widget.textStyle,
        showText: widget.showText,
        transform: widget.transform,
        transformBarStyle: widget.transformBarStyle);
    return painter;
  }
}
