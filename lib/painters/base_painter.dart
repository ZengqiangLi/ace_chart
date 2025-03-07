import 'dart:math' as math;
import 'package:flutter/material.dart';

abstract class BasePainter extends CustomPainter {
  final double paddingTop;

  /// 滚动位置
  final double scrollX;

  /// 放大倍数
  final double scale;

  /// 点之间的间距
  final double pointSpace;
  final double pointWidth;
  final Offset? pressOffset;
  final double paddingLeft;
  final double paddingRight;

  List<double> _values = [];

  double canvasWidth = 0;
  double canvasHeight = 0;
  late int startIndex;
  late int endIndex;

  /// 最小数据
  late double minValue;

  /// 最大数据
  late double maxValue;

  void onDraw(Canvas canvas);
  double indexToX(int index);
  double valueToY(double value);
  List<double> transformValues();

  BasePainter(
      {required this.scrollX,
      required this.scale,
      required this.pointSpace,
      required this.pointWidth,
      this.paddingTop = 0,
      this.paddingLeft = 0,
      this.paddingRight = 0,
      this.pressOffset}) {
    _values = transformValues();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    onCompute(size);
    canvas.clipRect(Rect.fromLTRB(0, 0, canvasWidth, canvasHeight));
    onDraw(canvas);
  }

  /// 获取画布宽度和高度
  /// 计算当前屏内相对转换后的X轴位置
  /// 根据X轴位置，计算屏内起始和结束展示数据的索引
  /// 计算最大值和最小值
  void onCompute(Size size) {
    canvasWidth = size.width;
    canvasHeight = size.height;

    /// 通过二分查找法找出当前屏幕内显示的数据索引
    double startX = dxToTransformX(0);
    double endX = dxToTransformX(canvasWidth);
    startIndex = transformXToIndex(startX);
    endIndex = transformXToIndex(endX);
    if (getValues().isNotEmpty) {
      if (startIndex == endIndex) {
        startIndex = 0;
        endIndex = getValues().length;
      }
      List<double> vals = getValues().sublist(startIndex, endIndex);
      minValue = vals.reduce(math.min);
      maxValue = vals.reduce(math.max);
    } else {
      minValue = 0;
      maxValue = 0;
    }
  }

  /// 获取转换后的数据列表
  List<double> getValues() {
    return _values;
  }

  /// X轴坐标值转translate后的坐标值
  double dxToTransformX(double dx) {
    return (-scrollX + dx) / scale;
  }

  /// 将translate后的坐标值转换成数据索引
  int transformXToIndex(double translateX) =>
      bisectionTransformXToIndex(translateX, 0, getValues().length - 1);

  /// 二分查找法
  int bisectionTransformXToIndex(double x, int start, int end) {
    if (end == start || end == -1) {
      return start;
    }
    if (end - start == 1) {
      double startValue = indexToX(start);
      double endValue = indexToX(end);
      return (x - startValue).abs() < (x - endValue).abs() ? start : end;
    }
    int mid = start + (end - start) ~/ 2;
    double midValue = indexToX(mid);
    if (x < midValue) {
      return bisectionTransformXToIndex(x, start, mid);
    } else if (x > midValue) {
      return bisectionTransformXToIndex(x, mid, end);
    } else {
      return mid;
    }
  }

  /// 创建一个文本TextPainter
  TextPainter createText({
    required String text,
    required TextStyle style,
  }) {
    TextPainter epainter = TextPainter()
      ..text = TextSpan(text: text, style: style)
      ..textDirection = TextDirection.ltr
      ..layout();

    return epainter;
  }
}
