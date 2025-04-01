import 'package:ace_chart/ace_state.dart';
import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/painters/bar_chart_painter.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:ace_chart/ace_widget.dart';
import 'package:ace_chart/painters/capital_flow_chart_painter.dart';
import 'package:flutter/material.dart';

/// 新增资金流向图
class CapitalFlowChart extends AceWidget<AceEntity> {
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
  final double difAndDeaLineWidth;
  final Color difLineColor;
  final Color deaLineColor;
  final TextStyle textStyle;
  final bool showText;
  final double paddingTop;
  final double valueTextFontSize;
  final BarStyle Function(AceEntity) transformBarStyle;
  const CapitalFlowChart({
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
    this.difAndDeaLineWidth = 0.5,
    this.difLineColor = Colors.yellow,
    this.deaLineColor = Colors.blue,
    this.crossLineColor = Colors.red,
    this.crossLineWidth = 0.5,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 8),
    this.showText = true,
    this.valueTextFontSize = 8,
    required this.transformBarStyle,
  });

  @override
  State<StatefulWidget> createState() => CapitalFlowChartState();
}

class CapitalFlowChartState extends AceState<CapitalFlowChart, AceEntity> {
  @override
  BasePainter builder(BuildContext context) {
    final data = watchController();
    final painter = CapitalFlowChartPainter(
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
      valueTextFontSize: widget.valueTextFontSize,
      transform: (values) {
        return values.map((e) => e.flow).toList();
      },
      transformBarStyle: widget.transformBarStyle,
    );
    return painter;
  }
}
