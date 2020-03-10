import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
      builder: (builderContext, sizingInfo) => Scaffold(
        key: scaffoldKey,
        drawer: sizingInfo.deviceScreenType == DeviceScreenType.Mobile
            ? NavDrawer(
                isSignedIn: false,
                navigateToAccountLoginPage: () => locator<NavigationService>().navigateTo(AccountLoginRoute),
                navigateToEventsPage: () => locator<NavigationService>().navigateTo(EventsRoute),
                navigateToWalletPage: null,
                navigateToAccountPage: null,
              )
            : null,
        backgroundColor: Colors.transparent,
        body: user == null || user.isAnonymous
            ? Container(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    NavigationBar(
                      isSignedIn: false,
                      openNavDrawer: () => scaffoldKey.currentState.openDrawer(),
                      navigateToAccountLoginPage: () => locator<NavigationService>().navigateTo(AccountLoginRoute),
                      navigateToHomePage: () => locator<NavigationService>().navigateTo(HomeRoute),
                      navigateToEventsPage: () => locator<NavigationService>().navigateTo(EventsRoute),
                      navigateToWalletPage: null,
                      navigateToAccountPage: null,
                    ),
                    // HomePage(),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: sizingInfo.deviceScreenType == DeviceScreenType.Desktop
                            ? MediaQuery.of(context).size.height
                            : sizingInfo.deviceScreenType == DeviceScreenType.Tablet
                                ? MediaQuery.of(context).size.height + 200
                                : MediaQuery.of(context).size.height,
                      ),
                      child: widget.child,
                    ),
                    Footer(),
                  ],
                ),
              )
            : MultiProvider(
                providers: [],
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      NavigationBar(
                        isSignedIn: true,
                        navigateToAccountLoginPage: null,
                        navigateToHomePage: () => locator<NavigationService>().navigateTo(HomeRoute),
                        navigateToEventsPage: () => locator<NavigationService>().navigateTo(EventsRoute),
                        navigateToWalletPage: null,
                        navigateToAccountPage: null,
                      ),
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
                ),
              ),
      ),
    );
  }
}
