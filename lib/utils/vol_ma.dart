import 'package:ace_chart/controllers/ace_controller.dart';
import 'package:ace_chart/entitys/ace_entity.dart';

mixin VolMa on AceController<AceEntity> {
  double _volma5 = 0;
  double _volma10 = 0;
  int _i = 0;

  void clearVolumeMA() {
    _volma5 = 0;
    _volma10 = 0;
    _i = 0;
  }

  void fallbackVolumeMA(int index) {
    _i = index - 1;
  }

  void calculateVolumeMA() {
    for (int len = values.length; _i < len; _i++) {
      AceEntity item = values[_i];

      _volma5 += item.volume;
      _volma10 += item.volume;

      if (_i == 4) {
        item.ma5Volume = (_volma5 / 5);
      } else if (_i > 4) {
        _volma5 -= values[_i - 5].volume;
        item.ma5Volume = _volma5 / 5;
      } else {
        item.ma5Volume = 0;
      }

      if (_i == 9) {
        item.ma10Volume = _volma10 / 10;
      } else if (_i > 9) {
        _volma10 -= values[_i - 10].volume;
        item.ma10Volume = _volma10 / 10;
      } else {
        item.ma10Volume = 0;
      }
    }
  }
}
