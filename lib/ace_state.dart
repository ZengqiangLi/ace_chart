import 'package:ace_chart/controllers/ace_controller.dart';
import 'package:ace_chart/ace_consumer.dart';
import 'package:ace_chart/ace_widget.dart';
import 'package:ace_chart/painters/base_painter.dart';
import 'package:flutter/material.dart';

abstract class AceState<T extends AceWidget, D> extends State<T> {
  BasePainter builder(BuildContext context);

  @override
  void initState() {
    super.initState();
    getController().attach(this);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    getController().didUpdateWidget();
  }

  AceController<D> getController() {
    AceController<D> data = AceConsumer.of(context, listen: false);
    return data;
  }

  AceController<D> watchController() {
    AceController<D> data = AceConsumer.of(context);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(builder: (p0, p1) {
        getController().setInnerWidth(p1.maxWidth);
        return CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: builder(context),
          child: widget.child,
        );
      }),
    );
  }
}
