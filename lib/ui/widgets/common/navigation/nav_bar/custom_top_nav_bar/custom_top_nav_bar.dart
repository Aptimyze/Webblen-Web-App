import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class CustomTopNavBar extends StatelessWidget {
  final List<Widget>? navBarItems;

  CustomTopNavBar({this.navBarItems});

  final WebblenBaseViewModel? _webblenBaseViewModel = locator<WebblenBaseViewModel>();

  Widget desktopNavBar(BuildContext context) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      color: appBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: thirdScreenWidth(context) - 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _webblenBaseViewModel!.navigateToHomeWithIndex(0),
                  child: SizedBox(
                    height: 40,
                    child: Image.asset(
                      'assets/images/webblen_coin.png',
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ).showCursorOnHover,
                horizontalSpaceSmall,
                GestureDetector(
                  onTap: () => _webblenBaseViewModel!.navigateToHomeWithIndex(0),
                  child: SizedBox(
                    height: 30,
                    child: Image.asset(
                      'assets/images/webblen_logo_text.png',
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ).showCursorOnHover,
              ],
            ),
          ),
          Container(
            width: thirdScreenWidth(context) - 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: navBarItems!,
            ),
          ),
        ],
      ),
    );
  }

  Widget tabletNavBar(BuildContext context) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      color: appBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: thirdScreenWidth(context) - 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _webblenBaseViewModel!.navigateToHomeWithIndex(0),
                  child: SizedBox(
                    height: 40,
                    child: Image.asset(
                      'assets/images/webblen_coin.png',
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ).showCursorOnHover,
                horizontalSpaceSmall,
                GestureDetector(
                  onTap: () => _webblenBaseViewModel!.navigateToHomeWithIndex(0),
                  child: _webblenBaseViewModel!.cityName == null
                      ? SizedBox(
                          height: 30,
                          child: Image.asset(
                            'assets/images/webblen_logo_text.png',
                            filterQuality: FilterQuality.low,
                          ),
                        )
                      : AutoSizeText(
                          _webblenBaseViewModel!.cityName!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                ).showCursorOnHover,
              ],
            ),
          ),
          Container(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: navBarItems!,
            ),
          ),
        ],
      ),
    );
  }

  Widget mobileNavBar(BuildContext context) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      color: appBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: thirdScreenWidth(context) - 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _webblenBaseViewModel!.navigateToHomeWithIndex(0),
                  child: SizedBox(
                    height: 40,
                    child: Image.asset(
                      'assets/images/webblen_coin.png',
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ).showCursorOnHover,
                horizontalSpaceSmall,
                GestureDetector(
                  onTap: () => _webblenBaseViewModel!.navigateToHomeWithIndex(0),
                  child: _webblenBaseViewModel!.cityName == null
                      ? Container()
                      : Container(
                          constraints: BoxConstraints(
                            maxWidth: 250,
                          ),
                          child: AutoSizeText(
                            _webblenBaseViewModel!.cityName!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxFontSize: 20,
                            minFontSize: 12,
                            maxLines: 1,
                          ),
                        ),
                ).showCursorOnHover,
              ],
            ),
          ),
          Container(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: navBarItems!,
            ),
          ),
        ],
      ),
    );
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
