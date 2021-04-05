import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/images/webblen_logo.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

import '../../custom_text.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) => Container(
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
        decoration: BoxDecoration(
          color: CustomColors.iosOffWhite,
          border: Border(
            top: BorderSide(color: CustomColors.textFieldGray, width: 2.0),
          ),
        ),
        child: screenSize.isMobile ? MobileFooterContent() : LargeFooterContent(),
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
                    child: CustomText(
                      color: appFontColor(),
                      text: "Company",
                      textAlign: TextAlign.left,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/"),
                    child: Text(
                      "About",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/team"),
                    child: Text(
                      "Team",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
//                  SizedBox(height: 12.0),
//                  GestureDetector(
//                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/faq"),
//                    child: Text(
//                      "Our Mission",
//                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
//                      textAlign: TextAlign.left,
//                    ),
//                  ).showCursorOnHover,
//                  SizedBox(height: 12.0),
//                  GestureDetector(
//                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/faq"),
//                    child: Text(
//                      "Investors",
//                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
//                      textAlign: TextAlign.left,
//                    ),
//                  ).showCursorOnHover,
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
                    child: CustomText(
                      color: appFontColor(),
                      text: "Info",
                      textAlign: TextAlign.left,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/"),
                    child: Text(
                      "Events",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/"),
                    child: Text(
                      "Communities",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/"),
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
                    child: CustomText(
                      color: appFontColor(),
                      text: "Useful Links",
                      textAlign: TextAlign.left,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/whitepaper"),
                    child: Text(
                      "Whitepaper",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/blog"),
                    child: Text(
                      "News & Blog",
                      style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ).showCursorOnHover,
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/faq"),
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
                        onPressed: () => UrlHandler().launchInWebViewOrVC("https://www.facebook.com/WebblenINC/"),
                        icon: Icon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ).showCursorOnHover,
                      SizedBox(width: 8.0),
                      CustomIconButton(
                        onPressed: () => UrlHandler().launchInWebViewOrVC("https://twitter.com/Webbleninc"),
                        icon: Icon(
                          FontAwesomeIcons.twitter,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ).showCursorOnHover,
                      SizedBox(width: 8.0),
                      CustomIconButton(
                        onPressed: () => UrlHandler().launchInWebViewOrVC("https://www.youtube.com/channel/UCq-j_ehFRGBcW4xV25iS7cw"),
                        icon: Icon(
                          FontAwesomeIcons.youtube,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ).showCursorOnHover,
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      CustomIconButton(
                        onPressed: () => UrlHandler().launchInWebViewOrVC("https://www.instagram.com/official_webblen/"),
                        icon: Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ).showCursorOnHover,
                      SizedBox(width: 8.0),
                      CustomIconButton(
                        onPressed: () => UrlHandler().launchInWebViewOrVC("https://discord.com/invite/5cxGQmt"),
                        icon: Icon(
                          FontAwesomeIcons.discord,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ).showCursorOnHover,
                      SizedBox(width: 8.0),
                      CustomIconButton(
                        onPressed: () => UrlHandler().launchInWebViewOrVC("https://www.producthunt.com/posts/webblen"),
                        icon: Icon(
                          FontAwesomeIcons.productHunt,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ).showCursorOnHover,
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
                color: appFontColor(),
                text: "© Webblen Inc.",
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
            color: appFontColor(),
            text: "Company",
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/"),
            child: Text(
              "About",
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ).showCursorOnHover,
          SizedBox(height: 12.0),
          GestureDetector(
            onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/team"),
            child: Text(
              "Team",
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ).showCursorOnHover,
          SizedBox(height: 8.0),
          SizedBox(height: 32.0),
          CustomText(
            color: appFontColor(),
            text: "Info",
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/"),
            child: Text(
              "Events",
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ).showCursorOnHover,
          SizedBox(height: 12.0),
          GestureDetector(
            onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/"),
            child: Text(
              "Communities",
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ).showCursorOnHover,
          SizedBox(height: 12.0),
          GestureDetector(
            onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/"),
            child: Text(
              "Advertising",
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ).showCursorOnHover,
          SizedBox(height: 32.0),
          CustomText(
            color: appFontColor(),
            text: "Useful Links",
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/whitepaper"),
            child: Text(
              "Whitepaper",
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ).showCursorOnHover,
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/blog"),
            child: Text(
              "News & Blog",
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ).showCursorOnHover,
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () => UrlHandler().launchInWebViewOrVC("https://www.webblen.io/faq"),
            child: Text(
              "Help/FAQ",
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
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
                      onPressed: () => UrlHandler().launchInWebViewOrVC("https://www.facebook.com/WebblenINC/"),
                      icon: Icon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ).showCursorOnHover,
                    SizedBox(width: 8.0),
                    CustomIconButton(
                      onPressed: () => UrlHandler().launchInWebViewOrVC("https://twitter.com/Webbleninc"),
                      icon: Icon(
                        FontAwesomeIcons.twitter,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ).showCursorOnHover,
                    SizedBox(width: 8.0),
                    CustomIconButton(
                      onPressed: () => UrlHandler().launchInWebViewOrVC("https://www.youtube.com/channel/UCq-j_ehFRGBcW4xV25iS7cw"),
                      icon: Icon(
                        FontAwesomeIcons.youtube,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ).showCursorOnHover,
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    CustomIconButton(
                      onPressed: () => UrlHandler().launchInWebViewOrVC("https://www.instagram.com/official_webblen/"),
                      icon: Icon(
                        FontAwesomeIcons.instagram,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ).showCursorOnHover,
                    SizedBox(width: 8.0),
                    CustomIconButton(
                      onPressed: () => UrlHandler().launchInWebViewOrVC("https://discord.com/invite/5cxGQmt"),
                      icon: Icon(
                        FontAwesomeIcons.discord,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ).showCursorOnHover,
                    SizedBox(width: 8.0),
                    CustomIconButton(
                      onPressed: () => UrlHandler().launchInWebViewOrVC("https://www.producthunt.com/posts/webblen"),
                      icon: Icon(
                        FontAwesomeIcons.productHunt,
                        color: appFontColor(),
                        size: 20.0,
                      ),
                    ).showCursorOnHover,
                  ],
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "© Webblen Inc.",
                      color: Colors.black,
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
