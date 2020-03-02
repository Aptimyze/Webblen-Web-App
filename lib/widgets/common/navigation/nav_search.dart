import 'package:flutter/material.dart';

class NavSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 4.0,
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 246, 245, 245),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 12,
            ),
            child: Icon(
              Icons.search,
              color: Colors.black54,
              size: 18.0,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 9,
            ),
            child: Text(
              "Find Events",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
