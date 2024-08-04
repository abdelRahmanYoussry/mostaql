import 'package:flutter/material.dart';

class ChildBuilder extends StatelessWidget {
  const ChildBuilder({
    Key? key,
    required this.builder,
    required this.child,
  }) : super(key: key);

  final Widget Function(Widget child) builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return builder(child);
  }
}
