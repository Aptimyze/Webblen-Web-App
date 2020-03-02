import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen_web_app/utils/responsive_layout.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: ResponsiveLayout.isSmallScreen(context) ? 25.0 : 30,
                //padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/webblen_logo_text.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          ResponsiveLayout.isSmallScreen(context)
              ? IconButton(
                  onPressed: null,
                  icon: Icon(FontAwesomeIcons.bars, color: Colors.black, size: 18.0),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CustomColorButton(
                      text: "Login",
                      textSize: null,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      width: 100.00,
                      height: 45.0,
                      onPressed: null,
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
