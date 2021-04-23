import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/events/tickets/tickets_purchase_success/tickets_purchase_success_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';

class TicketsPurchaseSuccessView extends StatelessWidget {
  final String? email;
  TicketsPurchaseSuccessView(@PathParam() this.email);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TicketsPurchaseSuccessViewModel>.reactive(
      viewModelBuilder: () => TicketsPurchaseSuccessViewModel(),
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
          height: screenHeight(context),
          color: appBackgroundColor,
          child: Align(
            alignment: Alignment.center,
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
                          text: "Ticket Purchase Successful!",
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: appFontColor(),
                          textAlign: TextAlign.center,
                        ),
                        verticalSpaceSmall,
                        CustomText(
                          text: "An email was sent to $email",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appFontColor(),
                          textAlign: TextAlign.center,
                        ),
                        verticalSpaceSmall,
                        CustomText(
                          text: "Your tickets are located in your wallet.\nFeel free to share and screenshot them!",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appFontColor(),
                          textAlign: TextAlign.center,
                        ),
                        verticalSpaceMedium,
                        CustomButton(
                          text: "View Wallet",
                          textSize: 16,
                          height: 40,
                          width: 300,
                          onPressed: () => model.webblenBaseViewModel.navigateToHomeWithIndex(2),
                          backgroundColor: appButtonColor(),
                          textColor: appFontColor(),
                          elevation: 1,
                          isBusy: false,
                        ),
                        verticalSpaceLarge,
                        CustomText(
                          text: "If you have any issues with the event are tickets, please contact team@webblen.com for support.",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                          textAlign: TextAlign.center,
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
