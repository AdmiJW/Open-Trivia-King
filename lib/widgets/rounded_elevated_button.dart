import 'package:flutter/material.dart';

//?======================================
//? A rounded elevated button wrapped in
//? Padding class to simulate Margin
//?======================================
class RoundedElevatedButton extends StatelessWidget {
  // If child is not null, then use child. Otherwise use text
  final String text;
  final Widget? child;

  final double fontSize, xPadding, yPadding, xMargin, yMargin, borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final void Function()? onPressed;

  // Constructor
  const RoundedElevatedButton({
    Key? key,
    this.text = "",
    this.child,
    this.fontSize = 10,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.xPadding = 0,
    this.yPadding = 5,
    this.xMargin = 0,
    this.yMargin = 10,
    this.borderRadius = 5,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: yMargin, horizontal: xMargin),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Sansation',
          ),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding:
              EdgeInsets.symmetric(horizontal: xPadding, vertical: yPadding),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        ),
        child: child ??
            Text(
              text,
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}
