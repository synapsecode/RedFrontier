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

class RedFrontierTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool centeredText;
  final bool obscureText;
  final int maxLines;
  final Color? foregroundColor;
  final Color? backgroundColor;

  final Function(String)? onChanged;
  const RedFrontierTextField({
    Key? key,
    this.controller,
    this.obscureText = false,
    this.hintText,
    this.maxLines = 1,
    this.centeredText = false,
    this.onChanged,
    this.foregroundColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      textCapitalization: TextCapitalization.sentences,
      maxLines: obscureText ? 1 : maxLines,
      textAlign: centeredText ? TextAlign.center : TextAlign.start,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: (foregroundColor ?? Colors.black).withAlpha(150),
        ),
        filled: true,
        fillColor: backgroundColor ?? Colors.grey[300],
        focusColor: Colors.red,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: TextStyle(color: foregroundColor ?? Colors.black87),
    );
  }
}
