import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/widgets/layout/centered_view.dart';

class AccountLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
//    print(user.uid);
//    print(user.isAnonymous);
    return CenteredView(
      child: ScreenTypeLayout(
        desktop: DesktopView(),
        tablet: TabletView(),
        mobile: MobileView(),
      ),
    );
  }
}

class DesktopView extends StatelessWidget {
  //DesktopView({});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[],
        ),
      ],
    );
  }
}

class TabletView extends StatelessWidget {
  //TabletView({});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[],
        ),
      ],
    );
  }
}

class MobileView extends StatelessWidget {
  //MobileView({});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[],
    );
  }
}
