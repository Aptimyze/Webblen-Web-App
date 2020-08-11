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

class AccountRegistrationPage extends StatefulWidget {
  final String referral;
  AccountRegistrationPage({this.referral});
  @override
  _AccountRegistrationPageState createState() => _AccountRegistrationPageState();
}

class _AccountRegistrationPageState extends State<AccountRegistrationPage> {
  static final FacebookLogin facebookSignIn = FacebookLogin();
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  GlobalKey formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isRegisteringWithPhone = false;
  bool showEmailConfirmationSent = false;

  //Email Registration
  String emailVal;
  String passwordVal;
  String passwordConfirmVal;

  //Phone Registration
  MaskedTextController phoneMaskController = MaskedTextController(mask: '+1 000-000-0000');
  String phoneNo;
  String smsCode;
  String verificationId;

  //Routing
  String referralRoute;

  changePhoneEmailRegistrationStatus() {
    if (isRegisteringWithPhone) {
      isRegisteringWithPhone = false;
    } else {
      isRegisteringWithPhone = true;
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
      if (isRegisteringWithPhone) {
        verifyPhone();
      } else {
        createAccountWithEmail();
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

  createAccountWithEmail() async {
    bool emailIsValid = Strings().isEmailValid(emailVal);
    if (emailIsValid) {
      if (passwordVal != null && passwordVal.length >= 8) {
        if (passwordVal == passwordConfirmVal) {
          FirebaseAuthenticationService().createUserWithEmail(emailVal, passwordVal).then((error) {
            if (error == null) {
              if (this.mounted) {
                showEmailConfirmationSent = true;
                if (referralRoute == "earningsSetup") {
                  locator<NavigationService>().navigateTo(AccountSetupRoute, queryParams: {'referral': "earningsSetup"});
                } else {
                  locator<NavigationService>().navigateTo(AccountRoute);
                }
              }
            } else {
              showErrorAlert("There was an issue", error);
            }
          });
        } else {
          showErrorAlert("Password Error", "Passwords Must Match");
        }
      } else {
        showErrorAlert("Password Error", "Passwords Must Be At Least 8 Characters Long");
      }
    } else {
      showErrorAlert("Email is Invalid", "Please Give a Valid Email");
    }
  }

  showSuccessAlert(String title, String desc) {
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
    CustomAlerts().showSuccessAlert(context, title, desc);
  }

  showErrorAlert(String title, String desc) {
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
    CustomAlerts().showErrorAlert(context, title, desc);
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
            if (referralRoute == "earningsSetup") {
              locator<NavigationService>().navigateTo(AccountSetupRoute, queryParams: {'referral': "earningsSetup"});
            } else {
              locator<NavigationService>().navigateTo(AccountRoute);
            }
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
        if (referralRoute == "earningsSetup") {
          locator<NavigationService>().navigateTo(AccountSetupRoute, queryParams: {'referral': "earningsSetup"});
        } else {
          locator<NavigationService>().navigateTo(AccountRoute);
        }
      } else {
        showErrorAlert("Oops!", 'There was an issue signing in with Google. Please Try Again.');
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Widget buildRegistrationForm(SizingInformation screenSize) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.referral == "event_host_referral"
                ? CustomText(
                    context: context,
                    text: "Ready to Start Selling Tickets?",
                    textColor: Colors.black,
                    textAlign: TextAlign.center,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  )
                : Container(),
            widget.referral == "event_host_referral"
                ? CustomText(
                    context: context,
                    text: "Register Below",
                    textColor: Colors.black,
                    textAlign: TextAlign.center,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w300,
                  )
                : CustomText(
                    context: context,
                    text: "Register",
                    textColor: Colors.black,
                    textAlign: TextAlign.center,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
            SizedBox(height: 16.0),
            showEmailConfirmationSent
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomText(
                      context: context,
                      text: "A Confirmation Email Has Been Sent to the address: $emailVal",
                      textColor: Colors.green,
                      textAlign: TextAlign.left,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : Container(),
            isRegisteringWithPhone
                ? TextFieldContainer(
                    width: screenSize.isMobile ? 400 : 500,
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: phoneMaskController,
                      validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                      onSaved: (value) => phoneNo = value,
                      onFieldSubmitted: (val) => validateAndSubmitForm(),
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        border: InputBorder.none,
                      ),
                    ),
                  )
                : TextFieldContainer(
                    width: screenSize.isMobile ? 400 : 500,
                    child: TextFormField(
                      cursorColor: Colors.black,
                      validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                      onSaved: (value) => emailVal = value,
                      onFieldSubmitted: (val) => validateAndSubmitForm(),
                      decoration: InputDecoration(
                        hintText: "Email Address",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
            SizedBox(height: 8.0),
            isRegisteringWithPhone
                ? Container()
                : TextFieldContainer(
                    width: screenSize.isMobile ? 400 : 500,
                    child: TextFormField(
                      cursorColor: Colors.black,
                      obscureText: true,
                      validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                      onSaved: (value) => passwordVal = value,
                      onFieldSubmitted: (val) => validateAndSubmitForm(),
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
            isRegisteringWithPhone ? Container() : SizedBox(height: 8.0),
            isRegisteringWithPhone
                ? Container()
                : TextFieldContainer(
                    width: screenSize.isMobile ? 400 : 500,
                    child: TextFormField(
                      cursorColor: Colors.black,
                      obscureText: true,
                      validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                      onSaved: (value) => passwordConfirmVal = value,
                      onFieldSubmitted: (val) => validateAndSubmitForm(),
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
            SizedBox(height: 8.0),
            CustomColorButton(
              onPressed: () => validateAndSubmitForm(),
              text: isRegisteringWithPhone ? "Send Registration Code" : "Register Email",
              textColor: Colors.black,
              backgroundColor: Colors.white,
              textSize: 18.0,
              height: 40.0,
              width: 300.0,
            ).showCursorOnHover,
            SizedBox(height: 16.0),
            Container(
              height: 1,
              width: 300,
              color: Colors.black38,
            ),
//            SizedBox(height: 16.0),
//            GestureDetector(
//              onTap: () => changePhoneEmailRegistrationStatus(),
//              child: CustomText(
//                context: context,
//                text: isRegisteringWithPhone ? "Register with Email" : "Register with Phone Number",
//                textColor: Colors.blueAccent,
//                textAlign: TextAlign.left,
//                fontSize: 18.0,
//                fontWeight: FontWeight.w500,
//              ),
//            ).showCursorOnHover,
            SizedBox(height: 12.0),
            SignInButton(
              Buttons.Facebook,
              onPressed: () => loginWithFacebook(),
            ).showCursorOnHover,
            //SizedBox(height: 8.0),
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
                    text: "Already Have an Account? ",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  GestureDetector(
                    onTap: () => locator<NavigationService>().navigateTo(AccountLoginRoute),
                    child: CustomText(
                      context: context,
                      text: "Login",
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
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.referral != null) {
      if (widget.referral == "event_host_referral") {
        referralRoute = 'earningsSetup';
      }
    }
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
              buildRegistrationForm(screenSize),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
