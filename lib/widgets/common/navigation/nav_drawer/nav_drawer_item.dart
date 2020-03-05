import 'package:flutter/material.dart';

class NavDrawerItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  NavDrawerItem({this.title, this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, top: 60.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Icon(iconData),
            SizedBox(width: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
