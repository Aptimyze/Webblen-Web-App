import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/constants/strings.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/firebase/data/platform.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/stripe/stripe_payment.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/text_field_container.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class PurchaseTicketsPage extends StatefulWidget {
  final String eventID;
  final String ticketsToPurchase;
  PurchaseTicketsPage({this.eventID, this.ticketsToPurchase});
  @override
  _PurchaseTicketsPageState createState() => _PurchaseTicketsPageState();
}

class _PurchaseTicketsPageState extends State<PurchaseTicketsPage> {
  static final FacebookLogin facebookSignIn = FacebookLogin();
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  bool isLoading = false;
  bool hasAccount = false;
  bool isLoggedIn = false;
  bool acceptedTermsAndConditions = false;
  List ticketsToPurchase;
  GlobalKey authFormKey = GlobalKey<FormState>();
  GlobalKey ticketPaymentFormKey = GlobalKey<FormState>();
  GlobalKey discountCodeFormKey = GlobalKey<FormState>();

  //Event Info
  WebblenEvent event;
  WebblenUser eventHost;
  TicketDistro ticketDistro;

  //payments
  int numOfTicketsToPurchase = 0;
  double ticketRate;
  double taxRate;
  double ticketCharge = 0.00;
  double ticketFeeCharge = 0.00;
  double customFeeCharge = 0.00;
  double taxCharge = 0.00;
  double chargeAmount = 0.0;
  double discountAmount = 0.0;
  String discountCodeDescription;
  List<String> appliedDiscountCodes = [];
  String discountCodeStatus;
  String discountCode;
  List<String> ticketEmails = [];

  //Customer Info
  String firstName;
  String lastName;
  String emailAddress;
  String areaCode;

  //Card Info
  String cardType;
  String paymentFormError;
  var cardNumberMask = MaskedTextController(mask: '0000 0000 0000 0000');
  var expiryDateMask = MaskedTextController(mask: 'XX/XX');
  bool cvcFocused = false;
  String stripeUID;
  String cardNumber = "";
  String expiryDate = "MM/YY";
  int expMonth;
  int expYear;
  String cardHolderName = "";
  String cvcNumber = "";

  //Auth Info
  String authEmail;
  String authPass;
  String authConfirmPass;
  String authUsername;
  String authFormError;

  calculateChargeTotals() {
    //Custom Fees
//    customFeeCharge = 0.00;
//    ticketDistro.fees.forEach((fee) {
//      customFeeCharge += (numOfTicketsToPurchased * fee['feeAmount']);
//    });
    ticketsToPurchase.forEach((ticket) {
      double ticketPrice = double.parse(ticket['ticketPrice'].toString().substring(1));
      double charge = ticketPrice * ticket['qty'];
      numOfTicketsToPurchase += ticket['qty'];
      ticketCharge += charge;
    });
    ticketFeeCharge = numOfTicketsToPurchase * ticketRate;
    taxCharge = (ticketCharge + ticketFeeCharge) * taxRate;
    chargeAmount = ticketCharge + ticketFeeCharge + taxCharge + customFeeCharge;
    setState(() {});
  }

