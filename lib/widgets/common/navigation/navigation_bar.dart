import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';

import 'nav_bar_logo.dart';
import 'nav_item.dart';

class NavigationBar extends StatelessWidget {
  final String authStatus;
  final VoidCallback openNavDrawer;
  final VoidCallback navigateToAccountLoginPage;
  final VoidCallback navigateToHomePage;
  final VoidCallback navigateToEventsPage;
  final VoidCallback navigateToWalletPage;
  final VoidCallback navigateToAccountPage;

  NavigationBar({
    this.authStatus,
    this.openNavDrawer,
    this.navigateToAccountLoginPage,
    this.navigateToHomePage,
    this.navigateToAccountPage,
    this.navigateToEventsPage,
    this.navigateToWalletPage,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: NavigationBarTabletDesktop(
        authStatus: authStatus,
        navigateToAccountLoginPage: navigateToAccountLoginPage,
        navigateToHomePage: navigateToHomePage,
        navigateToAccountPage: navigateToAccountPage,
        navigateToEventsPage: navigateToEventsPage,
        navigateToWalletPage: navigateToWalletPage,
      ),
      tablet: NavigationBarTabletDesktop(
        authStatus: authStatus,
        navigateToAccountLoginPage: navigateToAccountLoginPage,
        navigateToHomePage: navigateToHomePage,
        navigateToAccountPage: navigateToAccountPage,
        navigateToEventsPage: navigateToEventsPage,
        navigateToWalletPage: navigateToWalletPage,
      ),
      mobile: NavigationBarMobile(
        authStatus: authStatus,
        openNavDrawer: openNavDrawer,
        navigateToAccountLoginPage: navigateToAccountLoginPage,
        navigateToHomePage: navigateToHomePage,
        navigateToAccountPage: navigateToAccountPage,
        navigateToEventsPage: navigateToEventsPage,
        navigateToWalletPage: navigateToWalletPage,
      ),
    );
  }
}

class NavigationBarTabletDesktop extends StatelessWidget {
  final String authStatus;
  final VoidCallback navigateToAccountLoginPage;
  final VoidCallback navigateToHomePage;
  final VoidCallback navigateToEventsPage;
  final VoidCallback navigateToWalletPage;
  final VoidCallback navigateToAccountPage;

  NavigationBarTabletDesktop({
    this.authStatus,
    this.navigateToAccountLoginPage,
    this.navigateToHomePage,
    this.navigateToAccountPage,
    this.navigateToEventsPage,
    this.navigateToWalletPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      //padding: EdgeInsets.symmetric(horizontal: 48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: navigateToHomePage,
                  child: NavBarLogo(),
                ).showCursorOnHover,
                authStatus == "unknown"
                    ? Row()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          NavItem(
                            onTap: navigateToEventsPage,
                            title: "Events",
                            color: Colors.black,
                          ).showCursorOnHover,
                          authStatus == "loggedIn"
                              ? NavItem(
                                  onTap: navigateToWalletPage,
                                  title: "Wallet",
                                  color: Colors.black,
                                ).showCursorOnHover
                              : Container(),
                          authStatus == "loggedIn"
                              ? NavItem(
                                  onTap: navigateToAccountPage,
                                  title: "My Account",
                                  color: Colors.black,
                                ).showCursorOnHover
                              : NavItem(
                                  onTap: navigateToAccountLoginPage,
                                  title: "Login",
                                  color: CustomColors.webblenRed,
                                ).showCursorOnHover,
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

class NavigationBarMobile extends StatelessWidget {
  final String authStatus;
  final VoidCallback openNavDrawer;
  final VoidCallback navigateToAccountLoginPage;
  final VoidCallback navigateToHomePage;
  final VoidCallback navigateToEventsPage;
  final VoidCallback navigateToWalletPage;
  final VoidCallback navigateToAccountPage;

  NavigationBarMobile({
    this.authStatus,
    this.openNavDrawer,
    this.navigateToAccountLoginPage,
    this.navigateToHomePage,
    this.navigateToAccountPage,
    this.navigateToEventsPage,
    this.navigateToWalletPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: openNavDrawer,
            icon: Icon(FontAwesomeIcons.bars, color: Colors.black, size: 24.0),
          ).showCursorOnHover,
          GestureDetector(
            onTap: navigateToHomePage,
            child: NavBarLogo(),
          ).showCursorOnHover,
        ],
      ),
    );
  }
}
