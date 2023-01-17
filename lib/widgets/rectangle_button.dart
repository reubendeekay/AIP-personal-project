import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sportal/util/color_constants.dart';

class RectangleButton extends StatelessWidget {
  final String text;
  final Color? textColor, buttonColor;
  final double textFontSize, elevation;
  final FontWeight textFontWeight;
  final Widget? child;
  final void Function()? onPressed;
  final bool isLoading;
  final EdgeInsets? padding;
  final double radius;
  final BorderSide? borderSide;

  const RectangleButton({
    required this.text,
    this.textColor,
    this.textFontSize = 16.0,
    this.elevation = 4.0,
    this.textFontWeight = FontWeight.bold,
    this.buttonColor,
    this.onPressed,
    this.isLoading = false,
    this.padding,
    this.radius = 8.0,
    this.borderSide,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 46.w,
                height: 46.w,
                child: Card(
                  color: buttonColor ?? primaryColor,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0.w,
                      horizontal: 8.0.w,
                    ),
                    child: Container(
                      height: 30.0.h,
                      width: 30.0.w,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: elevation,
              backgroundColor: buttonColor ?? primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: borderSide ?? BorderSide.none,
              ),
              padding: padding ??
                  EdgeInsets.symmetric(
                    vertical: 14.0.r,
                    horizontal: 15.r,
                  ),
            ),
            onPressed: isLoading ? () {} : onPressed,
            child: isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.r),
                    child: Container(
                      height: 31.0.h,
                      width: 31.0.w,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : child ??
                    Center(
                        child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: textFontSize.w,
                        color: textColor ?? Colors.white,
                        fontWeight: textFontWeight,
                      ),
                    )),
          );
  }
}
