import 'package:ace_chart/ace_state.dart';
import 'package:ace_chart/charts/k_chart.dart';
import 'package:ace_chart/charts/line_chart.dart';
import 'package:ace_chart/controllers/catch_controller.dart';
import 'package:flutter/material.dart';

enum ScrollBoundary { left, none, right, all }

class AceController<T> extends ChangeNotifier {
  final double? maxScale;
  final List<T> values = [];
  final int maxLength;
  final double pointWidth;
  final double paddingRight;
  final void Function(ScrollBoundary boundary)? onScrollBoundary;
  double? pointSpace;
  double _mScale = 1;
  double _mLastScale = 1;
  double _mScaleOffsetX = 0;
  double _mLastScaleOffsetX = 0;
  Offset? _mScaleCenterPoint = Offset.zero;
  Offset? _mPressOffset;
  double _mScrollX = 0;

  double _mExtentWidth = 0;
  double _mInnerWidth = 0;

  AceState? _mState;

  CatchController catchController = CatchController();
  AceController({
    this.maxScale,
    this.pointSpace,
    this.onScrollBoundary,
    this.paddingRight = 0,
    required this.maxLength,
    this.pointWidth = 1,
  });

  void sumTotalWidth() {
    int length = values.length;

    _mExtentWidth = (pointWidth + getSpace()) * length + paddingRight;
    if (_mState is LineChartState) {
      /// 分时图少一个间隔
      _mExtentWidth -= getSpace();
    }
  }

  void setInnerWidth(double width) {
    if (_mInnerWidth == width) {
      return;
    }
    testMostRightNotifyChanged(() {
      _mInnerWidth = width;
      calculateSpace();
    });
  }

  void calculateSpace() {
    if (pointSpace != null) {
      return;
    }
    pointSpace = (_mInnerWidth - maxLength) / maxLength;
  }

  double getSpace() {
    return pointSpace ?? 0;
  }

  void testMostRightNotifyChanged(void Function() next) {
    double preScrollX = getScrollX();
    bool mostRight = preScrollX == getMinScrollX();

    next();
    sumTotalWidth();
    double min = getMinScrollX();
    if (mostRight && min != preScrollX && getPressOffset() == null) {
      setScrollX(min / _mScale);
    }
    notifyChanged();
  }

  void attach(AceState s) {
    _mState ??= s;
  }

  bool isKChart() {
    return _mState is KChartState;
  }

  void addValue(T value) {
    testMostRightNotifyChanged(() {
      values.add(value);
    });
  }

  void addAll(List<T> vals) {
    testMostRightNotifyChanged(() {
      values.addAll(vals);
    });
  }

  void replace(int index, T val) {
    testMostRightNotifyChanged(() {
      values.removeAt(index);
      values.insert(index, val);
    });
  }

  void replaceAll(List<T> vals) {
    testMostRightNotifyChanged(() {
      clear();
      values.addAll(vals);
    });
  }

  ScrollBoundary? lastScrollBoundary;
  void notifyChanged() {
    double x = getScrollX();
    double min = getMinScrollX();
    ScrollBoundary boundary;
    if (min == 0) {
      boundary = ScrollBoundary.all;
    } else {
      if (x >= 0) {
        boundary = ScrollBoundary.left;
      } else if (x <= min) {
        boundary = ScrollBoundary.right;
      } else {
        boundary = ScrollBoundary.none;
      }
    }

    if (lastScrollBoundary != boundary) {
      lastScrollBoundary = boundary;
      if (onScrollBoundary != null) {
        onScrollBoundary!(boundary);
      }
      initBoundary();
    }
    notifyListeners();
  }

  void initBoundary() {
    if (lastScrollBoundary == ScrollBoundary.left) {
      catchController.next(CatchParentDrag.left);
    } else if (lastScrollBoundary == ScrollBoundary.right) {
      catchController.next(CatchParentDrag.right);
    } else if (lastScrollBoundary == ScrollBoundary.all) {
      catchController.next(CatchParentDrag.all);
    } else {
      catchController.next(CatchParentDrag.none);
    }
  }

