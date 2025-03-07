import 'package:flutter/material.dart';

abstract class AceWidget<T> extends StatefulWidget {
  final Widget? child;
  const AceWidget({super.key, this.child});
}
