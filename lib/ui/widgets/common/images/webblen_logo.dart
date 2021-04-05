import 'package:flutter/material.dart';

class WebblenLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: Image.asset(
        "assets/images/webblen_logo_text.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
