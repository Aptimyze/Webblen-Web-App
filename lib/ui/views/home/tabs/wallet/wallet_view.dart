import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/home/tabs/wallet/wallet_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/wallet/usd_balance_block.dart';
import 'package:webblen_web_app/ui/widgets/wallet/webblen_balance_block.dart';

class WalletView extends StatelessWidget {
  Widget optionRow(BuildContext context, Icon icon, String optionName, Color optionColor, VoidCallback onTap) {
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
              optionName,
              style: TextStyle(
                fontSize: 16,
                color: appFontColor(),
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => WalletViewModel(),
      builder: (context, model, child) => ResponsiveBuilder(
        builder: (context, screenSize) => Container(
          height: MediaQuery.of(context).size.height,
          color: appBackgroundColor,
          child: SafeArea(
            child: Container(
              child: model.webblenBaseViewModel!.user == null
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
                  : screenSize.isMobile
                      ? ListView(
                          shrinkWrap: true,
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 500,
                                ),
                                child: Column(
                                  children: [
                                    verticalSpaceMedium,
                                    model.isBusy
                                        ? Container()
                                        : model.stripeAccountIsSetup
                                            ? Container(
                                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    SizedBox(height: 8.0),
                                                    USDBalanceBlock(
                                                      onPressed: () {},
                                                      balance: model.userStripeInfo!.availableBalance ?? 0.00,
                                                      pendingBalance: model.userStripeInfo!.pendingBalance ?? 0.00,
                                                      // onPressed: () => showStripeAcctBottomSheet(
                                                      //     verificationStatus, balance),
                                                    ),
                                                    //stripeAccountMenu(verificationStatus, balance),
                                                  ],
                                                ),
                                              )
                                            // ),
                                            : Container(),
                                    SizedBox(height: 16.0),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      child: WebblenBalanceBlock(
                                        balance: model.webblenBaseViewModel!.user!.WBLN,
                                        onPressed: () {},
                                        // balance: webblenBalance,
                                        // onPressed: () => showWebblenBottomSheet(webblenBalance),
                                      ),
                                    ),
                                    SizedBox(height: 32.0),
                                    optionRow(
                                      context,
                                      Icon(
                                        FontAwesomeIcons.shoppingCart,
                                        color: appIconColor(),
                                        size: 18.0,
                                      ),
                                      'Shop',
                                      appFontColor(),
                                      // () => PageTransitionService(
                                      //   context: context,
                                      //   currentUser: currentUser,
                                      // ).transitionToShopPage(),
                                      () {},
                                    ),
                                    SizedBox(height: 8.0),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      color: appDividerColor(),
                                      height: 0.5,
                                    ),
                                    SizedBox(height: 8.0),
                                    optionRow(
                                      context,
                                      Icon(
                                        FontAwesomeIcons.trophy,
                                        color: appIconColor(),
                                        size: 18.0,
                                      ),
                                      'Reward History',
                                      appFontColor(),
                                      // () => PageTransitionService(
                                      //   context: context,
                                      //   currentUser: currentUser,
                                      // ).transitionToRedeemedRewardsPage(),
                                      () => model.navigateToRedeemedRewardsView(),
                                    ),
                                    SizedBox(height: 8.0),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      color: appDividerColor(),
                                      height: 0.5,
                                    ),
                                    SizedBox(height: 8.0),
                                    optionRow(
                                      context,
                                      Icon(
                                        FontAwesomeIcons.ticketAlt,
                                        color: appIconColor(),
                                        size: 18.0,
                                      ),
                                      'My Tickets',
                                      appFontColor(),
                                      // () => PageTransitionService(context: context)
                                      //     .transitionToUserTicketsPage(),
                                      () {},
                                    ),
                                    SizedBox(height: 8.0),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      color: appDividerColor(),
                                      height: 0.5,
                                    ),
                                    SizedBox(height: 8.0),
                                    optionRow(
                                      context,
                                      Icon(
                                        FontAwesomeIcons.lightbulb,
                                        color: appIconColor(),
                                        size: 18.0,
                                      ),
                                      'Give Feedback',
                                      appFontColor(),
                                      // () => PageTransitionService(
                                      //   context: context,
                                      //   currentUser: currentUser,
                                      // ).transitionToFeedbackPage(),
                                      () {},
                                    ),
                                    SizedBox(height: 8.0),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      color: appDividerColor(),
                                      height: 0.5,
                                    ),
                                    SizedBox(height: 8.0),
                                    optionRow(
                                      context,
                                      Icon(FontAwesomeIcons.questionCircle, color: appIconColor(), size: 18.0),
                                      'Help/FAQ',
                                      appFontColor(),
                                      // () => OpenUrl().launchInWebViewOrVC(
                                      //   context,
                                      //   'https://www.webblen.io/faq',
                                      // ),
                                      () {},
                                    ),
                                    SizedBox(height: 8.0),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      color: appDividerColor(),
                                      height: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Center(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 500,
                                  ),
                                  child: Column(
                                    children: [
                                      model.isBusy
                                          ? Container()
                                          : model.stripeAccountIsSetup
                                              ? Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      SizedBox(height: 8.0),
                                                      USDBalanceBlock(
                                                        onPressed: () {},
                                                        balance: model.userStripeInfo!.availableBalance ?? 0.00,
                                                        pendingBalance: model.userStripeInfo!.pendingBalance ?? 0.00,
                                                        // onPressed: () => showStripeAcctBottomSheet(
                                                        //     verificationStatus, balance),
                                                      ),
                                                      //stripeAccountMenu(verificationStatus, balance),
                                                    ],
                                                  ),
                                                )
                                              // ),
                                              : Container(),
                                      SizedBox(height: 16.0),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: WebblenBalanceBlock(
                                          balance: model.webblenBaseViewModel!.user!.WBLN,
                                          onPressed: () {},
                                          // balance: webblenBalance,
                                          // onPressed: () => showWebblenBottomSheet(webblenBalance),
                                        ),
                                      ),
                                      SizedBox(height: 32.0),
                                      optionRow(
                                        context,
                                        Icon(
                                          FontAwesomeIcons.shoppingCart,
                                          color: appIconColor(),
                                          size: 18.0,
                                        ),
                                        'Shop',
                                        appFontColor(),
                                        // () => PageTransitionService(
                                        //   context: context,
                                        //   currentUser: currentUser,
                                        // ).transitionToShopPage(),
                                        () {},
                                      ),
                                      SizedBox(height: 8.0),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        color: appDividerColor(),
                                        height: 0.5,
                                      ),
                                      SizedBox(height: 8.0),
                                      optionRow(
                                        context,
                                        Icon(
                                          FontAwesomeIcons.trophy,
                                          color: appIconColor(),
                                          size: 18.0,
                                        ),
                                        'Reward History',
                                        appFontColor(),
                                        // () => PageTransitionService(
                                        //   context: context,
                                        //   currentUser: currentUser,
                                        // ).transitionToRedeemedRewardsPage(),
                                        () => model.navigateToRedeemedRewardsView(),
                                      ),
                                      SizedBox(height: 8.0),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        color: appDividerColor(),
                                        height: 0.5,
                                      ),
                                      SizedBox(height: 8.0),
                                      optionRow(
                                        context,
                                        Icon(
                                          FontAwesomeIcons.ticketAlt,
                                          color: appIconColor(),
                                          size: 18.0,
                                        ),
                                        'My Tickets',
                                        appFontColor(),
                                        // () => PageTransitionService(context: context)
                                        //     .transitionToUserTicketsPage(),
                                        () {},
                                      ),
                                      SizedBox(height: 8.0),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        color: appDividerColor(),
                                        height: 0.5,
                                      ),
                                      SizedBox(height: 8.0),
                                      optionRow(
                                        context,
                                        Icon(
                                          FontAwesomeIcons.lightbulb,
                                          color: appIconColor(),
                                          size: 18.0,
                                        ),
                                        'Give Feedback',
                                        appFontColor(),
                                        // () => PageTransitionService(
                                        //   context: context,
                                        //   currentUser: currentUser,
                                        // ).transitionToFeedbackPage(),
                                        () {},
                                      ),
                                      SizedBox(height: 8.0),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        color: appDividerColor(),
                                        height: 0.5,
                                      ),
                                      SizedBox(height: 8.0),
                                      optionRow(
                                        context,
                                        Icon(FontAwesomeIcons.questionCircle, color: appIconColor(), size: 18.0),
                                        'Help/FAQ',
                                        appFontColor(),
                                        // () => OpenUrl().launchInWebViewOrVC(
                                        //   context,
                                        //   'https://www.webblen.io/faq',
                                        // ),
                                        () {},
                                      ),
                                      SizedBox(height: 8.0),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        color: appDividerColor(),
                                        height: 0.5,
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
        ),
      ),
    );
  }
}
