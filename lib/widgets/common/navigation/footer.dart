import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_icon_button.dart';
import 'package:webblen_web_app/widgets/common/images/webblen_logo.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

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
        child: sizingInfo.deviceScreenType == DeviceScreenType.Mobile ? MobileFooterContent() : LargeFooterContent(),
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
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  WebblenLogo(),
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
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "About",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "Team",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "Our Mission",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "Investors",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
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
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "Events",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "Communities",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "Advertising",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
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
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "Whitepaper",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "News & Blog",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "Help/FAQ",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
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
        SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                context: context,
                text: "© Webblen Inc.",
                textColor: Colors.black,
                textAlign: TextAlign.right,
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}

class MobileFooterContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          WebblenLogo(),
          SizedBox(height: 16.0),
          CustomText(
            context: context,
            text: "Company",
            textColor: Colors.black54,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: null,
            child: CustomText(
              context: context,
              text: "About",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ).showCursorOnHover,
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: null,
            child: CustomText(
              context: context,
              text: "Our Mission",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ).showCursorOnHover,
          SizedBox(height: 32.0),
          CustomText(
            context: context,
            text: "Info",
            textColor: Colors.black54,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: null,
            child: CustomText(
              context: context,
              text: "Events",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ).showCursorOnHover,
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: null,
            child: CustomText(
              context: context,
              text: "Communities",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ).showCursorOnHover,
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: null,
            child: CustomText(
              context: context,
              text: "Advertising",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ).showCursorOnHover,
          SizedBox(height: 32.0),
          CustomText(
            context: context,
            text: "Useful Links",
            textColor: Colors.black54,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: null,
            child: CustomText(
              context: context,
              text: "Whitepaper",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ).showCursorOnHover,
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: null,
            child: CustomText(
              context: context,
              text: "News & Blog",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ).showCursorOnHover,
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: null,
            child: CustomText(
              context: context,
              text: "Help/FAQ",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ).showCursorOnHover,
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
                    ).showCursorOnHover,
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
                    ).showCursorOnHover,
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
                    ).showCursorOnHover,
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
                    ).showCursorOnHover,
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
                    ).showCursorOnHover,
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
                    ).showCursorOnHover,
                  ],
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      context: context,
                      text: "© Webblen Inc.",
                      textColor: Colors.black,
                      textAlign: TextAlign.center,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
