import 'package:flutter/material.dart';
import 'package:webblen_web_app/widgets/home/home_search_bar.dart';

class SmallBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Hello!",
          style: TextStyle(
            fontSize: 40,
            color: Color(0xFF8591B0),
            fontWeight: FontWeight.bold,
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'WellCome To ',
            style: TextStyle(fontSize: 40, color: Color(0xFF8591B0)),
            children: <TextSpan>[
              TextSpan(text: 'Britu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.black87)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 20),
          child: Text("LET’S EXPLORE THE WORLD"),
        ),
        SizedBox(
          height: 30,
        ),
        Center(
          child: Image.asset(
            "assets/images/directions.png",
            fit: BoxFit.cover,
            scale: 1,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        HomeSearchBar(),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
