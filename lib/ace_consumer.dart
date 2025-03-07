import 'package:ace_chart/controllers/ace_controller.dart';
import 'package:flutter/material.dart';

class _AceInherited extends InheritedWidget {
  final AceController aceData;
  const _AceInherited({required this.aceData, required super.child});

  @override
  bool updateShouldNotify(covariant _AceInherited oldWidget) {
    return true;
  }
}

class AceConsumer extends StatefulWidget {
  final AceController controller;
  final Widget Function(BuildContext context, AceController aceData) builder;
  const AceConsumer(
      {super.key, required this.controller, required this.builder});

  static AceController<T> of<T>(BuildContext context, {bool listen = true}) {
    _AceInherited? inherited;
    if (listen) {
      inherited = context.dependOnInheritedWidgetOfExactType<_AceInherited>();
    } else {
      final element =
          context.getElementForInheritedWidgetOfExactType<_AceInherited>();
      inherited = element?.widget as _AceInherited?;
    }
    return inherited!.aceData as AceController<T>;
  }

  @override
  State<StatefulWidget> createState() => AceConsumerState();
}

class AceConsumerState extends State<AceConsumer> {
  void notifyListeners() {
    Future(
      () {
        if (mounted) {
          setState(() => {});
        }
      },
    );
  }

  @override
  void initState() {
    widget.controller.addListener(notifyListeners);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AceInherited(
      aceData: widget.controller,
      child: widget.builder(context, widget.controller),
    );
  }
}
