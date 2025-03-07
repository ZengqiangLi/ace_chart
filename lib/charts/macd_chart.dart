import 'package:ace_chart/ace_state.dart';
import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/painters/bar_chart_painter.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:ace_chart/painters/macd_chart_painter.dart';
import 'package:ace_chart/ace_widget.dart';
import 'package:flutter/material.dart';

class MacdChart extends AceWidget<AceEntity> {
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
  const MacdChart(
      {super.key,
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
      this.showText = true});

  @override
  State<StatefulWidget> createState() => MacdChartState();
}

class MacdChartState extends AceState<MacdChart, AceEntity> {
  @override
  BasePainter builder(BuildContext context) {
    final data = watchController();
    final painter = MacdChartPainter(
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
      deaLineColor: widget.deaLineColor,
      difLineColor: widget.difLineColor,
      difAndDeaLineWidth: widget.difAndDeaLineWidth,
      crossLineColor: widget.crossLineColor,
      crossLineWidth: widget.crossLineWidth,
      textStyle: widget.textStyle,
      showText: widget.showText,
      transform: (values) {
        return values.map((e) => e.macd!).toList();
      },
      transformBarStyle: (item) {
        BarStyle style;
        if (item.macd! < 0) {
          style = BarStyle.lower;
        } else {
          style = BarStyle.upper;
        }
        return style;
      },
    );
    return painter;
  }
}
