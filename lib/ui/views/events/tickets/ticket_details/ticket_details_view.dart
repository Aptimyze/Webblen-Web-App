import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_event_ticket.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';

import 'ticket_details_view_model.dart';

class TicketDetailsView extends StatelessWidget {
  final String? id;
  TicketDetailsView(@PathParam() this.id);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TicketDetailsViewModel>.reactive(
      onModelReady: (model) => model.initialize(id: id!),
      viewModelBuilder: () => TicketDetailsViewModel(),
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
                            SizedBox(height: 32.0),
                            _TicketDetails(ticket: model.ticket!),
                          ],
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

class _TicketDetails extends StatelessWidget {
  final WebblenEventTicket ticket;
  _TicketDetails({required this.ticket});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: appBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: 220,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: QrImage(
              data: ticket.id!,
              version: QrVersions.auto,
              size: 200.0,
            ),
            //              Column(
            //                crossAxisAlignment: CrossAxisAlignment.stretch,
            //                children: <Widget>[
            //                  Row(
            //                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                    children: <Widget>[
            //                      WebblenLogo(),
            //                      TagContainer(tag: "Concert/Performance"),
            //                    ],
            //                  ),
            //                  SizedBox(height: 10.0),
            //                  Center(
            //                    child: QrImage(
            //                      data: "1234567890",
            //                      version: QrVersions.auto,
            //                      size: 150.0,
            //                    ),
            //                  ),
            //                ],
            //              ),
          ),
          Container(
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(4.0),
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    color: appTextFieldContainerColor(),
                  ),
                  child: CustomText(
                    text: ticket.eventTitle,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: appFontColor(),
                  ),
                ),
                CustomText(
                  text: "Ticket Type:",
                  textAlign: TextAlign.left,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: appFontColor(),
                ),
                CustomText(
                  text: ticket.name,
                  textAlign: TextAlign.left,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: appFontColor(),
                ),
                SizedBox(height: 8.0),
                CustomText(
                  text: "Address:",
                  textAlign: TextAlign.left,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: appFontColor(),
                ),
                CustomText(
                  text: ticket.address,
                  textAlign: TextAlign.left,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: appFontColor(),
                ),
                SizedBox(height: 8.0),
                CustomText(
                  text: "Start Date & Time:",
                  textAlign: TextAlign.left,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: appFontColor(),
                ),
                CustomText(
                  text: "${ticket.startDate} | ${ticket.startTime}",
                  textAlign: TextAlign.left,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: appFontColor(),
                ),
                SizedBox(height: 8.0),
                CustomText(
                  text: "End Date & Time:",
                  textAlign: TextAlign.left,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: appFontColor(),
                ),
                CustomText(
                  text: "${ticket.endDate} | ${ticket.endTime}",
                  textAlign: TextAlign.left,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: appFontColor(),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
