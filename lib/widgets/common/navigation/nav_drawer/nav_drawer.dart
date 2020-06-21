import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';

import 'nav_drawer_item.dart';

class NavDrawer extends StatelessWidget {
  final String authStatus;
  final VoidCallback navigateToAccountLoginPage;
  final VoidCallback navigateToEventsPage;
  final VoidCallback navigateToWalletPage;
  final VoidCallback navigateToAccountPage;
  NavDrawer({this.authStatus, this.navigateToAccountPage, this.navigateToWalletPage, this.navigateToEventsPage, this.navigateToAccountLoginPage});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 300,
      child: Column(
        children: <Widget>[
          SizedBox(height: 32.0),
          NavDrawerItem(
            onTap: navigateToEventsPage,
            title: "Events",
            iconData: FontAwesomeIcons.calendar,
          ).showCursorOnHover,
          authStatus == "loggedIn"
              ? NavDrawerItem(
                  onTap: navigateToWalletPage,
                  title: "Wallet",
                  iconData: FontAwesomeIcons.wallet,
                ).showCursorOnHover
              : Container(),
          authStatus == "loggedIn"
              ? NavDrawerItem(
                  onTap: navigateToAccountPage,
                  title: "My Account",
                  iconData: FontAwesomeIcons.user,
                ).showCursorOnHover
              : Container(),
          authStatus != "loggedIn"
              ? NavDrawerItem(
                  onTap: navigateToAccountLoginPage,
                  title: "Login",
                  iconData: FontAwesomeIcons.signInAlt,
                ).showCursorOnHover
              : Container(),
        ],
      ),
    );
  }
}
