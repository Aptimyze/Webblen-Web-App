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

  final WebblenBaseViewModel _webblenBaseViewModel = locator<WebblenBaseViewModel>();

  Widget desktopNavBar(BuildContext context) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      color: appBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _webblenBaseViewModel.navigateToHomeWithIndex(0),
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
                    onTap: () => _webblenBaseViewModel.navigateToHomeWithIndex(0),
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
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: navBarItems!,
              ),
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
          Expanded(
            flex: 4,
            child: Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _webblenBaseViewModel.navigateToHomeWithIndex(0),
                    child: SizedBox(
                      height: 40,
                      child: Image.asset(
                        'assets/images/webblen_coin.png',
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ).showCursorOnHover,
                  horizontalSpaceSmall,
                  GestureDetector(
                    onTap: () => _webblenBaseViewModel.navigateToHomeWithIndex(0),
                    child: _webblenBaseViewModel.cityName.isEmpty
                        ? SizedBox(
                            height: 30,
                            child: Image.asset(
                              'assets/images/webblen_logo_text.png',
                              filterQuality: FilterQuality.medium,
                            ),
                          )
                        : AutoSizeText(
                            _webblenBaseViewModel.cityName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                  ).showCursorOnHover,
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: navBarItems!,
              ),
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
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _webblenBaseViewModel.navigateToHomeWithIndex(0),
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
                    onTap: () => _webblenBaseViewModel.navigateToHomeWithIndex(0),
                    child: _webblenBaseViewModel.cityName.isEmpty
                        ? Container()
                        : Container(
                            constraints: BoxConstraints(
                              maxWidth: 250,
                            ),
                            child: AutoSizeText(
                              _webblenBaseViewModel.cityName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxFontSize: 20,
                              minFontSize: 14,
                              maxLines: 1,
                            ),
                          ),
                  ).showCursorOnHover,
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: navBarItems!,
              ),
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
