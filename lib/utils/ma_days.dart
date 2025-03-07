import 'package:ace_chart/controllers/ace_controller.dart';
import 'package:ace_chart/entitys/ace_entity.dart';

mixin MaDays on AceController<AceEntity> {
  List<double> _maHashs = [];
  int _i = 0;
  void clearMaDays() {
    _i = 0;
    _maHashs = [];
  }

  void fallbackMaDays(int index) {
    _i = index - 1;
    if (_maHashs.isNotEmpty) {
      if (index > _maHashs.length - 1) {
        index = _maHashs.length - 1;
      }
      _maHashs = _maHashs.sublist(0, index);
    }
  }

  void calculateMaDays(List<int> days) {
    int maLength = days.length;
    if (_maHashs.isEmpty || _maHashs.length != days.length) {
      _i = 0;
      _maHashs = List<double>.filled(maLength, 0);
    }
    for (int len = values.length; _i < len; _i++) {
      AceEntity item = values[_i];
      item.mas = List<double>.filled(maLength, 0);
      for (int m = 0; m < maLength; m++) {
        _maHashs[m] += item.close;
        if (_i == days[m] - 1) {
          item.mas?[m] = _maHashs[m] / days[m];
        } else if (_i >= days[m]) {
          _maHashs[m] -= values[_i - days[m]].close;
          item.mas?[m] = _maHashs[m] / days[m];
        } else {
          item.mas?[m] = 0;
        }
      }
    }
  }
}
