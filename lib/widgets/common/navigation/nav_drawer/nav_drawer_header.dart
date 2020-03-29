import 'package:flutter/material.dart';
import 'package:webblen_web_app/widgets/common/images/round_pic.dart';

class NavDrawerHeader extends StatelessWidget {
  final String authStatus;
  final VoidCallback navigateToAccountPage;
  final VoidCallback navigateToAccountLoginPage;
  NavDrawerHeader({this.authStatus, this.navigateToAccountPage, this.navigateToAccountLoginPage});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 150,
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RoundPic(
            picURL: null,
            isUserPic: true,
            size: 50.0,
          ),
          Text(
            "@anon",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
