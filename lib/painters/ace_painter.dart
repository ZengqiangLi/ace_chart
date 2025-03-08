import 'dart:math';
import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/mixins/ace_line.dart';
import 'package:ace_chart/mixins/ace_cross.dart';
import 'package:ace_chart/mixins/ace_grid.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:ace_chart/utils/utils.dart';
import 'package:flutter/material.dart';

/// 12 是底部时间的高度
const double horizontalTextHeight = 12.0;

abstract class AcePainter extends BasePainter with AceCross, AceGrid, AceLine {
  final List<AceEntity> values;
  final double? lastClose;

  final Color averageLineColor;
  final double average;

  /// 交叉线样式
  final TextStyle crossUpperTextStyle;
  final TextStyle crossLowerTextStyle;
  final Color crossTextBgColor;
  final Color crossTextBorderColor;
  final Color crossLineColor;
  final double crossLineWidth;

  /// ma线颜色，对应多条ma线
  final List<Color> maDayColors;

  /// ma线粗细
  final double maStrokeWidth;

  /// 网格线颜色
  final Color gridLineColor;

  final double gridLineWidth;

  /// 网格垂直分成几格
  final int gridVerticalGrids;

  /// 网格水平分成几格
  final int gridHorizontalGrids;

  final TextStyle gridTextStyle;

  /// 网格数值比lastClose大时展示的颜色
  final TextStyle gridUpperStyle;

  /// 网格数值比lastClose小时展示的颜色
  final TextStyle gridlowerStyle;

  /// 底部水平文字样式
  final TextStyle horizontalTextStyle;
  final String Function(int time) transformTime;

  /// 绘制交叉线回调
  final void Function(
      int index, MainAxisAlignment alignment, Offset pressOffset)? onDrawCross;

  /// 曲线图的绘制高度
  late double contentHeight;
  final Paint _bezierFillPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;
  late double _clipTopValue;
  AcePainter({
    required this.values,
    required super.paddingTop,
    required this.averageLineColor,
    required this.average,
    this.lastClose,
    required super.scrollX,
    required super.scale,
    required super.pointSpace,
    required super.pointWidth,
    super.pressOffset,
    required this.crossUpperTextStyle,
    required this.crossLowerTextStyle,
    required this.crossTextBgColor,
    required this.crossTextBorderColor,
    required this.crossLineColor,
    required this.crossLineWidth,
    required this.maDayColors,
    required this.maStrokeWidth,
    required this.gridLineColor,
    required this.gridVerticalGrids,
    required this.gridHorizontalGrids,
    required this.gridLineWidth,
    required this.gridUpperStyle,
    required this.gridTextStyle,
    required this.gridlowerStyle,
    required this.horizontalTextStyle,
    required this.transformTime,
    this.onDrawCross,
  });

