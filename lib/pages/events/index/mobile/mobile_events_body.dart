import 'package:flutter/material.dart';
import 'package:webblen_web_app/widgets/home/home_search_bar.dart';

class MobileEventsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Find Events.",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "Build Communities.",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "Get Paid.",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16.0, right: 16.0),
          child: HomeSearchBar(),
        ),
        Center(
          child: Image.asset(
            "assets/images/directions.png",
            fit: BoxFit.cover,
            scale: 1,
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
