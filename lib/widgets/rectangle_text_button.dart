import 'package:flutter/material.dart';
import 'package:sportal/util/color_constants.dart';

class RectangleTextButton extends StatelessWidget {
  const RectangleTextButton({
    required this.child,
    this.onPressed,
    this.padding,
  });

  final Widget child;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
        child: child,
      ),
    );
  }
}
