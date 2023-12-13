import 'package:flutter/material.dart';

class ConditionalWidgetRenderer extends StatelessWidget {
  final bool condition;
  final Widget truthy;
  final Widget falsy;
  const ConditionalWidgetRenderer(
      {Key? key,
      required this.condition,
      required this.truthy,
      required this.falsy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (condition) ? truthy : falsy;
  }
}
