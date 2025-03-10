import 'package:ace_chart/controllers/ace_controller.dart';
import 'package:ace_chart/ace_consumer.dart';
import 'package:ace_chart/gestures/drag_scale_gesture_detector.dart';
import 'package:flutter/material.dart';

class AceContainer<T extends AceController> extends StatefulWidget {
  final T controller;
  final Widget child;

  const AceContainer(
      {super.key, required this.controller, required this.child});

  @override
  State<StatefulWidget> createState() => AceContainerState();
}

class AceContainerState extends State<AceContainer>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  int _mDragTime = 0;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AceConsumer(
      controller: widget.controller,
      builder: (context, data) {
        return DragScaleGestureDetector(
            onTapUp: (details) {
              data.updatePressOffset(details.localPosition);
            },
            onLongPressStart: (details) {
              data.updatePressOffset(details.localPosition);
            },
            onLongPressMoveUpdate: (details) {
              data.updatePressOffset(details.localPosition, true);
            },
            onLongPressUp: () {
              data.updatePressOffset(null);
            },
            onLongPressEnd: (details) {
              data.updatePressOffset(null);
            },
            onScaleStart: data.onScaleStart,
            onScaleUpdate: data.onScaleUpdate,
            onScaleEnd: data.onScaleEnd,
            onHorizontalDragDown: (details) {
              final catchController = data.catchController;
              if (!catchController.canDrag) {
                _mDragTime = DateTime.now().millisecondsSinceEpoch;
                _stopAnimation();
              }
              catchController.onHorizontalDragDown(context, details);
            },
            onHorizontalDragStart: (details) {
              final catchController = data.catchController;
              data.initBoundary();
              catchController.onHorizontalDragStart(context, details);
            },
            onHorizontalDragUpdate: (details) {
              data.initBoundary();
              final catchController = data.catchController;
              if (!catchController.canDrag) {
                data.onHorizontalDragUpdate(details);
              }
              catchController.onHorizontalDragUpdate(context, details);
            },
            onHorizontalDragEnd: (details) {
              final catchController = data.catchController;
              if (!catchController.canDrag) {
                /// 处理一下flutter手势的bug
                /// 速滑停顿后 时间小于200s还会触发惯性
                if (DateTime.now().millisecondsSinceEpoch - _mDragTime > 200) {
                  return;
                }
                var velocity =
                    details.velocity.pixelsPerSecond.dx / data.getScale();

                _onFling(velocity, data);
              }
              catchController.onHorizontalDragEnd(details);
              data.onHorizontalDragEnd();
            },
            onHorizontalDragCancel: () {
              final catchController = data.catchController;
              catchController.onHorizontalDragCancel();
              data.onHorizontalDragCancel();
            },
            child: widget.child);
      },
    );
  }

  void _stopAnimation() {
    _controller?.stop();
  }

  /// 惯性动画执行
  void _onFling(double x, AceController data) {
    int flingTime = 600;
    double flingRatio = 0.5;
    double begin = data.getScrollX() / data.getScale();
    double end = x * flingRatio + begin;
    _controller?.dispose();
    _controller = AnimationController(
        duration: Duration(milliseconds: flingTime), vsync: this);
    _animation = null;
    _animation = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: _controller!.view, curve: Curves.decelerate));
    _animation!.addListener(() {
      double value = _animation!.value;
      data.setScrollX(value);
      data.notifyChanged();
      if (value >= 0) {
        _stopAnimation();
      } else if (value <= data.getMinScrollX() / data.getScale()) {
        _stopAnimation();
      }
    });

    _controller!.forward();
  }
}
