import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';

import 'nav_bar_logo.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: NavigationBarTabletDesktop(),
      tablet: NavigationBarTabletDesktop(),
      mobile: NavigationBarMobile(),
    );
  }
}

class NavigationBarTabletDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarLogo(),
          Row(
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

class NavigationBarMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: null,
            icon: Icon(FontAwesomeIcons.bars, color: Colors.black, size: 24.0),
          ),
          NavBarLogo(),
        ],
      ),
    );
  }
}
