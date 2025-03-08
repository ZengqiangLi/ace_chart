// ignore: file_names
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 自定义Recognizer 解决scale被Drag手势优先竞争胜利问题

class DragScaleGestureDetector extends StatefulWidget {
  final GestureScaleStartCallback? onScaleStart;

  final GestureScaleUpdateCallback? onScaleUpdate;

  final GestureScaleEndCallback? onScaleEnd;
  final GestureDragDownCallback? onHorizontalDragDown;

  final GestureDragStartCallback? onHorizontalDragStart;
  final GestureDragUpdateCallback? onHorizontalDragUpdate;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final GestureDragCancelCallback? onHorizontalDragCancel;
  final GestureTapUpCallback? onTapUp;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureLongPressUpCallback? onLongPressUp;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressCancelCallback? onLongPressCancel;
  final DragStartBehavior dragStartBehavior;

  final Widget child;

  const DragScaleGestureDetector({
    super.key,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onTapUp,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onLongPressCancel,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _DragScaleGestureDetectorState();
}

class _DragScaleGestureDetectorState extends State<DragScaleGestureDetector> {
  bool scaleIng = false;
  bool longPressIng = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: widget.onTapUp,
      onLongPressStart: (details) {
        longPressIng = true;
        if (widget.onLongPressStart != null) {
          widget.onLongPressStart!(details);
        }
      },
      onLongPressMoveUpdate: (details) {
        if (widget.onLongPressMoveUpdate != null) {
          widget.onLongPressMoveUpdate!(details);
        }
      },
      onLongPressEnd: (details) {
        longPressIng = false;
        if (widget.onLongPressEnd != null) {
          widget.onLongPressEnd!(details);
        }
      },
      onLongPressCancel: () {
        longPressIng = false;
        if (widget.onLongPressCancel != null) {
          widget.onLongPressCancel!();
        }
      },
      onVerticalDragUpdate: (details) {},
      onHorizontalDragDown: widget.onHorizontalDragDown,
      onHorizontalDragStart: widget.onHorizontalDragStart,
      onHorizontalDragUpdate: (e) {
        if (scaleIng) {
          return;
        }
        if (widget.onHorizontalDragUpdate != null) {
          widget.onHorizontalDragUpdate!(e);
        }
      },
      onHorizontalDragEnd: widget.onHorizontalDragEnd,
      onHorizontalDragCancel: widget.onHorizontalDragCancel,
      dragStartBehavior: widget.dragStartBehavior,
      child: RawGestureDetector(
        gestures: {
          _ScaleGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<_ScaleGestureRecognizer>(
                  () => _ScaleGestureRecognizer(), (detector) {
            detector
              ..onStart = (e) {
                if (longPressIng || e.pointerCount < 2) {
                  return;
                }
                if (widget.onScaleStart != null) {
                  widget.onScaleStart!(e);
                }
              }
              ..onUpdate = (e) {
                if (longPressIng || e.pointerCount < 2) {
                  return;
                }
                if (e.scale != 1) {
                  scaleIng = true;
                }
                if (widget.onScaleUpdate != null) {
                  widget.onScaleUpdate!(e);
                }
              }
              ..onEnd = (e) {
                if (longPressIng) {
                  return;
                }
                if (scaleIng) {
                  scaleIng = false;
                  if (widget.onScaleEnd != null) {
                    widget.onScaleEnd!(e);
                  }
                }
              }
              ..dragStartBehavior = widget.dragStartBehavior;
          })
        },
        child: widget.child,
      ),
    );
  }
}

class _ScaleGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    // 一直成功，不许失败,解决scale被Drag手势优先竞争胜利问题
    super.acceptGesture(pointer);
  }
}
