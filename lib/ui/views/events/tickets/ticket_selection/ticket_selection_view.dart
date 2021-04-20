import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/events/tickets/ticket_selection/ticket_selection_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_bottom_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';

class TicketSelectionView extends StatelessWidget {
  final String? id;
  TicketSelectionView(@PathParam() this.id);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TicketSelectionViewModel>.reactive(
      onModelReady: (model) => model.initialize(id!),
      viewModelBuilder: () => TicketSelectionViewModel(),
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
          child: model.isBusy
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
                        alignment: getValueForScreenType(context: context, mobile: Alignment.topCenter, desktop: Alignment.center, tablet: Alignment.center),
                        child: Column(
                          children: [
                            _TicketSelectionHead(),
                            _ListEventTickets(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        bottomNavigationBar: CustomBottomTicketActionBar(
          buttonAction: () => model.proceedToCheckout(),
          enabled: model.chargeAmount == 0 ? false : true,
        ),
      ),
    );
  }
}

class _TicketSelectionHead extends HookViewModelWidget<TicketSelectionViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, TicketSelectionViewModel model) {
    return Container(
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
            text: model.event!.title,
            textAlign: TextAlign.center,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          SizedBox(
            height: 4.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomText(
                text: "hosted by ",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: appFontColor(),
              ),
              CustomTextButton(
                onTap: () {},
                text: "@${model.host!.username}",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: appActiveColor(),
              ).showCursorOnHover,
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          CustomText(
            text: model.formatter.format(
              DateTime.fromMillisecondsSinceEpoch(model.event!.startDateTimeInMilliseconds!),
            ),
            textAlign: TextAlign.center,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: appFontColor(),
          ),
        ],
      ),
    );
  }
}

class _ListEventTickets extends HookViewModelWidget<TicketSelectionViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, TicketSelectionViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          verticalSpaceMedium,
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: appDividerColor(),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.only(right: 4),
                    child: CustomText(
                      text: 'Tickets',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: appFontColor(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 4),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 4),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
              ],
            ),
          ),
          verticalSpaceSmall,
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: model.ticketsToPurchase.length,
            itemBuilder: (BuildContext context, int index) {
              List<String> amountAvailableForPurchase = model.getListOfTicketsAvailableForPurchase(index);

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.only(right: 4),
                        child: CustomText(
                          text: model.ticketsToPurchase[index]['ticketName'],
                          color: appFontColor(),
                          textAlign: TextAlign.left,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(right: 4),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(right: 4),
                        child: CustomText(
                          text: model.ticketsToPurchase[index]['ticketPrice'],
                          color: appFontColor(),
                          textAlign: TextAlign.right,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            amountAvailableForPurchase.length == 1
                                ? CustomText(
                                    text: "SOLD OUT",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: appDestructiveColor(),
                                  )
                                : DropdownButton<String>(
                                    underline: Container(),
                                    iconSize: 14.0,
                                    isDense: true,
                                    isExpanded: false,
                                    value: model.ticketsToPurchase[index]['purchaseQty'].toString(),
                                    items: amountAvailableForPurchase.map((val) {
                                      return DropdownMenuItem(
                                        child: CustomText(
                                          text: val,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: appFontColor(),
                                        ),
                                        value: val,
                                      );
                                    }).toList(),
                                    onChanged: (val) => model.didSelectTicketQty(val!, index),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
