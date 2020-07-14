import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/events/event_block.dart';

class MyEventsPage extends StatefulWidget {
  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  bool isLoading = true;
  List<WebblenEvent> events = [];

  Widget eventGrid() {
    return ResponsiveGridList(
      scroll: false,
      desiredItemWidth: 260,
      minSpacing: 10,
      children: events
          .map((e) => EventBlock(
                eventImgSize: 260,
                eventDescHeight: 120,
                event: e,
                shareEvent: null,
                numOfTicsForEvent: null,
                viewEventDetails: () => e.navigateToEvent(e.id),
                viewEventTickets: null,
              ))
          .toList(),
    );
  }

  Widget desktopView(SizingInformation screenSize, bool isLoggedIn) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomText(
                context: context,
                text: "My Events",
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
              ),
              CustomColorButton(
                text: "Create Event",
                textColor: Colors.black,
                backgroundColor: Colors.white,
                height: 35.0,
                width: 150,
                onPressed: () => locator<NavigationService>().navigateTo(CreateEventRoute),
              ).showCursorOnHover
            ],
          ),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: events.isEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: Center(
                    child: CustomText(
                      context: context,
                      text: "You Have Not Created Any Events",
                      textColor: Colors.black,
                      textAlign: TextAlign.center,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : eventGrid(),
        ),
        SizedBox(height: 32.0),
      ],
    );
  }

  Widget tabletView(SizingInformation screenSize, bool isLoggedIn) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 24.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomText(
                context: context,
                text: "Find Events In ",
                textColor: Colors.black,
                textAlign: TextAlign.center,
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          isLoggedIn
              ? Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 16.0),
                      CustomColorButton(
                        text: "Create Event",
                        textColor: Colors.black,
                        backgroundColor: Colors.white,
                        height: 35.0,
                        width: 200,
                        onPressed: () => locator<NavigationService>().navigateTo(CreateEventRoute),
                      ).showCursorOnHover
                    ],
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: events.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: Center(
                      child: CustomText(
                        context: context,
                        text: "No Events Could Be Found According Your Your Preferences",
                        textColor: Colors.black,
                        textAlign: TextAlign.center,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : eventGrid(),
          ),
        ],
      ),
    );
  }

  Widget MobileView(SizingInformation screenSize, bool isLoggedIn) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 16.0),
          CustomText(
            context: context,
            text: "Find Events In ",
            textColor: Colors.black,
            textAlign: TextAlign.center,
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 16.0),
          isLoggedIn
              ? Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 16.0),
                      CustomColorButton(
                        text: "Create Event",
                        textColor: Colors.black,
                        backgroundColor: Colors.white,
                        height: 35.0,
                        width: 175,
                        onPressed: () => locator<NavigationService>().navigateTo(CreateEventRoute),
                      ).showCursorOnHover
                    ],
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: events.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: Center(
                      child: CustomText(
                        context: context,
                        text: "No Events Could Be Found According Your Your Preferences",
                        textColor: Colors.black,
                        textAlign: TextAlign.center,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : eventGrid(),
          ),
        ],
      ),
    );
  }

  queryEvents() async {
    isLoading = true;
    setState(() {});
    String currentUID = await FirebaseAuthenticationService().getCurrentUserID();
    EventDataService().getMyEvents(currentUID).then((res) {
      print(res);
      if (res != null) {
        events = res;
      }
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryEvents();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              // user == null || user.isAnonymous ? isLoading ? Container() : notLoggedInNotice() : Container(),
              isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
              isLoading
                  ? Container(
                      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    )
                  : screenSize.isDesktop
                      ? desktopView(screenSize, user == null || user.isAnonymous ? false : true)
                      : screenSize.isTablet
                          ? tabletView(screenSize, user == null || user.isAnonymous ? false : true)
                          : MobileView(screenSize, user == null || user.isAnonymous ? false : true),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
