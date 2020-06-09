import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/services/stripe/stripe_payment.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class WalletSetupDirectDepositPage extends StatefulWidget {
  @override
  _WalletSetupDirectDepositPageState createState() => _WalletSetupDirectDepositPageState();
}

class _WalletSetupDirectDepositPageState extends State<WalletSetupDirectDepositPage> {
  bool isLoading = false;
  final bankingForm = GlobalKey<FormState>();
  String currentUID;
  String stripeUID;
  String accountHolderName;
  String accountHolderType = 'individual';
  String routingNumber;
  String accountNumber;
  List<String> accountHolderTypes = ['individual', 'company'];

  void validateAndSubmitForm() {
    CustomAlerts().showLoadingAlert(context, "Submitting Banking Info...");
    bankingForm.currentState.save();
    if (accountHolderName == null || accountHolderName.isEmpty) {
      Navigator.of(context).pop();
      CustomAlerts().showErrorAlert(context, "Form Error", "Please Enter a Name for the Account");
    } else if (routingNumber == null || routingNumber.length != 9) {
      Navigator.of(context).pop();
      CustomAlerts().showErrorAlert(context, "Form Error", "Please Enter a Valid Routing Number");
    } else if (accountNumber == null || accountNumber.isEmpty) {
      Navigator.of(context).pop();
      CustomAlerts().showErrorAlert(context, "Form Error", "Please Enter a Valid Account Number");
    } else {
      StripePaymentService()
          .submitBankingInfoToStripe(currentUID, stripeUID, accountHolderName, accountHolderType, routingNumber, accountNumber)
          .then((status) {
        print(status);
        if (status == "passed") {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          CustomAlerts().showErrorAlert(context, "Banking Info Error", "Please Verify Your Info and Try Again.");
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuthenticationService().getCurrentUserID().then((res) {
      currentUID = res;
      WebblenUserData().getStripeUID(currentUID).then((res) {
        stripeUID = res;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountHolderNameField = Container(
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
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onSaved: (val) => accountHolderName = val,
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

    final accountHolderTypeField = Container(
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
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          underline: Container(),
          isDense: true,
          isExpanded: true,
          value: accountHolderType,
          items: accountHolderTypes.map((val) {
            return DropdownMenuItem(
              child: CustomText(
                context: context,
                text: val,
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              value: val,
            );
          }).toList(),
          onChanged: (selectedValue) {
            setState(() {
              accountHolderType = selectedValue;
            });
          },
        ),
      ),
    );

    final routingNumberField = Container(
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
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onSaved: (val) => routingNumber = val,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(9),
        ],
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );

    final accountNumberField = Container(
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
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onSaved: (val) => accountNumber = val,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
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
                key: bankingForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomText(
                      context: context,
                      text: "Setup Direct Deposit",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      child: CustomText(
                        context: context,
                        text: "Add your bank details to receive your earnings directly into your bank account.",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: CustomText(
                        context: context,
                        text:
                            "To keep your earnings secure, payments from Webblen will be placed on hold for 24 hours. Once your bank account has been verified, any earnings from Webblen during this time will be paid out to your account on the following Monday. This is to ensure your earnings go to your bank account.",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 8.0,
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "NAME ON BANK ACCOUNT",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    accountHolderNameField,
                    Container(
                      margin: EdgeInsets.only(
                        top: 8.0,
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "ACCOUNT TYPE",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    accountHolderTypeField,
                    Container(
                      margin: EdgeInsets.only(
                        top: 8.0,
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "ROUTING NUMBER",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    routingNumberField,
                    Container(
                      margin: EdgeInsets.only(
                        top: 8.0,
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "ACCOUNT NUMBER",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    accountNumberField,
                    GestureDetector(
                      onTap: () => CustomAlerts().showCheckExampleDialog(context),
                      child: CustomText(
                        context: context,
                        text: "Where Do I Find These Numbers?",
                        textColor: Colors.blueAccent,
                        textAlign: TextAlign.left,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ).showCursorOnHover,
                    SizedBox(height: 32.0),
                    CustomColorButton(
                      text: "Submit",
                      textColor: Colors.white,
                      backgroundColor: CustomColors.webblenRed,
                      height: 45.0,
                      width: MediaQuery.of(context).size.width * 0.6,
                      onPressed: () => validateAndSubmitForm(),
                    ).showCursorOnHover,
                    Container(
                      margin: EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "Please confirm your bank details before submission. \nIncorrect details may lead to delayed payments.",
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
