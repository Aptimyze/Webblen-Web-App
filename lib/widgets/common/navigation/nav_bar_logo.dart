import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Image.asset(
        "assets/images/webblen_logo_text.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