  applyDiscountCode() async {
    FormState discountForm = discountCodeFormKey.currentState;
    discountForm.save();
    int discountCodeIndex = ticketDistro.discountCodes.indexWhere((code) => code['discountCodeName'] == discountCode);
    if (appliedDiscountCodes.contains(discountCode)) {
      discountCodeStatus = 'duplicate';
    } else if (appliedDiscountCodes.isNotEmpty) {
      discountCodeStatus = 'multiple';
    } else {
      if (discountCodeIndex >= 0) {
        Map<String, dynamic> code = ticketDistro.discountCodes[discountCodeIndex];
        double discountPercent = code['discountCodePercentage'];
        discountAmount = chargeAmount * discountPercent;
        discountCodeDescription = "${(discountPercent * 100).toInt().toString()}% Off";
        chargeAmount = chargeAmount - discountAmount;
        appliedDiscountCodes.add(discountCode);
        discountCodeStatus = 'passed';
      } else {
        discountCodeStatus = 'failed';
      }
    }
    setState(() {});
    CustomAlerts().showLoadingAlert(context, 'Applying Code...');
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    //showTicketPurchaseInfoDialog();
//    Navigator.of(context).pop();
//    showPurchaseDialog();
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
              isLoggedIn = true;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            CustomAlerts().showErrorAlert(context, "Oops!", 'There was an issue signing in with Facebook. Please Try Again.');
          }
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        CustomAlerts().showErrorAlert(context, "Login Cancelled", 'Cancelled Facebook Login');
        setState(() {
          isLoading = false;
        });
        break;
      case FacebookLoginStatus.error:
        CustomAlerts().showErrorAlert(context, "Oops!", 'There was an issue signing in with Facebook. Please Try Again.');
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
      CustomAlerts().showErrorAlert(context, "Login Cancelled", 'Cancelled Google Login');
      setState(() {
        isLoading = false;
      });
      return;
    }
    GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      if (user != null) {
        setState(() {
          isLoggedIn = true;
          isLoading = false;
        });
      } else {
        CustomAlerts().showErrorAlert(context, "Oops!", 'There was an issue signing in with Google. Please Try Again.');
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Widget ticketChargeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ticketsToPurchase.length,
      itemBuilder: (BuildContext context, int index) {
        double ticketPrice = double.parse(ticketsToPurchase[index]['ticketPrice'].toString().substring(1));
        double ticketCharge = ticketPrice * ticketsToPurchase[index]['qty'];
        return ticketsToPurchase[index]['qty'] > 0
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                height: 40.0,
                //width: MediaQuery.of(context).size.width * 0.60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      //width: MediaQuery.of(context).size.width * 0.60,
                      child: CustomText(
                        context: context,
                        text: "${ticketsToPurchase[index]["ticketName"]} (${ticketsToPurchase[index]["qty"]})",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      //width: 95,
                      child: CustomText(
                        context: context,
                        text: "+ \$${ticketCharge.toStringAsFixed(2)}",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }

  Widget additionalFeesAndSalesTax() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 40.0,
      //width: MediaQuery.of(context).size.width * 0.60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //width: MediaQuery.of(context).size.width * 0.60,
            child: CustomText(
              context: context,
              text: "Additional Fees & Sales Tax",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            //width: 95,
            child: CustomText(
              context: context,
              text: "+ \$${(ticketFeeCharge + taxCharge).toStringAsFixed(2)}",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget discountsInfo() {
    return discountAmount == 0.0
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            height: 40.0,
            //width: MediaQuery.of(context).size.width * 0.60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  //width: MediaQuery.of(context).size.width * 0.60,
                  child: CustomText(
                    context: context,
                    text: "Discount ($discountCodeDescription)",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  //width: 95,
                  child: CustomText(
                    context: context,
                    text: "- \$${discountAmount.toStringAsFixed(2)}",
                    textColor: Colors.red,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
  }

  Widget discountCodeAlert() {
    return discountCode == null
        ? Container()
        : discountCodeStatus == 'duplicate'
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: CustomText(
                  context: context,
                  text: "This Code Has Already Been Used",
                  textColor: Colors.red,
                  textAlign: TextAlign.left,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            : discountCodeStatus == 'passed'
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    child: CustomText(
                      context: context,
                      text: "Discount Applied Successfully",
                      textColor: Colors.green,
                      textAlign: TextAlign.left,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : discountCodeStatus == 'multiple'
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: CustomText(
                          context: context,
                          text: "Only One Code Can Be Used at a Time",
                          textColor: Colors.red,
                          textAlign: TextAlign.left,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: CustomText(
                          context: context,
                          text: "Invalid Code",
                          textColor: Colors.red,
                          textAlign: TextAlign.left,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      );
  }

  Widget discountCodeRow() {
    return Container(
      child: Form(
        key: discountCodeFormKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFieldContainer(
              height: 35,
              width: 200.0, //screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
              child: TextFormField(
                cursorColor: Colors.black,
                onSaved: (value) => discountCode = value.trim(),
                decoration: InputDecoration(
                  hintText: "Enter Discount Code",
                  border: InputBorder.none,
                ),
              ),
            ),
            DialogButton(
              height: 35,
              width: 100.0,
              onPressed: () => applyDiscountCode(),
              color: CustomColors.darkGray,
              child: CustomText(
                context: context,
                text: "Apply",
                textColor: Colors.white,
                textAlign: TextAlign.left,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ).showCursorOnHover,
          ],
        ),
      ),
    );
  }

  Widget emailAddressField() {
    return Container(
      margin: EdgeInsets.only(
        top: 4.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: CustomColors.iosOffWhite,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
        decoration: InputDecoration(
          hintText: "Your Email Address",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          emailAddress = val;
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  Widget cardNumberField() {
    return TextFieldContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 250,
            child: TextFormField(
              controller: cardNumberMask,
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
              decoration: InputDecoration(
                hintText: "XXXX XXXX XXXX XXXX",
                contentPadding: EdgeInsets.only(
                  left: 8,
                  top: 8,
                  bottom: 8,
                ),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                cardNumber = val.replaceAll(" ", "");
                setState(() {});
              },
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Helvetica Neue",
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              inputFormatters: [
                LengthLimitingTextInputFormatter(19),
              ],
              textInputAction: TextInputAction.done,
              autocorrect: false,
            ),
          ),
          Container(
            width: 50,
            child: Icon(FontAwesomeIcons.creditCard, size: 18.0, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget expiryMonthField() {
    return TextFieldContainer(
      width: 100,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "01",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          expMonth = int.parse(val);
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  Widget expiryYearField() {
    return TextFieldContainer(
      width: 100,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "2024",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          expYear = int.parse(val);
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  Widget cardHolderNameField() {
    return Container(
      margin: EdgeInsets.only(
        top: 4.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: CustomColors.iosOffWhite,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Your Name",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          cvcFocused = false;
          cardHolderName = val;
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  Widget cvcField() {
    return TextFieldContainer(
      width: 100,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "XXX",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          cvcFocused = true;
          cvcNumber = val;
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  acceptTermsAndConditions(bool val) {
    if (val == null) {
      if (acceptedTermsAndConditions) {
        acceptedTermsAndConditions = false;
      } else {
        acceptedTermsAndConditions = true;
      }
    } else {
      acceptedTermsAndConditions = val;
    }
    setState(() {});
  }

  validateAndSubmitPayment() async {
    paymentFormError = null;
    FormState ticketForm = ticketPaymentFormKey.currentState;
    ticketForm.save();
    if (emailAddress == null || emailAddress.isEmpty) {
      paymentFormError = "Email Required";
    } else if (!Strings().isEmailValid(emailAddress)) {
      paymentFormError = "Email is Invalid";
    } else if (cardHolderName == null || cardHolderName.isEmpty) {
      paymentFormError = "Card Holder Name Required";
    } else if (cardNumber == null || cardNumber.isEmpty) {
      paymentFormError = "Card Number Required";
    } else if (expMonth == null || expMonth < 1 || expMonth > 12) {
      paymentFormError = "Invalid Expiry Month";
    } else if (expYear < DateTime.now().year) {
      paymentFormError = "Invalid Expiry Year";
    } else if (cvcNumber == null || cvcNumber.isEmpty) {
      paymentFormError = "CVC Number Required";
    } else if (!acceptedTermsAndConditions) {
      paymentFormError = "Please Accept the Terms and Conditions";
    }
    setState(() {});
    if (paymentFormError == null) {
      CustomAlerts().showLoadingAlert(context, 'Processing...');
      if (isLoggedIn) {
        submitPayment();
        await Future.delayed(Duration(seconds: 2));
      } else {
        await Future.delayed(Duration(seconds: 2));
        signInUser().then((error) {
          print(error);
          if (error == null) {
            submitPayment();
          } else {
            Navigator.of(context).pop();
            CustomAlerts().showErrorAlert(context, "Account Login Error", authFormError);
          }
        });
      }
    } else {
      CustomAlerts().showErrorAlert(context, "Form Error", paymentFormError);
    }
  }

  Future<String> signInUser() async {
    authFormError = null;
    FormState authForm = authFormKey.currentState;
    authForm.save();
    if (authEmail == null || authEmail.isEmpty) {
      authFormError = "Email Required";
    } else if (!Strings().isEmailValid(authEmail)) {
      authFormError = "Email is Invalid";
    } else if (!hasAccount) {
      if (authUsername == null || authUsername.isEmpty) {
        authFormError = "Username Cannot Be Empty";
      } else if (authPass == null || authPass.length < 8) {
        authFormError = "Password Must Be At Lease 8 Characters Long";
      } else if (authPass != authConfirmPass) {
        authFormError = "Passwords Do Not Match";
      }
    }
    if (authFormError == null) {
      if (hasAccount) {
        authFormError = await FirebaseAuthenticationService().signInWithEmail(authEmail, authPass);
      } else {
        bool usernameExists = await WebblenUserData().checkIfUsernameExists(authUsername);
        if (usernameExists) {
          authFormError = "Username Already Exists";
        } else {
          authFormError = await FirebaseAuthenticationService().createUserWithEmail(authEmail, authPass);
        }
      }
    }
    setState(() {});
    return authFormError;
  }

  submitPayment() async {
    String uid = await FirebaseAuthenticationService().getCurrentUserID();
    print(uid);
    StripePaymentService()
        .purchaseTickets(event.title, uid, event.authorID, "username", chargeAmount, ticketCharge, numOfTicketsToPurchase, cardNumber, expMonth, expYear,
            cvcNumber, cardHolderName, emailAddress)
        .then((res) {
      if (res == 'passed') {
        print('payment success...');
        StripePaymentService().completeTicketPurchase(uid, ticketsToPurchase, event).then((err) {
          Navigator.of(context).pop();
        });
      } else if (res == "Payment Method Error") {
        Navigator.of(context).pop();
        CustomAlerts().showErrorAlert(context, "Payment Method Error", "There was an issue with the details of your payment method.");
      } else if (res == "Transaction Error") {
        Navigator.of(context).pop();
        CustomAlerts().showErrorAlert(context, "Paymentf Error", "There was an issue charging your card. Please try a different one.");
      } else {
        Navigator.of(context).pop();
        CustomAlerts().showErrorAlert(context, "Unknown Error", "Please Contact Us via Email: team@webblen.com");
      }
    });
  }

  Widget accountLoginForm() {
    return Form(
      key: authFormKey,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 32.0),
            authFormError == null
                ? Container()
                : CustomText(
                    context: context,
                    text: authFormError,
                    textColor: Colors.red,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
            SizedBox(height: 8.0),
            CustomText(
              context: context,
              text: hasAccount ? "Account Login" : "New Account Login",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 16.0),
            TextFieldContainer(
              child: TextFormField(
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onChanged: (val) {
                  authEmail = val.trim();
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "Email",
                  border: InputBorder.none,
                ),
              ),
            ),
            hasAccount ? Container() : SizedBox(height: 8.0),
            hasAccount
                ? Container()
                : TextFieldContainer(
                    child: TextFormField(
                      cursorColor: Colors.black,
                      validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                      onChanged: (val) {
                        authUsername = val.toLowerCase().trim();
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Username",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
            SizedBox(height: 8.0),
            TextFieldContainer(
              child: TextFormField(
                obscureText: true,
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onChanged: (val) {
                  authPass = val;
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  border: InputBorder.none,
                ),
              ),
            ),
            hasAccount ? Container() : SizedBox(height: 8.0),
            hasAccount
                ? Container()
                : TextFieldContainer(
                    child: TextFormField(
                      obscureText: true,
                      cursorColor: Colors.black,
                      validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                      onChanged: (val) {
                        authConfirmPass = val;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
            SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (hasAccount) {
                      hasAccount = false;
                    } else {
                      hasAccount = true;
                    }
                    setState(() {});
                  },
                  child: CustomText(
                    context: context,
                    text: "Already Have an Account?",
                    textColor: Colors.blue,
                    textAlign: TextAlign.left,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    underline: true,
                  ),
                ).showCursorOnHover,
                SizedBox(width: 16.0),
                GestureDetector(
                  onTap: () => CustomAlerts().showInfoAlert(context, "Why Do I Need To Login to Purchase a Ticket?",
                      "Logging in Allows You To: \n -Save Your Ticket to Access Later \n -Earn Rewards For Attending this Event \n -Receive Important Info Regarding Changes, Rescheduling, or Cancellation of this Event"),
                  child: CustomText(
                    context: context,
                    text: "Why Do I Have to Login?",
                    textColor: Colors.blue,
                    textAlign: TextAlign.left,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    underline: true,
                  ),
                ).showCursorOnHover,
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomText(
                  context: context,
                  text: "Or",
                  textColor: Colors.black,
                  textAlign: TextAlign.left,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SignInButton(
                  Buttons.Facebook,
                  onPressed: () => loginWithFacebook(),
                ).showCursorOnHover,
                SizedBox(width: 16.0),
                SignInButton(
                  Buttons.Google,
                  onPressed: () => loginWithGoogle(),
                ).showCursorOnHover,
              ],
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget paymentForm() {
    return Form(
      key: ticketPaymentFormKey,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 32.0),
            paymentFormError == null
                ? Container()
                : CustomText(
                    context: context,
                    text: paymentFormError,
                    textColor: Colors.red,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
            SizedBox(height: 8.0),
            CustomText(
              context: context,
              text: "Payment Info",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 16.0),
            CustomText(
              context: context,
              text: "Email Address",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
            emailAddressField(),
            CustomText(
              context: context,
              text: "Card Holder Name",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
            cardHolderNameField(),
            CustomText(
              context: context,
              text: "Card Number",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
            cardNumberField(),
            SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      context: context,
                      text: "Expiry Month",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                    expiryMonthField(),
                  ],
                ),
                SizedBox(width: 32.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      context: context,
                      text: "Expiry Year",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                    expiryYearField(),
                  ],
                ),
                SizedBox(width: 32.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      context: context,
                      text: "CVC",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                    cvcField(),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget purchaseInfo() {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.75,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8.0),
          CustomText(
            context: context,
            text: event.title,
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 32.0,
            fontWeight: FontWeight.w700,
          ),
          Row(
            children: <Widget>[
              CustomText(
                context: context,
                text: "Hosted By ",
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
              GestureDetector(
                onTap: null,
                child: CustomText(
                  context: context,
                  text: "@username",
                  textColor: CustomColors.webblenRed,
                  textAlign: TextAlign.left,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ).showCursorOnHover,
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.mapMarkerAlt,
                size: 14.0,
                color: Colors.black38,
              ),
              SizedBox(width: 4.0),
              CustomText(
                context: context,
                text: "${event.city}, ${event.province}",
                textColor: Colors.black38,
                textAlign: TextAlign.left,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          CustomText(
            context: context,
            text: "${event.startDate} | ${event.startTime}",
            textColor: Colors.black38,
            textAlign: TextAlign.left,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            height: 16.0,
          ),
          ticketChargeList(),
          additionalFeesAndSalesTax(),
          discountsInfo(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            height: 1.0,
            color: Colors.black38,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CustomText(
                  context: context,
                  text: "Total: ",
                  textColor: Colors.black,
                  textAlign: TextAlign.left,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(
                  context: context,
                  text: "\$${chargeAmount.toStringAsFixed(2)}",
                  textColor: Colors.black,
                  textAlign: TextAlign.left,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          discountCodeAlert(),
          CustomText(
            context: context,
            text: "Discount Code: ",
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 8.0),
          discountCodeRow(),
          paymentForm(),
          isLoggedIn ? Container() : accountLoginForm(),
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (val) => acceptTermsAndConditions(val),
                value: acceptedTermsAndConditions,
              ).showCursorOnHover,
              GestureDetector(
                onTap: () => acceptTermsAndConditions(null),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By purchasing, I understand & agree to the ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Terms and Conditions ',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(
                        text: 'and that my information will be used as described on this page and in the ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Privacy Policy. ',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ).showCursorOnHover,
            ],
          ),
          SizedBox(height: 8.0),
          CustomColorButton(
            text: "Purchase Tickets",
            textColor: Colors.white,
            backgroundColor: CustomColors.darkMountainGreen,
            height: 35.0,
            width: 150,
            onPressed: () => validateAndSubmitPayment(),
          ).showCursorOnHover
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ticketsToPurchase = json.decode(widget.ticketsToPurchase);
    print(ticketsToPurchase);
    FirebaseAuthenticationService().userIsSignedIn().then((res) {
      isLoggedIn = res;
      EventDataService().getEvent(widget.eventID).then((res) {
        event = res;
        EventDataService().getEventTicketDistro(widget.eventID).then((res) {
          ticketDistro = res;
          PlatformDataService().getEventTicketFee().then((res) {
            ticketRate = res;
            PlatformDataService().getTaxRate().then((res) {
              taxRate = res;
              calculateChargeTotals();
              isLoading = false;
              setState(() {});
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    FirebaseUser user = Provider.of<FirebaseUser>(context);
//    print(user.uid);
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
              SizedBox(height: 32.0),
              Container(
                width: 600,
                child: Column(
                  children: <Widget>[
                    purchaseInfo(),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
              isLoading ? Container() : Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
