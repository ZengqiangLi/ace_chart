import 'package:ace_chart/controllers/ace_controller.dart';
import 'package:ace_chart/entitys/ace_entity.dart';
import 'package:ace_chart/utils/average.dart';
import 'package:ace_chart/utils/ma_days.dart';
import 'package:ace_chart/utils/macd.dart';
import 'package:ace_chart/utils/vol_ma.dart';

/// 股票指标控制器
class AceStockMetricController extends AceController<AceEntity>
    with VolMa, Macd, MaDays, Average {
  final bool useVOLMA;
  final bool useMACD;
  final bool useKdj;
  final bool useAverage;
  final List<int> maDays;
  final List<int> rsiDays;
  AceStockMetricController(
      {super.maxScale,
      this.useVOLMA = false,
      this.useMACD = false,
      this.useKdj = false,
      this.useAverage = false,
      this.rsiDays = const [1, 6, 12],
      this.maDays = const [5, 10, 20, 30],
      super.pointWidth = 1,
      super.pointSpace,
      super.paddingRight = 0,
      super.onScrollBoundary,
      required super.maxLength});
  @override
  void addAll(List<AceEntity> vals) {
    testMostRightNotifyChanged(() {
      values.addAll(vals);
      metric();
    });
  }

  @override
  void addValue(AceEntity value) {
    testMostRightNotifyChanged(() {
      values.add(value);
      metric();
    });
  }

  @override
  void replace(int index, AceEntity val) {
    testMostRightNotifyChanged(() {
      fallbackAverage(index, val.close);
      fallbackMaDays(index);
      fallbackMACD(index);
      fallbackVolumeMA(index);
      values.removeAt(index);
      values.insert(index, val);
      metric();
    });
  }

  @override
  void replaceAll(List<AceEntity> vals) {
    testMostRightNotifyChanged(() {
      clear();
      addAll(vals);
      metric();
    });
  }

  @override
  void clear() {
    super.clear();
    clearAverage();
    clearVolumeMA();
    clearMACD();
    clearMaDays();
  }

  void metric() {
    if (useAverage) {
      calculateAverage();
    }
    if (maDays.isNotEmpty) {
      calculateMaDays(maDays);
    }
    if (useVOLMA) {
      calculateVolumeMA();
    }
    if (useMACD) {
      calculateMACD();
    }
  }
}
