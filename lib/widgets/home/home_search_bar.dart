import 'package:flutter/material.dart';

import 'home_search_button.dart';

class HomeSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(left: 8.0, right: 8.0),
      height: 60,
      //width: 600,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 8), blurRadius: 8)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 270),
            child: TextField(
              onChanged: null,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                border: InputBorder.none,
                hintText: 'Search for an Event',
              ),
            ),
          ),
          HomeSearchButton(),
        ],
      ),
    );
  }
}
