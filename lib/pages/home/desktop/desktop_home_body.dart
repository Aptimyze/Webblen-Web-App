import 'package:flutter/material.dart';
import 'package:webblen_web_app/widgets/home/home_search_bar.dart';

class DesktopHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 600.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Find Events.",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Build Communities.",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Get Paid.",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
//                  Padding(
//                    padding: const EdgeInsets.only(left: 12.0, top: 20),
//                    child: Text("Download Webblen Today"),
//                  ),
                SizedBox(
                  height: 40,
                ),
                HomeSearchBar(),
              ],
            ),
          ),
          Expanded(
            child: Image.asset(
              "assets/images/directions.png",
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
//      child: Stack(
//        children: <Widget>[
//          FractionallySizedBox(
//            alignment: Alignment.centerRight,
//            widthFactor: .7,
//            heightFactor: 1,
//            child: Image.asset(
//              "assets/images/directions.png",
//              fit: BoxFit.cover,
//              scale: .85,
//            ),
//          ),
//          FractionallySizedBox(
//            alignment: Alignment.centerLeft,
//            widthFactor: .6,
//            heightFactor: .6,
//            child: Padding(
//              padding: EdgeInsets.only(left: 48),

//            ),
//          )
//        ],
//      ),
    );
  }
}
