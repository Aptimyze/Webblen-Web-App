import 'package:flutter/material.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class ZeroStateView extends StatelessWidget {
  final String title;
  final String desc;
  final VoidCallback buttonAction;
  final String buttonTitle;
  ZeroStateView({this.title, this.desc, this.buttonAction, this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomText(
            context: context,
            text: title,
            textColor: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          CustomText(
            context: context,
            text: desc,
            textColor: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          CustomColorButton(
            text: buttonTitle,
            textColor: Colors.black,
            textSize: 18.0,
            height: 45.0,
            width: 300.0,
            backgroundColor: Colors.white,
            onPressed: buttonAction,
          ).showCursorOnHover,
        ],
      ),
    );
  }
}
