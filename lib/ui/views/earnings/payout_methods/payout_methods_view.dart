import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/user_stripe_info.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/earnings/payout_methods/payout_methods_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/wallet/payout_methods/payout_methods_block_view.dart';

class PayoutMethodsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PayoutMethodsViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => PayoutMethodsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: CustomTopNavBar(
            navBarItems: [
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(0),
                iconData: FontAwesomeIcons.home,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(1),
                iconData: FontAwesomeIcons.search,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(2),
                iconData: FontAwesomeIcons.wallet,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(3),
                iconData: FontAwesomeIcons.user,
                isActive: false,
              ),
            ],
          ),
        ),
        body: Container(
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
                            onPressed: () => model.webblenBaseViewModel.navigateToAuthView(),
                            backgroundColor: appBackgroundColor,
                            textColor: appFontColor(),
                            elevation: 1.0,
                            isBusy: false,
                          ),
                        ],
                      ),
                    )
                  : model.isBusy
                  ? Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Center(
                            child: CustomCircleProgressIndicator(
                              size: 10,
                              color: appActiveColor(),
                            ),
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
                            alignment:
                                getValueForScreenType(context: context, mobile: Alignment.topCenter, desktop: Alignment.center, tablet: Alignment.center),
                            child: _PayoutMethodBody(
                              userBankingInfo: model.userStripeInfo!.userBankingInfo == null ? UserBankingInfo() : model.userStripeInfo!.userBankingInfo!,
                              userCardInfo: model.userStripeInfo!.userCardInfo == null ? UserCardInfo() : model.userStripeInfo!.userCardInfo!,
                              updateUserBankingInfoAction: () => model.navigateToSetUpDirectDepositView(),
                              updateUserCardInfoAction: () => model.navigateToSetUpInstantDepositView(),
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

class _PayoutMethodBody extends StatelessWidget {
  final UserBankingInfo userBankingInfo;
  final UserCardInfo userCardInfo;
  final VoidCallback updateUserBankingInfoAction;
  final VoidCallback updateUserCardInfoAction;

  _PayoutMethodBody({
    required this.userBankingInfo,
    required this.userCardInfo,
    required this.updateUserBankingInfoAction,
    required this.updateUserCardInfoAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: "Payout Methods",
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: appFontColor(),
          textAlign: TextAlign.center,
        ),
        !userBankingInfo.isValid()
            ? PayoutMethodBlockView(
                header: "Direct Deposit",
                subHeader: "Direct deposit is not set up. Please fill out your banking information in order to receive direct deposits",
                updateAction: updateUserBankingInfoAction,
                isSetUp: false,
              )
            : PayoutMethodBlockView(
                header: "Direct Deposit",
                subHeader: "Free weekly transfers are sent each Monday to account ending in ${userBankingInfo.last4}. "
                    "Payments may take 2-3"
                    " days to arrive "
                    "in your account.",
                updateAction: updateUserBankingInfoAction,
                isSetUp: true,
              ),
        !userCardInfo.isValid()
            ? PayoutMethodBlockView(
                header: "Instant Deposit",
                subHeader: "Instant deposit is not set up. Please fill out your card information in order to receive instant deposits.",
                updateAction: updateUserCardInfoAction,
                isSetUp: false,
              )
            : PayoutMethodBlockView(
                header: "Instant Deposit",
                subHeader: "Instant deposit is set up. Earnings are transferred to Debit Card ending in ${userCardInfo.last4} "
                    "upon request.",
                updateAction: updateUserCardInfoAction,
                isSetUp: true,
              ),
      ],
    );
  }
}
