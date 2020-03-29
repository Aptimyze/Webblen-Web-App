import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'nav_drawer_header.dart';
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
          NavDrawerHeader(
            authStatus: authStatus,
            navigateToAccountPage: navigateToAccountPage,
            navigateToAccountLoginPage: navigateToAccountLoginPage,
          ),
          NavDrawerItem(
            onTap: navigateToEventsPage,
            title: "Events",
            iconData: FontAwesomeIcons.calendar,
          ),
          NavDrawerItem(
            onTap: navigateToAccountLoginPage,
            title: "Login",
            iconData: FontAwesomeIcons.signInAlt,
          ),
        ],
      ),
    );
  }
}
