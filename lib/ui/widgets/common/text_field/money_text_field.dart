import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/widgets/common/text_field/text_field_container.dart';

class MoneyTextField extends StatelessWidget {
  final MoneyMaskedTextController controller;
  final String hintText;
  final int textLimit;
  MoneyTextField({@required this.controller, @required this.hintText, @required this.textLimit});

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      height: 38,
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: appFontColor()),
        cursorColor: appFontColor(),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
