import 'package:flutter/material.dart';

// message is for tooltip message
// child is tooltip child widget
class TooltipWrapper extends StatelessWidget {
  const TooltipWrapper({
    Key? key,
    required this.message,
    required this.child
  }) : super(key: key);

  final Widget child;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Tooltip (
      padding: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      preferBelow: false,
      textStyle: TextStyle(
        fontSize: 12,
        color: Theme.of(context).primaryColor
      ),
      message: message,
      child: child
    );
  }
}