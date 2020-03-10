import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/forms/login_form.dart';
import 'package:webblen_web_app/widgets/layout/centered_view.dart';

class AccountLoginPage extends StatefulWidget {
  @override
  _AccountLoginPageState createState() => _AccountLoginPageState();
}

class _AccountLoginPageState extends State<AccountLoginPage> {
  GlobalKey formKey = GlobalKey<FormState>();

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
        LoginForm(
          formKey: null,
          navigateToRegistrationPage: () => locator<NavigationService>().navigateTo(AccountRegistrationRoute),
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
        LoginForm(
          formKey: null,
          navigateToRegistrationPage: () => locator<NavigationService>().navigateTo(AccountRegistrationRoute),
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
      children: <Widget>[
        LoginForm(
          formKey: null,
          navigateToRegistrationPage: () => locator<NavigationService>().navigateTo(AccountRegistrationRoute),
        ),
      ],
    );
  }
}
