class AceEntity {
  final int index;

  /// 开盘价
  final double open;

  /// 最高价
  final double high;

  /// 最低价
  final double low;

  /// 收盘价
  final double close;

  /// 成交量
  final double volume;

  /// 成交金额
  final double amount;

  /// 时间 09:31
  final int time;

  /// 移动平均线
  List<double>? mas;

  /// macd
  double? dif = 0;
  double? dea = 0;
  double? macd = 0;

  /// 成交量ma
  double? ma5Volume;
  double? ma10Volume;

  /// rsi
  List<double?>? rsis;

  /// kdj
  double? k;
  double? d;
  double? j;

  AceEntity(
      {this.index = 0,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.volume,
      required this.time,
      required this.amount});

  AceEntity copyWith({required int index, required int time}) {
    AceEntity entity = AceEntity(
        index: index,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
        amount: amount,
        time: time);
    return entity;
  }
}
