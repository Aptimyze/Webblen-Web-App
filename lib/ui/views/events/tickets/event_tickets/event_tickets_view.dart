import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';

import 'event_tickets_view_model.dart';

class EventTicketsView extends StatelessWidget {
  final String? id;
  EventTicketsView(@PathParam() this.id);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EventTicketsViewModel>.reactive(
      onModelReady: (model) => model.initialize(eventID: id!),
      viewModelBuilder: () => EventTicketsViewModel(),
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
                  alignment: Alignment.topCenter,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Align(
                        alignment: getValueForScreenType(context: context, mobile: Alignment.topCenter, desktop: Alignment.center, tablet: Alignment.center),
                        child: Column(
                          children: [
                            SizedBox(height: 32.0),
                            _EventTicketsHead(),
                            _EventTicketsList(),
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

class _EventTicketsHead extends HookViewModelWidget<EventTicketsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, EventTicketsViewModel model) {
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
          GestureDetector(
            onTap: () => model.navigateToEventView(),
            child: CustomText(
              text: model.event!.title,
              textAlign: TextAlign.center,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
          ).showCursorOnHover,
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
                onTap: () => model.navigateToHostProfile(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.mapMarkerAlt,
                size: 14.0,
                color: Colors.black38,
              ),
              SizedBox(width: 4.0),
              CustomText(
                text: "${model.event!.city}, ${model.event!.province}",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
                color: appFontColorAlt(),
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          CustomText(
            text: "${model.event!.startDate} | ${model.event!.startTime}",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            color: appFontColorAlt(),
          ),
          SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }
}

class _EventTicketsList extends HookViewModelWidget<EventTicketsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, EventTicketsViewModel model) {
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
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.tickets.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 12.0),
                //height: 40.0,
                //width: MediaQuery.of(context).size.width * 0.60,
                child: GestureDetector(
                  onTap: () => model.navigateToTicketView(ticketID: model.tickets[index].id!),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText(
                          text: model.tickets[index].used == null || !model.tickets[index].used!
                              ? "${model.tickets[index].name}"
                              : "${model.tickets[index].name} (Used)",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: (model.tickets[index].used == null || !model.tickets[index].used!) ? Colors.blueAccent : appFontColorAlt(),
                        ),
                        CustomText(
                          text: "Ticket ID: ${model.tickets[index].id}",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: appFontColorAlt(),
                        ),
                      ],
                    ),
                  ),
                ).showCursorOnHover,
              );
            },
          ),
        ],
      ),
    );
  }
}
