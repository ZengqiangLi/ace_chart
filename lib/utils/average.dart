import 'package:ace_chart/ace_chart.dart';
import 'package:ace_chart/controllers/ace_controller.dart';

mixin Average on AceController<AceEntity> {
  double _total = 0;
  int _i = 0;
  double? average;
  void clearAverage() {
    _i = 0;
    _total = 0;
    average = null;
  }

  void fallbackAverage(int index, double newClose) {
    if (index < values.length) {
      _total -= values[index].close;
      _total += newClose;
      average = _total / values.length;
    }
  }

  void calculateAverage() {
    if (values.isEmpty) {
      return;
    }
    for (int len = values.length; _i < len; _i++) {
      _total += values[_i].close;
    }
    average = _total / values.length;
  }
}
