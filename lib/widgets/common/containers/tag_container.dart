import 'package:flutter/material.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class TagContainer extends StatelessWidget {
  final String tag;
  TagContainer({this.tag});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(
          color: CustomColors.electronBlue,
          width: 2.0,
        ),
      ),
      child: CustomText(
        context: context,
        text: tag,
        textColor: CustomColors.electronBlue,
        textAlign: TextAlign.center,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
