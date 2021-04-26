import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/home/tabs/wallet/wallet_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/wallet/stripe/create_earnings_account/create_earnings_account_block_view.dart';
import 'package:webblen_web_app/ui/widgets/wallet/stripe/stripe_account/stripe_account_block_view.dart';
import 'package:webblen_web_app/ui/widgets/wallet/webblen_balance_block.dart';

class WalletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => WalletViewModel(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
        color: appBackgroundColor,
        child: SafeArea(
          child: Container(
            child: !model.isLoggedIn
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "You are not logged in",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: appFontColor(),
                        ),
                        CustomText(
                          text: "Please log in to view your wallet",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appFontColor(),
                        ),
                        verticalSpaceMedium,
                        CustomButton(
                          text: "Log In",
                          textSize: 16,
                          height: 30,
                          width: 200,
                          onPressed: () => model.webblenBaseViewModel!.navigateToAuthView(),
                          backgroundColor: appBackgroundColor,
                          textColor: appFontColor(),
                          elevation: 1.0,
                          isBusy: false,
                        ),
                      ],
                    ),
                  )
                : Align(
                    alignment: getValueForScreenType(context: context, mobile: Alignment.topCenter, desktop: Alignment.center, tablet: Alignment.center),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Align(
                          alignment: getValueForScreenType(context: context, mobile: Alignment.topCenter, desktop: Alignment.center, tablet: Alignment.center),
                          child: _WalletBody(
                            isBusy: model.isBusy,
                            stripeAccountSetup: model.stripeAccountIsSetup,
                            dismissedNotice: model.dismissedSetupAccountNotice,
                            dismissNotice: () => model.dismissCreateStripeAccountNotice(),
                            wblnBalance: model.user.WBLN!,
                            viewTickets: () => model.navigateToTicektsView(),
                            viewShop: () {},
                            viewPurchaseHistory: () {},
                            giveFeedback: () {},
                            viewHelpFAQ: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _WalletBody extends StatelessWidget {
  final bool isBusy;
  final bool stripeAccountSetup;
  final bool dismissedNotice;
  final VoidCallback dismissNotice;
  final double wblnBalance;
  final VoidCallback viewTickets;
  final VoidCallback viewShop;
  final VoidCallback viewPurchaseHistory;
  final VoidCallback giveFeedback;
  final VoidCallback viewHelpFAQ;

  _WalletBody({
    required this.isBusy,
    required this.stripeAccountSetup,
    required this.dismissedNotice,
    required this.dismissNotice,
    required this.wblnBalance,
    required this.viewTickets,
    required this.viewShop,
    required this.viewPurchaseHistory,
    required this.giveFeedback,
    required this.viewHelpFAQ,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      child: Column(
        children: [
          isBusy
              ? Container()
              : stripeAccountSetup
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 8.0),
                          StripeAccountBlockView(),
                          //stripeAccountMenu(verificationStatus, balance),
                        ],
                      ),
                    )
                  // ),
                  : dismissedNotice
                      ? CreateEarningsAccountBlockView(
                          dismissNotice: dismissNotice,
                        )
                      : Container(),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: WebblenBalanceBlock(
              balance: wblnBalance,
              onPressed: () {},
            ),
          ),
          SizedBox(height: 32.0),
          _WalletMenuOption(
            icon: Icon(
              FontAwesomeIcons.ticketAlt,
              color: appIconColor(),
              size: 18.0,
            ),
            name: "My Tickets",
            color: appFontColor(),
            onPressed: viewTickets,
          ).showCursorOnHover,
          SizedBox(height: 8.0),
          _WalletMenuOption(
            icon: Icon(
              FontAwesomeIcons.shoppingCart,
              color: appInActiveColorAlt(),
              size: 18.0,
            ),
            name: "Shop (coming soon)",
            color: appInActiveColorAlt(),
            onPressed: viewShop,
          ),
          // SizedBox(height: 8.0),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 16),
          //   color: appDividerColor(),
          //   height: 0.5,
          // ),
          // SizedBox(height: 8.0),
          // optionRow(
          //   context,
          //   Icon(
          //     FontAwesomeIcons.clock,
          //     color: appIconColor(),
          //     size: 18.0,
          //   ),
          //   'Purchase History',
          //   appFontColor(),
          //   // () => PageTransitionService(
          //   //   context: context,
          //   //   currentUser: currentUser,
          //   // ).transitionToRedeemedRewardsPage(),
          //   () => model.navigateToRedeemedRewardsView(),
          // ),
          // SizedBox(height: 8.0),
          // _WalletMenuOption(
          //   icon: Icon(
          //     FontAwesomeIcons.lightbulb,
          //     color: appIconColor(),
          //     size: 18.0,
          //   ),
          //   name: "Give Feedback",
          //   color: appFontColor(),
          //   onPressed: giveFeedback,
          // ).showCursorOnHover,
          // SizedBox(height: 8.0),
          // _WalletMenuOption(
          //   icon: Icon(FontAwesomeIcons.questionCircle, color: appIconColor(), size: 18.0),
          //   name: "Help/FAQ",
          //   color: appFontColor(),
          //   onPressed: viewHelpFAQ,
          // ).showCursorOnHover,
          // SizedBox(height: 8.0),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 16),
          //   color: appDividerColor(),
          //   height: 0.5,
          // ),
        ],
      ),
    );
  }
}

class _WalletMenuOption extends StatelessWidget {
  final Icon icon;
  final String name;
  final Color color;
  final VoidCallback onPressed;
  _WalletMenuOption({required this.icon, required this.name, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        height: 48.0,
        color: Colors.transparent,
        width: screenWidth(context),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 16.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: icon,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
