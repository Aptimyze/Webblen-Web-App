import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/search/search_field.dart';

class CustomNavBar extends StatelessWidget {
  final List<Widget> navBarItems;

  CustomNavBar({this.navBarItems});

  Widget desktopNavBar(BuildContext context) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(16),
        //   topRight: Radius.circular(16),
        // ),
        color: appBackgroundColor(),
        boxShadow: [
          BoxShadow(
            color: appShadowColor(),
            spreadRadius: 0.5,
            blurRadius: 1.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: thirdScreenWidth(context) - 16,
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  child: Image.asset(
                    'assets/images/webblen_coin.png',
                    filterQuality: FilterQuality.high,
                  ),
                ),
                horizontalSpaceSmall,
                SearchField(
                  onTap: null,
                  textEditingController: null,
                  onChanged: (val) {},
                  onFieldSubmitted: (val) {},
                ),
              ],
            ),
          ),
          Container(
            width: thirdScreenWidth(context) - 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: navBarItems,
            ),
          ),
        ],
      ),
    );
  }

  Widget tabletNavBar(BuildContext context) {
    return Container();
  }

  Widget mobileNavBar(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (buildContext, screenType) => screenType.isDesktop
          ? desktopNavBar(context)
          : screenType.isTablet
              ? tabletNavBar(context)
              : mobileNavBar(context),
    );
  }
}
