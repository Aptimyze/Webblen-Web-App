import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final BuildContext context;
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  CustomText({this.context, this.text, this.textColor, this.fontSize, this.fontWeight, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.00),
      child: SelectableText(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
        textAlign: textAlign,
      ),
    );
  }
}