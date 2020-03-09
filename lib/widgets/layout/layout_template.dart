import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/navigation/nav_drawer/nav_drawer.dart';
import 'package:webblen_web_app/widgets/common/navigation/navigation_bar.dart';

class LayoutTemplate extends StatefulWidget {
  final Widget child;
  LayoutTemplate({this.child});
  @override
  _LayoutTemplateState createState() => _LayoutTemplateState();
}

class _LayoutTemplateState extends State<LayoutTemplate> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
//    print(user.uid);
//    print(user.isAnonymous);
    return ResponsiveBuilder(
      builder: (context, sizingInfo) => Scaffold(
          drawer: sizingInfo.deviceScreenType == DeviceScreenType.Mobile ? NavDrawer() : null,
          backgroundColor: Colors.transparent,
          body: user == null || user.isAnonymous
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      NavigationBar(),
                      // HomePage(),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                        ),
                        child: widget.child,
                      ),
                      Footer(),
                    ],
                  ),
                )
              : user),
    );
  }
}
