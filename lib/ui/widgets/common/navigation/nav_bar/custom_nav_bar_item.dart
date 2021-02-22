import 'package:flutter/material.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';

class CustomNavBarItem extends StatelessWidget {
  final VoidCallback onTap;
  final bool isActive;
  final IconData iconData;

  CustomNavBarItem({this.onTap, this.isActive, this.iconData});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 8),
        height: 40,
        width: 40,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: isActive ? appIconColor() : appInActiveColorAlt(),
              size: 20,
            ),
          ],
        ),
      ),
    ).showCursorOnHover;
  }
}
