import 'package:flutter/material.dart';
import 'package:webblen_web_app/styles/custom_colors.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  TextFieldContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        color: CustomColors.textFieldGray,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: child,
    );
  }
}
