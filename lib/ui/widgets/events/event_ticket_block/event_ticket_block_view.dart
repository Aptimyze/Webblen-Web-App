import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';

class EventTicketBlock extends StatelessWidget {
  final String eventTitle;
  final String eventAddress;
  final String eventStartDate;
  final String eventStartTime;
  final String eventEndTime;
  final String eventTimezone;
  final int numOfTicsForEvent;
  final VoidCallback viewEventTickets;
  EventTicketBlock({
    required this.eventTitle,
    required this.eventAddress,
    required this.eventStartDate,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.eventTimezone,
    required this.numOfTicsForEvent,
    required this.viewEventTickets,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: viewEventTickets,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1.5,
              blurRadius: 1.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomText(
                      text: eventTitle,
                      textAlign: TextAlign.left,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: appFontColor(),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 14.0,
                        color: Colors.black38,
                      ),
                      SizedBox(width: 4.0),
                      CustomText(
                        text: eventAddress,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: appFontColorAlt(),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomText(
                        text: "$eventStartDate | $eventStartTime - $eventEndTime $eventTimezone",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: appFontColorAlt(),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            CustomText(
                              text: numOfTicsForEvent.toString(),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: appFontColorAlt(),
                            ),
                            SizedBox(width: 4.0),
                            Icon(
                              FontAwesomeIcons.ticketAlt,
                              size: 18.0,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).showCursorOnHover;
  }
}
