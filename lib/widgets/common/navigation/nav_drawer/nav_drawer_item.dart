import 'package:flutter/material.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class NavDrawerItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  NavDrawerItem({this.title, this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, top: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Icon(iconData, size: 16),
            SizedBox(width: 16.0),
            CustomText(
              context: context,
              text: title,
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
