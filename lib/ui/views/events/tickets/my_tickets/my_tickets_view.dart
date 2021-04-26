import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/events/event_ticket_block/event_ticket_block_view.dart';

import 'my_tickets_view_model.dart';

class MyTicketsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyTicketsViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => MyTicketsViewModel(),
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
                            _TicketsList(),
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

class _TicketsList extends HookViewModelWidget<MyTicketsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, MyTicketsViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: model.loadedEvents.isEmpty
          ? CustomText(
              text: "No Tickets Found in Your Wallet\nIf this is a mistake, please contact team@webblen.com",
              textAlign: TextAlign.center,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: appFontColorAlt(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                verticalSpaceMedium,
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: model.loadedEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return EventTicketBlock(
                      eventTitle: model.loadedEvents[index]['eventTitle'],
                      eventAddress: model.loadedEvents[index]['eventAddress'],
                      eventStartDate: model.loadedEvents[index]['eventStartDate'],
                      eventStartTime: model.loadedEvents[index]['eventStartTime'],
                      eventEndTime: model.loadedEvents[index]['eventEndTime'],
                      eventTimezone: model.loadedEvents[index]['eventTimezone'],
                      numOfTicsForEvent: model.ticsPerEvent[model.loadedEvents[index]['id']],
                      viewEventTickets: () => model.navigateToEventTickets(eventID: model.loadedEvents[index]['id']),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
