import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/models/payment_info.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class WalletPayoutMethodsPage extends StatefulWidget {
  @override
  _WalletPayoutMethodsPageState createState() => _WalletPayoutMethodsPageState();
}

class _WalletPayoutMethodsPageState extends State<WalletPayoutMethodsPage> {
  bool isLoading = true;

  String currentUID;

  @override
  void initState() {
    super.initState();
    FirebaseAuthenticationService().getCurrentUserID().then((res) {
      currentUID = res;
      isLoading = false;
      setState(() {});
    });
  }

  Widget bankInfoBubble(BankingInfo bankingInfo) {
    String last4OfAccountNumber = "......." + bankingInfo.last4;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          CustomText(
            context: context,
            text: "Name on Account",
            textColor: Colors.black38,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            context: context,
            text: bankingInfo.accountHolderName == null ? "" : bankingInfo.accountHolderName,
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 16.0,
          ),
          CustomText(
            context: context,
            text: "Bank Account",
            textColor: Colors.black38,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            context: context,
            text: bankingInfo.bankName,
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          CustomText(
            context: context,
            text: last4OfAccountNumber,
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 16.0,
          ),
          CustomText(
            context: context,
            text: "Verification Status",
            textColor: Colors.black38,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            context: context,
            text: "Your Identity is Verified and You Are Receiving Payments",
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget debitCardInfoBubble(DebitCardInfo debitCardInfo) {
    String last4OfCardNumber = "**** **** **** " + debitCardInfo.last4;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          CustomText(
            context: context,
            text: "Card Type",
            textColor: Colors.black38,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            context: context,
            text: debitCardInfo.brand.toUpperCase(),
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 16.0,
          ),
          CustomText(
            context: context,
            text: "Card Details",
            textColor: Colors.black38,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            context: context,
            text: last4OfCardNumber,
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 4.0,
          ),
          CustomText(
            context: context,
            text: "Expiration Date: ${debitCardInfo.expMonth}/${debitCardInfo.expYear}",
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 16.0,
          ),
          CustomText(
            context: context,
            text: "Verification Status",
            textColor: Colors.black38,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            context: context,
            text: "Your Card is verified and eligible for Instant Deposit",
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget infoMissingBubble(String infoType) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0),
      child: CustomText(
        context: context,
        text: infoType == "bankInfo"
            ? "Direct deposit is not set up. Please fill out your banking information in order to receive direct deposits."
            : "Instant deposit is not set up. Please fill out your card information in order to receive instant deposits.",
        textColor: Colors.black,
        textAlign: TextAlign.left,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomText(
                context: context,
                text: "Payout Methods",
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            isLoading
                ? Container(height: MediaQuery.of(context).size.height)
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder(
                        stream: WebblenUserData().streamStripeAccount(currentUID),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) return Text("Loading...");
                          var userData = userSnapshot.data;

                          BankingInfo bankInfo = userData['bankInfo'] == null ? null : BankingInfo.fromMap(Map<String, dynamic>.from(userData['bankInfo']));
                          DebitCardInfo cardInfo = userData['cardInfo'] == null ? null : DebitCardInfo.fromMap(Map<String, dynamic>.from(userData['cardInfo']));
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(height: 32.0),
                              CustomText(
                                context: context,
                                text: "Direct Deposit",
                                textColor: Colors.black,
                                textAlign: TextAlign.left,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700,
                              ),
                              bankInfo == null ? infoMissingBubble("bankInfo") : bankInfoBubble(bankInfo),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: GestureDetector(
                                  onTap: () => locator<NavigationService>().navigateTo(WalletDirectDepositSetupRoute),
                                  child: CustomText(
                                    context: context,
                                    text: bankInfo == null ? "Set Up Direct Deposit" : "Update",
                                    textColor: Colors.blueAccent,
                                    textAlign: TextAlign.left,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).showCursorOnHover,
                              ),
                              SizedBox(height: 32.0),
                              CustomText(
                                context: context,
                                text: "Instant Deposit",
                                textColor: Colors.black,
                                textAlign: TextAlign.left,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700,
                              ),
                              cardInfo == null ? infoMissingBubble("cardInfo") : debitCardInfoBubble(cardInfo),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: GestureDetector(
                                  onTap: () => locator<NavigationService>().navigateTo(WalletInstantDepositSetupRoute),
                                  child: CustomText(
                                    context: context,
                                    text: cardInfo == null ? "Set Up Instant Deposit" : "Update",
                                    textColor: Colors.blueAccent,
                                    textAlign: TextAlign.left,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).showCursorOnHover,
                              ),
                            ],
                          );
                        }),
                  ),
            SizedBox(height: 32.0),
            Footer(),
          ],
        ),
      ),
    );
  }
}
