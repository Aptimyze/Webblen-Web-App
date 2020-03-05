import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'nav_drawer_header.dart';
import 'nav_drawer_item.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 300,
      child: Column(
        children: <Widget>[
          NavDrawerHeader(),
          NavDrawerItem(
            onTap: null,
            title: "Events",
            iconData: FontAwesomeIcons.calendar,
          ),
        ],
      ),
    );
  }
}
