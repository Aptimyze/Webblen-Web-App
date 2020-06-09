import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/firebase/data/platform.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/services/stripe/stripe_payment.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class WalletSetupInstantDepositPage extends StatefulWidget {
  @override
  _WalletSetupInstantDepositPageState createState() => _WalletSetupInstantDepositPageState();
}

class _WalletSetupInstantDepositPageState extends State<WalletSetupInstantDepositPage> {
  bool isLoading = true;
  String stripePubKey;
  final cardForm = GlobalKey<FormState>();
  var cardNumberMask = MaskedTextController(mask: '0000 0000 0000 0000');
  var expiryDateMask = MaskedTextController(mask: 'XX/XX');
  bool cvcFocused = false;
  String stripeUID;
  String currentUID;
  String cardNumber = "";
  String expiryDate = "MM/YY";
  int expMonth = 1;
  int expYear = 2020;
  String cardHolderName = "";
  String cvcNumber = "";

  cvcFocus(bool focus) {
    if (focus) {
      cvcFocused = true;
    } else {
      cvcFocused = false;
    }
    setState(() {});
  }

  void validateAndSubmitForm() async {
    CustomAlerts().showLoadingAlert(context, "Submitting Card Info...");
    cardForm.currentState.save();
    cardNumber = cardNumber.replaceAll(" ", "");
    if (cardNumber == null || cardNumber.length != 16) {
      Navigator.of(context).pop();
      CustomAlerts().showErrorAlert(context, "Form Error", "Invalid Card Number");
    } else if (expMonth < 1 || expMonth > 12) {
      Navigator.of(context).pop();
      CustomAlerts().showErrorAlert(context, "Form Error", "Invalid Expiry Month");
    } else if (expYear < DateTime.now().year) {
      Navigator.of(context).pop();
      CustomAlerts().showErrorAlert(context, "Form Error", "Invalid Expiry Year");
    } else if (cardHolderName == null || cardHolderName.isEmpty) {
      Navigator.of(context).pop();
      CustomAlerts().showErrorAlert(context, "Form Error", "Name Cannot Be Empty");
    } else if (cvcNumber == null || cvcNumber.length != 3) {
      Navigator.of(context).pop();
      CustomAlerts().showErrorAlert(context, "Form Error", "Invalid CVC Code");
    } else {
      StripeCard card = StripeCard(number: cardNumber, expMonth: expMonth, expYear: expYear, cvc: cvcNumber, name: cardHolderName);
      StripeApi.instance.createPaymentMethodFromCard(card).then((res) {
        if (res['card']['funding'] == 'debit') {
          StripePaymentService().submitCardInfoToStripe(currentUID, stripeUID, cardNumber, expMonth, expYear, cvcNumber, cardHolderName).then((res) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else {
          Navigator.of(context).pop();
          CustomAlerts().showErrorAlert(context, "Card Error", "Please Use a Valid DEBIT Card");
        }
      }).catchError((e) {
        Navigator.of(context).pop();
        String error = e.toString();
        CustomAlerts().showErrorAlert(context, "Form Error", error);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuthenticationService().getCurrentUserID().then((res) {
      currentUID = res;
      WebblenUserData().getStripeUID(currentUID).then((res) {
        stripeUID = res;
        PlatformDataService().getStripePubKey().then((res) {
          stripePubKey = res;
          StripeApi.init(stripePubKey);
          isLoading = false;
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardNumberField = Container(
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
          cvcFocused = false;
          cardNumber = val;
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
    );

    final expiryMonthField = Container(
      width: MediaQuery.of(context).size.width * 0.5 - 48,
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
          hintText: "01",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          cvcFocused = false;
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

    final expiryYearField = Container(
      width: MediaQuery.of(context).size.width * 0.5 - 48,
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
          hintText: "2024",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          cvcFocused = false;
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

    final cardHolderNameField = Container(
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

    Widget cvcField = Container(
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

    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
            SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 32,
              ),
              child: Form(
                key: cardForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomText(
                      context: context,
                      text: "Setup Instant Deposit",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 16.0),
                    CustomText(
                      context: context,
                      text: "Add your debit card details to receive instant deposits into your bank account.",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "Card Number",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    cardNumberField,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 4.0,
                              ),
                              child: CustomText(
                                context: context,
                                text: "Expiry Month",
                                textColor: Colors.black,
                                textAlign: TextAlign.left,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            expiryMonthField,
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 4.0,
                              ),
                              child: CustomText(
                                context: context,
                                text: "Expiry Year",
                                textColor: Colors.black,
                                textAlign: TextAlign.left,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            expiryYearField,
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "Card Holder Name",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    cardHolderNameField,
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "CVC",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    cvcField,
                    SizedBox(height: 16.0),
                    CustomColorButton(
                      text: "Submit",
                      textColor: Colors.white,
                      backgroundColor: CustomColors.webblenRed,
                      height: 45.0,
                      width: MediaQuery.of(context).size.width * 0.6,
                      onPressed: () => validateAndSubmitForm(),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "Please confirm your card details before submission. \nIncorrect details may lead to delayed payments.",
                        textColor: Colors.black,
                        textAlign: TextAlign.center,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "All data is sent via 256-bit encrypted connection to keep your information secure.",
                        textColor: Colors.black,
                        textAlign: TextAlign.center,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.0),
            Footer(),
          ],
        ),
      ),
    );
  }
}
