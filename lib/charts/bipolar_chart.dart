import 'package:ace_chart/ace_state.dart';
import 'package:ace_chart/charts/bar_chart.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:ace_chart/painters/bipolar_chart_painter.dart';
import 'package:flutter/material.dart';

/// 双极柱状图
class BipolarChart<T> extends BarChart<T> {
  const BipolarChart({
    super.key,
    super.child,
    super.upperColor = Colors.red,
    super.fairColor = Colors.black45,
    super.lowerColor = Colors.green,
    super.strokeWidth = 1,
    super.upperStyle = PaintingStyle.fill,
    super.fairStyle = PaintingStyle.fill,
    super.lowerStyle = PaintingStyle.fill,
    super.crossLineColor = Colors.red,
    super.crossLineWidth = 0.5,
    required super.transform,
    required super.transformBarStyle,
    super.textStyle,
    super.paddingTop,
    super.showText,
  });

  @override
  State<StatefulWidget> createState() {
    return BipolarChartState<T>();
  }
}

class BipolarChartState<T> extends AceState<BipolarChart<T>, T> {
  @override
  BasePainter builder(BuildContext context) {
    final data = watchController();
    final painter = BipolarChartPainter(
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
        transform: widget.transform,
        transformBarStyle: widget.transformBarStyle,
        textStyle: widget.textStyle,
        showText: widget.showText);
    return painter;
  }
}
