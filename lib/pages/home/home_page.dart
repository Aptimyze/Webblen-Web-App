import 'package:flutter/material.dart';
import 'package:webblen_web_app/utils/responsive_layout.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/navigation/navigation_bar.dart';

import 'large_screen/body.dart';
import 'small_screen/body.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              NavigationBar(),
              ResponsiveLayout.isSmallScreen(context) ? SmallBody() : LargeBody(),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
