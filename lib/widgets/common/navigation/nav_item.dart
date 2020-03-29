import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color color;

  NavItem({this.onTap, this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 14.0),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}
