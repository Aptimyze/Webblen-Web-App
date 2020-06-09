import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/round_container.dart';
import 'package:webblen_web_app/widgets/common/containers/tag_container.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventID;
  EventDetailsPage({this.eventID});
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool isLoading = true;
  bool eventFound = false;
  WebblenEvent event;
  TicketDistro ticketDistro;

  @override
  void initState() {
    super.initState();
    if (widget.eventID != null) {
      EventDataService().getEvent(widget.eventID).then((res) {
        if (res != null) {
          event = res;
          eventFound = true;
        }
        isLoading = false;
        setState(() {});
      });
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  Widget eventDetailsWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              event.imageURL,
              height: MediaQuery.of(context).size.width * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 12.0),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomText(
                    context: context,
                    text: event.title,
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.mapMarkerAlt,
                      size: 16.0,
                      color: Colors.black38,
                    ),
                    SizedBox(width: 4.0),
                    CustomText(
                      context: context,
                      text: "${event.city}, ${event.province}",
                      textColor: Colors.black38,
                      textAlign: TextAlign.left,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomText(
                      context: context,
                      text: "${event.startDate} | ${event.startTime} ${event.timezone}",
                      textColor: Colors.black45,
                      textAlign: TextAlign.left,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    event.hasTickets
                        ? CustomColorButton(
                            text: "Purchase Tickets",
                            textColor: Colors.white,
                            backgroundColor: CustomColors.darkMountainGreen,
                            onPressed: () => event.navigateToEventTickets(event.id),
                            width: 200.0,
                            height: 30.0,
                          ).showCursorOnHover
                        : CustomText(
                            context: context,
                            text: "FREE EVENT",
                            textColor: Colors.black,
                            textAlign: TextAlign.right,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
//                  event.hasTickets
//                      ? CustomColorButton(
//                          text: "Purchase Tickets",
//                          textColor: Colors.white,
//                          backgroundColor: CustomColors.darkMountainGreen,
//                          onPressed: null,
//                        )
//                      : Container(),
                  ],
                ),
                SizedBox(height: 12.0),
                Container(
                  height: 1.0,
                  color: Colors.black12,
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TagContainer(tag: event.type),
                    GestureDetector(
                      onTap: null,
                      child: RoundContainer(
                        child: Icon(
                          Icons.share,
                          size: 12.0,
                          color: Colors.black38,
                        ),
                        color: CustomColors.textFieldGray,
                        size: 30,
                      ),
                    ).showCursorOnHover,
                  ],
                ),
                SizedBox(height: 8.0),
                CustomText(
                  context: context,
                  text: "Details:",
                  textColor: Colors.black,
                  textAlign: TextAlign.left,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 2.0),
                CustomText(
                  context: context,
                  text: event.desc,
                  textColor: Colors.black,
                  textAlign: TextAlign.left,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget eventNotFoundWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CustomText(
                context: context,
                text: "Event Not Found",
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
              SizedBox(height: 32.0),
              !isLoading && eventFound ? eventDetailsWidget() : !isLoading && !eventFound ? eventNotFoundWidget() : Container(),
              SizedBox(height: 32.0),
              isLoading ? Container() : Footer(),
            ],
          ),
        ),
      ),
    );
  }
}