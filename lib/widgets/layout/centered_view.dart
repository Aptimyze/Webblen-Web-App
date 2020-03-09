import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  final Widget child;
  CenteredView({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 16),
      alignment: Alignment.topCenter,
      constraints: BoxConstraints(maxWidth: 1200),
      child: child,
    );
  }
}
