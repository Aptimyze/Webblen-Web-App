import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  final double height;
  final Widget child;
  CenteredView({this.height, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      alignment: Alignment.topCenter,
      constraints: BoxConstraints(maxWidth: 1200),
      child: child,
    );
  }
}
