import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/constants/strings.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/text_field_container.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class AccountLoginPage extends StatefulWidget {
  @override
  _AccountLoginPageState createState() => _AccountLoginPageState();
}

class _AccountLoginPageState extends State<AccountLoginPage> {
  GlobalKey formKey = GlobalKey<FormState>();
  static final FacebookLogin facebookSignIn = FacebookLogin();
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  bool isLoading = false;
  bool isLoggingInWithPhone = false;

  //Email Login
  String emailVal;
  String passwordVal;

  //Phone Login
  MaskedTextController phoneMaskController = MaskedTextController(mask: '+1 000-000-0000');
  String phoneNo;
  String smsCode;
  String verificationId;

  changePhoneEmailLoginStatus() {
    if (isLoggingInWithPhone) {
      isLoggingInWithPhone = false;
    } else {
      isLoggingInWithPhone = true;
    }
    setState(() {});
  }

  formIsValid() {
    FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  validateAndSubmitForm() async {
    if (formIsValid()) {
      setState(() {
        isLoading = true;
      });
      if (isLoggingInWithPhone) {
        verifyPhone();
      } else {
        signInWithEmail();
      }
    }
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      Alert(
        context: context,
        title: "Enter SMS Code",
        content: TextField(
          onChanged: (value) {
            this.smsCode = value;
          },
        ),
        buttons: [
          DialogButton(
            child: Text('Submit'),
            onPressed: () => signInWithPhone(),
          ),
        ],
      ).show();
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      CustomAlerts().showErrorAlert(context, "Verification Failed", "There was an issue verifying your phone number. Please try again.");
    };

    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: phoneNo,
            codeAutoRetrievalTimeout: autoRetrieve,
            codeSent: smsCodeSent,
            timeout: const Duration(seconds: 5),
            verificationCompleted: null,
            verificationFailed: veriFailed)
        .catchError((e) {
      print(e);
    });
  }

  signInWithPhone() {
    Navigator.pop(context);
    FirebaseAuthenticationService().signInWithPhone(verificationId, smsCode).then((isSignedIn) {
      if (isSignedIn) {
        print('signed in');
      } else {
        print('not signed in');
      }
    });
  }

  signInWithEmail() async {
    bool emailIsValid = Strings().isEmailValid(emailVal);
    if (emailIsValid) {
      FirebaseAuthenticationService().signInWithEmail(emailVal, passwordVal).then((error) {
        if (error == null) {
          setState(() {
            isLoading = false;
          });
          locator<NavigationService>().navigateTo(HomeRoute);
        } else {
          showErrorAlert("There was an issue", error);
        }
      });
    } else {
      showErrorAlert("Email is Invalid", "Please Give a Valid Email");
    }
  }

  void loginWithFacebook() async {
    setState(() {
      isLoading = true;
    });
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
        FirebaseAuth.instance.signInWithCredential(credential).then((user) {
          if (user != null) {
            setState(() {
              isLoading = false;
            });
            locator<NavigationService>().navigateTo(HomeRoute);
          } else {
            setState(() {
              isLoading = false;
            });
            showErrorAlert("Oops!", 'There was an issue signing in with Facebook. Please Try Again.');
          }
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        showErrorAlert("Login Cancelled", 'Cancelled Facebook Login');
        setState(() {
          isLoading = false;
        });
        break;
      case FacebookLoginStatus.error:
        showErrorAlert("Oops!", 'There was an issue signing in with Facebook. Please Try Again.');
        setState(() {
          isLoading = false;
        });
        break;
    }
  }

  void loginWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount == null) {
      showErrorAlert("Login Cancelled", 'Cancelled Google Login');
      setState(() {
        isLoading = false;
      });
      return;
    }
    GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      if (user != null) {
        locator<NavigationService>().navigateTo(HomeRoute);
      } else {
        showErrorAlert("Oops!", 'There was an issue signing in with Google. Please Try Again.');
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  showErrorAlert(String title, String desc) {
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
    CustomAlerts().showErrorAlert(context, title, desc);
  }

  //Login Form
  Widget buildLoginForm(SizingInformation screenSize) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomText(
              context: context,
              text: "Login",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 40.0,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 16.0),
            TextFieldContainer(
              width: screenSize.isMobile ? 400 : 500,
              child: TextFormField(
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => emailVal = value,
                onFieldSubmitted: (val) => validateAndSubmitForm(),
                decoration: InputDecoration(
                  hintText: "Email",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TextFieldContainer(
              width: screenSize.isMobile ? 400 : 500,
              child: TextFormField(
                obscureText: true,
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => passwordVal = value,
                onFieldSubmitted: (val) => validateAndSubmitForm(),
                decoration: InputDecoration(
                  hintText: "Password",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            CustomColorButton(
              onPressed: () => validateAndSubmitForm(),
              text: "Login",
              textColor: Colors.black,
              backgroundColor: Colors.white,
              textSize: 18.0,
              height: 40.0,
              width: 200.0,
            ).showCursorOnHover,
            SizedBox(height: 8.0),
            Container(
              height: 1,
              width: 300,
              color: Colors.black38,
            ).showCursorOnHover,
            SizedBox(height: 8.0),
            SignInButton(
              Buttons.Facebook,
              onPressed: () => loginWithFacebook(),
            ).showCursorOnHover,
            SignInButton(
              Buttons.Google,
              onPressed: () => loginWithGoogle(),
            ).showCursorOnHover,
            SizedBox(height: 16.0),
            Container(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomText(
                    context: context,
                    text: "Don't Have an Account? ",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  GestureDetector(
                    onTap: () => locator<NavigationService>().navigateTo(AccountRegistrationRoute),
                    child: CustomText(
                      context: context,
                      text: "Sign Up",
                      textColor: CustomColors.webblenRed,
                      textAlign: TextAlign.left,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ).showCursorOnHover,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
//    print(user.uid);
//    print(user.isAnonymous);
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              //user == null || user.isAnonymous ? isLoading ? Container() : notLoggedInNotice() : Container(),
              isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
              buildLoginForm(screenSize),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
