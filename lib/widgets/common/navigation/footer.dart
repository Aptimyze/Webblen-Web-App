import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_icon_button.dart';
import 'package:webblen_web_app/widgets/common/navigation/nav_bar_logo.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) => Container(
        //margin: EdgeInsets.only(top: 32.0),
        decoration: BoxDecoration(
          color: CustomColors.iosOffWhite,
          border: Border(
            top: BorderSide(color: CustomColors.textFieldGray, width: 2.0),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: sizingInfo.deviceScreenType == DeviceScreenType.Mobile ? Container() : LargeFooterContent(),
      ),
    );
  }
}

class LargeFooterContent extends StatelessWidget {
  static final appContainer = html.window.document.getElementById('app-container');

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  NavBarLogo(),
                ],
              ),
            ),
            Container(
              height: 200.0,
              //width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Company",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "About",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "Team",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "Our Mission",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "Investors",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200.0,
              //width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Info",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "Events",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "Communities",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "Advertising",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200.0,
              //width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Useful Links",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "Whitepaper",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "News & Blog",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  MouseRegion(
//                    onHover: (event) => appContainer.style.cursor = 'pointer',
//                    onExit: (event) => appContainer.style.cursor = 'default',
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "Help/FAQ",
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200.0,
              //width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 32.0),
                  Row(
                    children: <Widget>[
                      CustomIconButton(
                        onTap: null,
                        icon: Icon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        size: 40.0,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8.0),
                      CustomIconButton(
                        onTap: null,
                        icon: Icon(
                          FontAwesomeIcons.twitter,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        size: 40.0,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8.0),
                      CustomIconButton(
                        onTap: null,
                        icon: Icon(
                          FontAwesomeIcons.youtube,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        size: 40.0,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      CustomIconButton(
                        onTap: null,
                        icon: Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        size: 40.0,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8.0),
                      CustomIconButton(
                        onTap: null,
                        icon: Icon(
                          FontAwesomeIcons.discord,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        size: 40.0,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8.0),
                      CustomIconButton(
                        onTap: null,
                        icon: Icon(
                          FontAwesomeIcons.productHunt,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        size: 40.0,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(),
          ],
        ),
      ],
    );
  }
}
