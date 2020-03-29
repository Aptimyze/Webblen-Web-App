import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  final Widget child;
  final bool addVerticalPadding;
  CenteredView({this.child, this.addVerticalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
      ),
      //alignment: Alignment.topCenter,
      constraints: BoxConstraints(maxWidth: 1200),
      child: child,
    );
  }
}
