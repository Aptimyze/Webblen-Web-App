import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class EventBlock extends StatelessWidget {
  final WebblenEvent event;
  final int numOfTicsForEvent;
  final VoidCallback viewEventTickets;
  final VoidCallback viewEventDetails;
  final VoidCallback shareEvent;
  final double eventImgSize;
  final double eventDescHeight;
  EventBlock({this.event, this.numOfTicsForEvent, this.viewEventTickets, this.viewEventDetails, this.shareEvent, this.eventImgSize, this.eventDescHeight});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: viewEventTickets == null ? viewEventDetails : viewEventTickets,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        width: eventImgSize,
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
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
              child: Image.network(
                event.imageURL,
                fit: BoxFit.cover,
                height: eventImgSize,
                width: eventImgSize,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              height: eventDescHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomText(
                      context: context,
                      text: event.title,
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 12.0,
                        color: Colors.black38,
                      ),
                      SizedBox(width: 4.0),
                      CustomText(
                        context: context,
                        text: "${event.city}, ${event.province}",
                        textColor: Colors.black45,
                        textAlign: TextAlign.left,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  CustomText(
                    context: context,
                    text: "${event.startDate} | ${event.startTime} ${event.timezone}",
                    textColor: Colors.black45,
                    textAlign: TextAlign.left,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ).showCursorOnHover;
  }
}
