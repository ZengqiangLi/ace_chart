import 'package:ace_chart/controllers/ace_controller.dart';
import 'package:ace_chart/entitys/ace_entity.dart';

mixin Macd on AceController<AceEntity> {
  double _ema12 = 0;
  double _ema26 = 0;
  double _dif = 0;
  double _dea = 0;
  double _macd = 0;
  int _i = 0;

  void clearMACD() {
    _ema12 = 0;
    _ema26 = 0;
    _dif = 0;
    _dea = 0;
    _macd = 0;
    _i = 0;
  }

  void fallbackMACD(int index) {
    _i = index - 1;
  }

  void calculateMACD() {
    for (int len = values.length; _i < len; _i++) {
      AceEntity item = values[_i];
      double closePrice = item.close;
      if (_i == 0) {
        _ema12 = closePrice;
        _ema26 = closePrice;
      } else {
        // EMA（12） = 前一日EMA（12） X 11/13 + 今日收盘价 X 2/13
        _ema12 = _ema12 * 11 / 13 + closePrice * 2 / 13;
        // EMA（26） = 前一日EMA（26） X 25/27 + 今日收盘价 X 2/27
        _ema26 = _ema26 * 25 / 27 + closePrice * 2 / 27;
      }
      // DIF = EMA（12） - EMA（26） 。
      // 今日DEA = （前一日DEA X 8/10 + 今日DIF X 2/10）
      // 用（DIF-DEA）*2即为MACD柱状图。
      _dif = _ema12 - _ema26;
      _dea = _dea * 8 / 10 + _dif * 2 / 10;
      _macd = (_dif - _dea) * 2;
      item.dif = _dif;
      item.dea = _dea;
      item.macd = _macd;
    }
  }
}