  void onDrawCart(Canvas canvas);
  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    drawCross(canvas);
  }

  @override
  void onCompute(Size size) {
    super.onCompute(size);
    _clipTopValue = maxValue;

    contentHeight = canvasHeight - horizontalTextHeight - paddingTop;
  }

  @override
  void onDraw(Canvas canvas) {
    _drawGrid(canvas);
    _drawAverage(canvas);
    _drawChart(canvas);
  }

  void _drawChart(Canvas canvas) {
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, canvasWidth, contentHeight));
    canvas.translate(scrollX, 0);
    onDrawCart(canvas);
    canvas.restore();
  }

  void _drawGrid(Canvas canvas) {
    drawGrid(
        canvas: canvas,
        canvasHeight: contentHeight,
        canvasWidth: canvasWidth,
        paddingTop: paddingTop,
        verticalGrids: gridVerticalGrids,
        strokeWidth: gridLineWidth,
        horizontalGrids: gridHorizontalGrids,
        lineColor: gridLineColor);
    if (values.isEmpty) {
      return;
    }

    drawGridText(
      canvas: canvas,
      canvasHeight: contentHeight,
      paddingTop: paddingTop,
      canvasWidth: canvasWidth,
      verticalGrids: gridVerticalGrids,
      horizontalGrids: gridHorizontalGrids,
      maxValue: maxValue,
      minValue: minValue,
      lastClose: lastClose,
      upperStyle: gridUpperStyle,
      gridTextStyle: gridTextStyle,
      lowerStyle: gridlowerStyle,
    );
    _drawHorizontalText(canvas);
  }

  /// 绘制底部文字
  void _drawHorizontalText(Canvas canvas) {
    String st = transformTime(values[startIndex].time);
    TextStyle style = horizontalTextStyle
        .copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

    TextPainter spainter = createText(text: st, style: style);

    spainter.paint(canvas, Offset(0, canvasHeight - spainter.height));

    if (endIndex >= values.length) {
      return;
    }
    double edx;
    if (endIndex < values.length - 1) {
      edx = canvasWidth;
    } else {
      edx = indexToX(endIndex) * scale + scrollX;
    }
    if (edx < spainter.width * 2) {
      return;
    }
    String et = transformTime(values[endIndex].time);

    TextPainter epainter = createText(text: et, style: style);
    double ex = edx - epainter.width / 2;
    if (ex >= canvasWidth - epainter.width) {
      ex = canvasWidth - epainter.width;
    }
    epainter.paint(canvas, Offset(ex, canvasHeight - spainter.height));

    double horizontalSpace = canvasWidth / gridHorizontalGrids;
    for (int i = 1; i < gridHorizontalGrids; i++) {
      int index = bisectionTransformXToIndex(
          dxToTransformX(horizontalSpace * i), startIndex, endIndex);
      double dx = horizontalSpace * i;
      if (dx > edx - epainter.width * 2) {
        return;
      }

      String text = transformTime(values[index].time);

      TextPainter painter = createText(text: text, style: style);

      painter.paint(canvas,
          Offset(dx - painter.width / 2, canvasHeight - spainter.height));
    }
  }

  double getRealItemWidth() {
    return pointWidth;
  }

  int getCrossIndex();
  double getCrossDx(int index);

  /// 绘制交叉线
  void drawCross(Canvas canvas) {
    if (pressOffset == null) {
      if (onDrawCross != null) {
        onDrawCross!(-1, MainAxisAlignment.start, Offset.zero);
      }
      return;
    }
    int index = getCrossIndex();

    /// 二分法查找当前选中索引
    if (index < startIndex) {
      index = startIndex;
    } else if (index > endIndex) {
      index = endIndex;
    }

    final item = values[index];
    double dy = valueToY(item.close);
    double dx = getCrossDx(index);
    double close = values[index].close;
    String xtext = Utils.toStringAsFixed(close);
    TextStyle crossStyle = crossUpperTextStyle;
    if (lastClose != null) {
      String t = Utils.calcStockPriceRatio(lastClose!, close);
      if (t.contains('-')) {
        crossStyle = crossLowerTextStyle;
      }
      xtext = "$xtext $t";
    }
    drawCrossLine(
        canvas: canvas,
        canvasWidth: canvasWidth,
        canvasHeight: contentHeight,
        scrollX: scrollX,
        scale: scale,
        dx: dx,
        dy: dy,
        strokeWidth: crossLineWidth,
        color: crossLineColor);

    drawCrossText(
        canvas: canvas,
        canvasWidth: canvasWidth,
        canvasHeight: canvasHeight,
        scrollX: scrollX,
        scale: scale,
        pressX: pressOffset!.dx,
        dx: dx,
        dy: dy,
        yText: transformTime(values[index].time),
        xText: xtext,
        bgColor: crossTextBgColor,
        borderColor: crossTextBorderColor,
        style: crossStyle);

    if (onDrawCross != null) {
      onDrawCross!(
          index,
          pressOffset!.dx < canvasWidth / 2
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          pressOffset!);
    }
  }

  /// 绘制均线
  void _drawAverage(Canvas canvas) {
    if (average > 0) {
      double y = valueToY(average);
      if (y > contentHeight) {
        return;
      }
      canvas.save();
      canvas.translate(scrollX, 0);
      canvas.scale(scale, 1);
      drawVerticalDottedLine(
        canvas: canvas,
        canvasWidth: dxToTransformX(canvasWidth),
        scale: scale,
        color: averageLineColor,
        y: y,
      );
      canvas.restore();
    }
  }

  /// 绘制曲线图
  void drawLineCart(
      {required Canvas canvas,
      required int maxLength,
      required double strokeWidth,
      required Color lineColor,
      Shader? chartShader}) {
    if (getValues().isEmpty) {
      return;
    }
    double startX = 0;
    double startY = 0;
    Path? clipPath;
    int length = values.length;
    List<double>? maStartYs;
    if (length >= maxLength) {
      length += 1;
    }
    for (int i = 0; i < length; i++) {
      int index = i;
      if (index == values.length) {
        index--;
      }
      final item = values[index];
      double x = indexToX(i) * scale;
      double y = valueToY(item.close);
      if (i == 0) {
        startX = 0;
        startY = y;
        if (chartShader != null) {
          clipPath ??= Path();
        }
        clipPath?.moveTo(0, canvasHeight);
      }
      clipPath?.lineTo(x, y);

      drawLine(
          canvas: canvas,
          startX: startX,
          startY: startY,
          endX: x,
          endY: y,
          strokeWidth: strokeWidth,
          color: lineColor);

      if (item.mas != null) {
        maStartYs ??= List.filled(item.mas!.length, 0);
        for (int m = 0, len = item.mas!.length; m < len; m++) {
          double ma = item.mas![m];
          if (ma > 0) {
            double my = valueToY(ma);
            if (maStartYs[m] == 0) {
              maStartYs[m] = my;
            }

            drawLine(
                canvas: canvas,
                startX: startX,
                startY: maStartYs[m],
                endX: x,
                endY: my,
                strokeWidth: maStrokeWidth,
                color: maDayColors[m]);
            maStartYs[m] = my;
          }
        }
      }

      /// 绘制最后一个点的 指示器
      if (index == values.length - 1 && values.length < maxLength) {
        canvas.drawCircle(
            Offset(x, y),
            strokeWidth * 2,
            Paint()
              ..color = lineColor
              ..strokeWidth);
      }
      startX = x;
      startY = y;
    }

    /// 绘制阴影
    if (clipPath != null) {
      getValues().reduce(max);
      canvas.save();
      _bezierFillPaint.shader = chartShader;
      clipPath.lineTo(startX, canvasHeight);
      clipPath.close();
      canvas.clipPath(clipPath);
      var rect = Rect.fromLTWH(
          0, valueToY(_clipTopValue), canvasWidth * scale, canvasHeight);
      canvas.drawRect(rect, _bezierFillPaint);
      canvas.restore();
    }
  }
}
