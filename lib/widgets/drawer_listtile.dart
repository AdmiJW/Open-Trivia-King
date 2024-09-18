import 'package:flutter/material.dart';

//?===============================
//? A Drawer's ListTile widget
//?===============================
class DrawerListTile extends StatelessWidget {
  final double xPadding, yPadding;
  final IconData? leadingIcon;
  final Color? iconColor;
  final String title;
  final void Function()? onTap;

  final double fontSize;
  final FontWeight fontWeight;
  final Color? fontColor;

  const DrawerListTile({
    super.key,
    this.xPadding = 0,
    this.yPadding = 0,
    this.leadingIcon,
    this.iconColor,
    this.title = "",
    this.onTap,
    this.fontSize = 25,
    this.fontWeight = FontWeight.w100,
    this.fontColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          EdgeInsets.symmetric(horizontal: xPadding, vertical: yPadding),
      leading: Icon(leadingIcon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: fontColor,
        ),
      ),
      onTap: onTap,
    );
  }
}
