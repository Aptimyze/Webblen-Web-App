import 'package:flutter/material.dart';
import 'package:webblen_web_app/widgets/common/images/round_pic.dart';

class NavDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
