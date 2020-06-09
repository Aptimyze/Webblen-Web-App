import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class WalletEarningsGuidePage extends StatefulWidget {
  @override
  _WalletEarningsGuidePageState createState() => _WalletEarningsGuidePageState();
}

class _WalletEarningsGuidePageState extends State<WalletEarningsGuidePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                    context: context,
                    text: "How Do Earnings Work?",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 16.0),
                  CustomText(
                    context: context,
                    text: "Account Balance",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  CustomText(
                    context: context,
                    text: "Your account balance is the amount of money you have available to transfer to your bank account this week. \nThis amount varies if:",
                    textColor: Colors.black87,
                    textAlign: TextAlign.left,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  CustomText(
                    context: context,
                    text: "- You have collected cash from customers.",
                    textColor: Colors.black87,
                    textAlign: TextAlign.left,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                  CustomText(
                    context: context,
                    text: "- You have initiated an instant deposit this week.",
                    textColor: Colors.black87,
                    textAlign: TextAlign.left,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  CustomText(
                    context: context,
                    text: "Payout Schedule",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  CustomText(
                    context: context,
                    text:
                        "You get paid on a weekly basis for tickets you distribute on the mobile app, Webblen. Payouts are completed betweet Monday - Sunday of the previous week (ending Sunday at midnight CST). Payments are transferred at that time directly to your bank account through Direct Deposit, and usually take 2-3 days to show up in your bank account. Payments should appear in your bank account by Wednesday night.",
                    textColor: Colors.black87,
                    textAlign: TextAlign.left,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CustomText(
                    context: context,
                    text: "Instant Deposits",
                    textColor: Colors.black87,
                    textAlign: TextAlign.left,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  CustomText(
                    context: context,
                    text:
                        "You have the ability to cashout your earnings daily for a fee of up to 1.5% the total deposit. This allows you to receive your earnings from ticket sales on demand from Webblen rather than waiting a week via direct deposit.",
                    textColor: Colors.black87,
                    textAlign: TextAlign.left,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  CustomText(
                    context: context,
                    text: "You must have a valid debit card - not a prepaid card - to use Webblen's instant deposit service.",
                    textColor: Colors.black87,
                    textAlign: TextAlign.left,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}
