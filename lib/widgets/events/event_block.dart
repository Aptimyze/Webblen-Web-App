import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/widgets/common/containers/round_container.dart';
import 'package:webblen_web_app/widgets/common/containers/tag_container.dart';
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
                        context: context,
                        text: "${event.city}, ${event.province}",
                        textColor: Colors.black45,
                        textAlign: TextAlign.left,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  CustomText(
                    context: context,
                    text: "${event.startDate} | ${event.startTime}",
                    textColor: Colors.black45,
                    textAlign: TextAlign.left,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 6.0),
                  Container(
                    height: 1.0,
                    color: Colors.black12,
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TagContainer(tag: event.type),
                      numOfTicsForEvent == null
                          ? GestureDetector(
                              onTap: shareEvent,
                              child: RoundContainer(
                                child: Icon(
                                  Icons.share,
                                  size: 12.0,
                                  color: Colors.black45,
                                ),
                                color: CustomColors.textFieldGray,
                                size: 30,
                              ),
                            )
                          : Container(
                              child: Row(
                                children: <Widget>[
                                  CustomText(
                                    context: context,
                                    text: numOfTicsForEvent.toString(),
                                    textColor: Colors.black45,
                                    textAlign: TextAlign.left,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
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
            )
          ],
        ),
//        margin: EdgeInsets.only(
//          left: 8.0,
//          bottom: 8.0,
//          right: 8.0,
//        ),
//        height: MediaQuery.of(context).size.width - 16,
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.black12, width: 1.0),
//          image: DecorationImage(
//            image: NetworkImage(event.imageURL),
//            fit: BoxFit.cover,
//          ),
//          borderRadius: BorderRadius.circular(8.0),
//        ),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: <Widget>[
//            SizedBox(
//              height: 8.0,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                GestureDetector(
//                  onTap: shareEvent,
//                  child: Container(
//                    margin: EdgeInsets.only(
//                      right: 16.0,
//                    ),
//                    height: 30,
//                    width: 30,
//                    decoration: BoxDecoration(
//                      color: Colors.black38,
//                      borderRadius: BorderRadius.all(
//                        Radius.circular(25),
//                      ),
//                    ),
//                    child: Icon(
//                      FontAwesomeIcons.share,
//                      color: Colors.white,
//                      size: 14.0,
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Spacer(),
//            Container(
//              padding: EdgeInsets.only(
//                top: 8.0,
//              ),
//              decoration: BoxDecoration(
////                border: Border(
////                  top: BorderSide(
////                    color: CustomColors.darkGray,
////                    width: 1.0,
////                  ),
////                ),
//                color: CustomColors.textFieldGray,
//                borderRadius: BorderRadius.only(
//                  bottomLeft: Radius.circular(8.0),
//                  bottomRight: Radius.circular(8.0),
//                ),
//              ),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.symmetric(
//                      horizontal: 16.0,
//                      vertical: 4.0,
//                    ),
//                    child: FittedBox(
//                      fit: BoxFit.scaleDown,
//                      child: CustomText(
//                        context: context,
//                        text: event.title,
//                        textColor: Colors.black,
//                        textAlign: TextAlign.left,
//                        fontSize: 26.0,
//                        fontWeight: FontWeight.w700,
//                      ),
//                    ),
//                  ),
//                  Row(
//                    children: [
//                      SizedBox(
//                        width: 16.0,
//                      ),
//                      CustomText(
//                        context: context,
//                        text: "${event.startDate}",
//                        textColor: Colors.black,
//                        textAlign: TextAlign.left,
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.w500,
//                      ),
//                      Spacer(),
//                      CustomText(
//                        context: context,
//                        text: "${event.startTime}",
//                        textColor: Colors.black,
//                        textAlign: TextAlign.left,
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.w500,
//                      ),
//                      SizedBox(
//                        width: 16.0,
//                      ),
//                    ],
//                  ),
//                  SizedBox(
//                    height: 16.0,
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
      ),
    ).showCursorOnHover;
  }
}
