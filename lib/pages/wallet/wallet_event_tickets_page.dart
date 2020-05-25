import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/models/event_ticket.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/events/event_purchased_tickets_list.dart';

class WalletEventTicketsPage extends StatefulWidget {
  final String eventID;
  WalletEventTicketsPage({this.eventID});
  @override
  _WalletEventTicketsPageState createState() => _WalletEventTicketsPageState();
}

class _WalletEventTicketsPageState extends State<WalletEventTicketsPage> {
  bool isLoading = true;
  WebblenEvent event;
  TicketDistro ticketDistro;
  List<EventTicket> tickets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuthenticationService().getCurrentUserID().then((res) {
      String uid = res;
      EventDataService().getEvent(widget.eventID).then((res) {
        event = res;
        EventDataService().getEventTicketDistro(widget.eventID).then((res) {
          ticketDistro = res;
          EventDataService().getPurchasedTickets(uid).then((res) {
            tickets = res;
            tickets.sort((ticketA, ticketB) => ticketA.ticketName.compareTo(ticketB.ticketName));
            isLoading = false;
            setState(() {});
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
            SizedBox(height: 16.0),
            isLoading
                ? Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.0),
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CustomText(
                          context: context,
                          text: event.title,
                          textColor: Colors.black,
                          textAlign: TextAlign.left,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w700,
                        ),
                        Row(
                          children: <Widget>[
                            CustomText(
                              context: context,
                              text: "Hosted By ",
                              textColor: Colors.black,
                              textAlign: TextAlign.left,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                            GestureDetector(
                              onTap: null,
                              child: CustomText(
                                context: context,
                                text: "@username",
                                textColor: CustomColors.webblenRed,
                                textAlign: TextAlign.left,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ).showCursorOnHover,
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
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
                              textColor: Colors.black38,
                              textAlign: TextAlign.left,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        CustomText(
                          context: context,
                          text: "${event.startDate} | ${event.startTime}",
                          textColor: Colors.black38,
                          textAlign: TextAlign.left,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () => event.navigateToEvent(widget.eventID),
                          child: CustomText(
                            context: context,
                            text: "View Event Details",
                            textColor: Colors.blueAccent,
                            textAlign: TextAlign.left,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ).showCursorOnHover,
                        SizedBox(height: 32.0),
                        CustomText(
                          context: context,
                          text: "Tickets",
                          textColor: Colors.black,
                          textAlign: TextAlign.left,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          underline: true,
                        ),
                        EventPurchasedTicketsList(tickets: tickets, validTickets: ticketDistro.validTicketIDs, usedTickets: ticketDistro.usedTicketIDs),
                      ],
                    ),
                  ),
            SizedBox(height: 32.0),
            isLoading ? Container() : Footer(),
          ],
        ),
      ),
    );
  }
}
