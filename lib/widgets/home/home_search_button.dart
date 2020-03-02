import 'package:flutter/material.dart';
import 'package:webblen_web_app/styles/custom_colors.dart';
import 'package:webblen_web_app/utils/responsive_layout.dart';

class HomeSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      margin: EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
//        gradient: LinearGradient(colors: [
//          Colors.red,
//          Colors.redAccent,
//        ], begin: Alignment.bottomRight, end: Alignment.topLeft),
        borderRadius: BorderRadius.circular(20.0),
        color: CustomColors.webblenRed,
        // boxShadow: [BoxShadow(color: CustomColors.webblenRed.withOpacity(.3), offset: Offset(0.0, 8.0), blurRadius: 8.0)],
      ),
      child: Center(
        child: Icon(
          Icons.search,
          color: Colors.white,
          size: ResponsiveLayout.isSmallScreen(context) ? 12 : 20.0,
        ),
      ),
    );
  }
}
