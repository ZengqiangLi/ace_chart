import 'package:flutter/material.dart';

class Utils {
  static String toStringAsFixed(double v, [int fractionDigits = 2]) {
    return v.toStringAsFixed(fractionDigits);
  }

  /// 计算股票涨跌比率
  static String calcStockPriceRatio(
      double lastClosePrice, double currentPrice) {
    String increase = '0.00';
    double diff = currentPrice - lastClosePrice;
    if (diff != 0) {
      increase = toStringAsFixed(diff / lastClosePrice * 100, 2);
    }

    return '$increase%';
  }

  static TextPainter createText(String text, TextStyle style) {
    TextPainter painter = TextPainter()
      ..text = TextSpan(text: text, style: style)
      ..textDirection = TextDirection.ltr
      ..layout();
    return painter;
  }
}
