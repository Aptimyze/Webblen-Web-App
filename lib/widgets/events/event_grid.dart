import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/events/event_block.dart';

class EventGrid extends StatelessWidget {
  final SizingInformation screenSize;
  final List<WebblenEvent> events;
  final Map<String, dynamic> ticsPerEvent;
  EventGrid({this.screenSize, this.events, this.ticsPerEvent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 380,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                Widget widget = Container();
                if (index.isEven) {
                  widget = EventBlock(
                    eventImgSize: 260,
                    eventDescHeight: 120,
                    event: events[index],
                    shareEvent: () => CustomAlerts().showEventShareLink(
                      context,
                      events[index].title,
                      "https://www.app.webblen.io/#/event?id=${events[index].id}",
                      () {},
                    ),
                    numOfTicsForEvent: ticsPerEvent == null ? null : ticsPerEvent[events[index].id],
                    viewEventDetails: () => events[index].navigateToEvent(events[index].id),
                    viewEventTickets: ticsPerEvent == null ? null : () => events[index].navigateToWalletTickets(events[index].id),
                  );
                }
                return widget;
              },
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            height: 380,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                Widget widget = Container();
                if (index.isOdd) {
                  widget = EventBlock(
                    eventImgSize: 260,
                    eventDescHeight: 120,
                    event: events[index],
                    shareEvent: null,
                    numOfTicsForEvent: ticsPerEvent == null ? null : ticsPerEvent[events[index].id],
                    viewEventDetails: () => events[index].navigateToEvent(events[index].id),
                    viewEventTickets: ticsPerEvent == null ? null : () => events[index].navigateToWalletTickets(events[index].id),
                  );
                }
                return widget;
              },
            ),
          ),
        ],
      ),
    );
  }
}