  void didUpdateWidget() {
    double scale = _mScale;
    double scrollX = _mScrollX;
    double scaleOffsetX = _mScaleOffsetX;
    setScrollX(scrollX);
    _setScale(scale);
    _setScaleOffsetX(scaleOffsetX);
    if (scrollX != _mScrollX ||
        scaleOffsetX != _mScaleOffsetX ||
        scale != _mScale) {
      notifyChanged();
    }
  }

  double getScale() {
    return _mScale;
  }

  double getMinScale() {
    /// 如果渲染宽度小于view宽度，最小缩小为1，禁止缩小
    if (_mExtentWidth < _mInnerWidth) {
      return 1;
    } else {
      return _mInnerWidth / _mExtentWidth;
    }
  }

  double getScrollX() {
    double x = _mScaleOffsetX + _mScale * _mScrollX;
    return x;
  }

  double getMinScrollX() {
    double w = _mExtentWidth * _mScale;
    if (w < _mInnerWidth || _mInnerWidth == 0) {
      return 0;
    }
    double min = _mInnerWidth - w - paddingRight;

    return min;
  }

  void setScrollX(double x) {
    _mScrollX = x;

    if (_mScaleOffsetX != 0) {
      _mScrollX += _mScaleOffsetX / _mScale;
      _mScaleOffsetX = 0;
      _mLastScaleOffsetX = 0;
    }

    double dragX = getScrollX();
    double min = getMinScrollX();
    if (dragX > 0) {
      _mScrollX = 0;
    } else if (dragX < min) {
      _mScrollX = min / _mScale;
    }
  }

  void _setScaleOffsetX(double x) {
    _mScaleOffsetX = x;

    double dragX = getScrollX();
    double min = getMinScrollX();
    if (dragX > 0 || min > 0) {
      _mScaleOffsetX = (0 - _mScrollX) * _mScale;
    } else if (dragX < min) {
      _mScaleOffsetX = (min - _mScrollX * _mScale);
    }
  }

  void _setScale(double scale) {
    _mScale = scale;
    double min = getMinScale();
    if (_mScale < min) {
      _mScale = min;
      _mLastScale = _mScale;
    } else if (maxScale != null && _mScale > maxScale!) {
      _mScale = maxScale!;
    }
  }

  void onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount != 2) {
      return;
    }
    _mPressOffset = null;
    _mScaleCenterPoint = details.localFocalPoint;
    notifyChanged();
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale == 1.0) {
      return;
    }
    double scale = _mLastScale * details.scale;
    if (maxScale != null && scale > maxScale! && _mScale == maxScale) {
      return;
    }

    /// 以缩放开始两指中心为坐标，计算缩放距离
    double dx = (_mScaleCenterPoint!).dx;
    double dx2 = dx * details.scale;
    double distance = dx - dx2;
    double x = _mLastScaleOffsetX * details.scale + distance;

    _setScale(scale);
    _setScaleOffsetX(x);
    notifyChanged();
  }

  void onScaleEnd(ScaleEndDetails details) {
    _mLastScale = _mScale;
    _mLastScaleOffsetX = _mScaleOffsetX;
    notifyChanged();
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    /// 这里要除以放大的倍数，不然_mScale越大，滑动速度因子越大
    _mPressOffset = null;
    double x = (details.primaryDelta ?? 0) / _mScale;
    setScrollX(_mScrollX + x);
    notifyChanged();
  }

  void onHorizontalDragCancel() {
    lastScrollBoundary = ScrollBoundary.none;
  }

  void onHorizontalDragEnd() {
    lastScrollBoundary = ScrollBoundary.none;
  }

  void updatePressOffset(Offset? offset, [bool isLong = false]) {
    if (!isLong && offset != null) {
      if (offset.dx / _mScale > _mExtentWidth) {
        offset = null;
      }
    }
    _mPressOffset = offset;
    notifyChanged();
  }

  double getLastScale() {
    return _mLastScale;
  }

  Offset? getPressOffset() {
    return _mPressOffset;
  }

  void reset() {
    _mScale = 1;
    _mLastScale = 1;
    _mScaleOffsetX = 0;
    _mLastScaleOffsetX = 0;
    _mScaleCenterPoint = Offset.zero;
    _mPressOffset;
    _mScrollX = 0;
    _mExtentWidth = 0;
    _mInnerWidth = 0;
  }

  void clear() {
    _mPressOffset = null;
    values.clear();
  }
}
