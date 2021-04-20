import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/earnings/how_earnings_work/how_earnings_work_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';

class HowEarningsWorkView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HowEarningsWorkViewModel>.reactive(
      viewModelBuilder: () => HowEarningsWorkViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: CustomTopNavBar(
            navBarItems: [
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel!.navigateToHomeWithIndex(0),
                iconData: FontAwesomeIcons.home,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel!.navigateToHomeWithIndex(1),
                iconData: FontAwesomeIcons.search,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel!.navigateToHomeWithIndex(2),
                iconData: FontAwesomeIcons.wallet,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel!.navigateToHomeWithIndex(3),
                iconData: FontAwesomeIcons.user,
                isActive: false,
              ),
            ],
          ),
        ),
        body: Container(
          height: screenHeight(context),
          color: appBackgroundColor,
          child: Align(
            alignment: getValueForScreenType(context: context, mobile: Alignment.topCenter, desktop: Alignment.center, tablet: Alignment.center),
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Align(
                  alignment: getValueForScreenType(context: context, mobile: Alignment.topCenter, desktop: Alignment.center, tablet: Alignment.center),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    constraints: BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 16.0,
                        ),
                        CustomText(
                          text: "How Earnings Accounts Work",
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: appFontColor(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CustomText(
                          text: "Account Balance",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        CustomText(
                          text:
                              "Your account balance is the amount of money you have available to transfer to your bank account this week. \nThis amount varies if:",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        CustomText(
                          text: "- You have collected cash from customers.",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        CustomText(
                          text: "- You have initiated an instant deposit this week.",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        CustomText(
                          text: "- You have sold tickets for your event(s).",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        CustomText(
                          text: "- You have received gifts or donations through for your stream(s).",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 32.0,
                        ),
                        CustomText(
                          text: "Payout Schedule",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        CustomText(
                          text:
                              "You get paid for tickets you distribute and donations/gifts you receive through live streams. You get paid on a weekly basis for tickets while money received through donations or gifts are paid out monthly.",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.0),
                        CustomText(
                          text:
                              "Payouts are completed between Monday - Sunday of the previous week (ending Sunday at midnight CST). Payments are transferred at that time directly to your bank account through Direct Deposit, and usually take 2-3 days to show up in your bank account. Payments should appear in your bank account by Wednesday night.",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CustomText(
                          text: "Instant Deposits",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        CustomText(
                          text:
                              "You have the ability to cash-out your earnings daily for a fee of up to 1.5% the total deposit. This allows you to receive your earnings from ticket sales, gifts, and donations on demand from Webblen rather than waiting for a direct deposit.",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        CustomText(
                          text: "You must have a valid debit card (NOT A PREPAID CARD) to use Webblen's instant deposit service.",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
