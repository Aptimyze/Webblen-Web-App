import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/navigation/nav_drawer/nav_drawer.dart';
import 'package:webblen_web_app/widgets/common/navigation/navigation_bar.dart';

import 'desktop/desktop_home_body.dart';
import 'mobile/mobile_home_body.dart';
import 'tablet/tablet_home_body.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fb.auth().currentUser == null ? fb.auth().signInAnonymously() : null;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) => Scaffold(
        drawer: sizingInfo.deviceScreenType == DeviceScreenType.Mobile ? NavDrawer() : null,
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                NavigationBar(),
                ScreenTypeLayout(
                  desktop: DesktopHomeBody(),
                  tablet: TabletHomeBody(),
                  mobile: MobileHomeBody(),
                ),
                Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
