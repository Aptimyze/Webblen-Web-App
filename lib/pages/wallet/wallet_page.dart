import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/models/event_ticket.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/events/event_grid.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  static final firestore = firebase.firestore();
  CollectionReference userRef = firestore.collection("users");
  bool isLoading = true;
  WebblenUser currentUser;
  List<WebblenEvent> events = [];
  List<String> loadedEvents = [];
  Map<String, dynamic> ticsPerEvent = {};

  organizeNumOfTicketsByEvent(List<EventTicket> eventTickets) {
    eventTickets.forEach((ticket) async {
      if (!loadedEvents.contains(ticket.eventID)) {
        loadedEvents.add(ticket.eventID);
        WebblenEvent event = await EventDataService().getEvent(ticket.eventID);
        print(event);
        if (event != null) {
          events.add(event);
        }
      }
      if (ticsPerEvent[ticket.eventID] == null) {
        ticsPerEvent[ticket.eventID] = 1;
        print(ticsPerEvent);
      } else {
        ticsPerEvent[ticket.eventID] += 1;
      }
      if (eventTickets.last == ticket) {
        isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuthenticationService().getCurrentUserID().then((res) {
      String uid = res;
      EventDataService().getPurchasedTickets(uid).then((res) {
        organizeNumOfTicketsByEvent(res);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            isLoading
                ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed)
                : user == null
                    ? Container(height: MediaQuery.of(context).size.height)
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                        child: StreamBuilder<WebblenUser>(
                            stream: WebblenUserData().streamCurrentUser(user.uid),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Column(
                                  children: <Widget>[
                                    CustomLinearProgress(progressBarColor: CustomColors.webblenRed),
                                    Container(height: MediaQuery.of(context).size.height),
                                  ],
                                );
                              WebblenUser currentUser = snapshot.data;
                              return Container(
                                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(height: 16.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        MediaQuery(
                                          data: MediaQuery.of(context).copyWith(
                                            textScaleFactor: 1.0,
                                          ),
                                          child: CustomText(
                                            context: context,
                                            text: "Wallet",
                                            textColor: Colors.black,
                                            textAlign: TextAlign.left,
                                            fontSize: 40.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 32.0),
                                    CustomText(
                                      context: context,
                                      text: '${currentUser.webblen.toStringAsFixed(2)}',
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CustomText(
                                      context: context,
                                      text: 'Webblen Balance',
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    CustomText(
                                      context: context,
                                      text:
                                          "Webblen are tokens that can be transferred or traded at anytime.  Webblen can be used to create new events and communities.",
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      context: context,
                                      text: "Earn more Webblen by attending events and posting to communities.",
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(height: 32.0),
                                    CustomText(
                                      context: context,
                                      text: 'My Tickets',
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    events.isEmpty
                                        ? Container(
                                            child: CustomText(
                                              context: context,
                                              text: "You Do Not Have Any Tickets",
                                              textColor: Colors.black,
                                              textAlign: TextAlign.left,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : EventGrid(screenSize: screenSize, events: events, ticsPerEvent: ticsPerEvent),
                                  ],
                                ),
                              );
                            }),
                      ),
            SizedBox(height: 32.0),
            isLoading ? Container() : Footer(),
          ],
        ),
      ),
    );
  }
}
