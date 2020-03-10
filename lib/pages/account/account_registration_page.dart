import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/progress_indicator/progress_indicator.dart';
import 'package:webblen_web_app/widgets/forms/registration_form.dart';
import 'package:webblen_web_app/widgets/layout/centered_view.dart';

class AccountRegistrationPage extends StatefulWidget {
  @override
  _AccountRegistrationPageState createState() => _AccountRegistrationPageState();
}

class _AccountRegistrationPageState extends State<AccountRegistrationPage> {
  GlobalKey formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isRegisteringWithPhone = true;
  String phoneVal;
  String emailVal;
  String passwordVal;
  String passwordConfirmVal;

  changePhoneEmailRegistrationStatus() {
    print('changing auth method');
    if (isRegisteringWithPhone) {
      isRegisteringWithPhone = false;
    } else {
      isRegisteringWithPhone = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
//    print(user.uid);
//    print(user.isAnonymous);
    return CenteredView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: isLoading ? CustomLinearProgress(progressBarColor: Colors.red) : Container(),
          ),
          RegistrationForm(
            formKey: formKey,
            isRegisteringWithPhone: isRegisteringWithPhone,
            changePhoneEmailRegistrationStatus: () => changePhoneEmailRegistrationStatus(),
            navigateToLoginPage: () => locator<NavigationService>().navigateTo(AccountLoginRoute),
          ),
        ],
      ),
    );
  }
}
