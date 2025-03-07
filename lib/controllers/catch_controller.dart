import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class CatchController {
  Drag? drag;
  CatchParentDrag parentDrag;
  double dragDownDx = 0;
  bool isDragLeft = true;
  bool canDrag = false;
  double distance = 0;
  ScrollHoldController? hold;
  CatchController({
    this.parentDrag = CatchParentDrag.none,
  });

  void next(CatchParentDrag d) {
    parentDrag = d;
    if (parentDrag == CatchParentDrag.none) {
      drag?.cancel();
      hold?.cancel();
      hold = null;
      drag = null;
    }
  }

  void initCanDrag(BuildContext context, double dx, [String? type]) {
    distance = dx - dragDownDx;
    isDragLeft = distance > 0;
    PageView? pageview = context.findAncestorWidgetOfExactType<PageView>();
    if (pageview != null) {
      PageController? controller = pageview.controller;
      if (controller != null) {
        final position = controller.position;
        if (isDragLeft &&
            (parentDrag == CatchParentDrag.all ||
                parentDrag == CatchParentDrag.left) &&
            (controller.page ?? 0) > 0) {
          canDrag = true;
        } else if (!isDragLeft &&
            (parentDrag == CatchParentDrag.all ||
                parentDrag == CatchParentDrag.right)) {
          double max = getMaxPage(position.maxScrollExtent,
              position.viewportDimension, controller.viewportFraction);
          if ((controller.page ?? 0) < max) {
            canDrag = true;
          }
        }
      }
    }
  }

  double getMaxPage(
      double pixels, double viewportDimension, double viewportFraction) {
    assert(viewportDimension > 0.0);
    final double actual =
        math.max(0.0, pixels) / (viewportDimension * viewportFraction);
    final double round = actual.roundToDouble();
    if ((actual - round).abs() < precisionErrorTolerance) {
      return round;
    }
    return actual;
  }

  void onHorizontalDragDown(BuildContext context, DragDownDetails details) {
    dragDownDx = details.localPosition.dx;
    PageView? pageview = context.findAncestorWidgetOfExactType<PageView>();
    if (pageview != null) {
      final position = pageview.controller?.position;
      hold = position?.hold(() {
        hold = null;
      });
    }
  }

  void onHorizontalDragStart(BuildContext context, DragStartDetails details) {
    initCanDrag(context, details.localPosition.dx, 'onHorizontalDragStart');
    if (canDrag) {
      PageView? pageview = context.findAncestorWidgetOfExactType<PageView>();
      if (pageview != null) {
        PageController? controller = pageview.controller;
        if (controller != null) {
          final position = controller.position;
          drag = position.drag(details, () {
            drag = null;
          });
        }
      }
    }
  }

  void onHorizontalDragUpdate(BuildContext context, DragUpdateDetails details) {
    initCanDrag(context, details.localPosition.dx);
    if (canDrag) {
      if (drag == null) {
        PageView? pageview = context.findAncestorWidgetOfExactType<PageView>();
        if (pageview != null) {
          PageController? controller = pageview.controller;
          if (controller != null) {
            final position = controller.position;
            drag = position.drag(
                DragStartDetails(
                  sourceTimeStamp: details.sourceTimeStamp,
                  globalPosition: details.globalPosition,
                  localPosition: details.localPosition,
                ), () {
              drag = null;
            });
          }
        }
      }
      drag?.update(details);
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    drag?.end(details);
    canDrag = false;
    drag = null;
    hold = null;
    parentDrag = CatchParentDrag.none;
  }

  void onHorizontalDragCancel() {
    drag?.cancel();
    hold?.cancel();
    canDrag = false;
    drag = null;
    hold = null;
    parentDrag = CatchParentDrag.none;
  }
}

enum CatchParentDrag { left, none, right, all }

enum CatchDragType { scroll }
