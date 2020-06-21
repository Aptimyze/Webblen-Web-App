import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/common/url_service.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/events/event_block.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<WebblenEvent> trendingEvents = [];

  Widget desktopView(BuildContext context, SizingInformation screenSize) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomText(
                      context: context,
                      text: "Find Events.",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 60.0,
                      fontWeight: FontWeight.w700,
                    ),
                    CustomText(
                      context: context,
                      text: "Build Communities.",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 60.0,
                      fontWeight: FontWeight.w700,
                    ),
                    CustomText(
                      context: context,
                      text: "Get Paid.",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 60.0,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomColorButton(
                      onPressed: () => locator<NavigationService>().navigateTo(EventsRoute),
                      text: "Browse Events",
                      textColor: Colors.white,
                      backgroundColor: CustomColors.webblenRed,
                      textSize: 18.0,
                      height: 40.0,
                      width: 200.0,
                    ).showCursorOnHover,
                  ],
                ),
              ),
              Expanded(
                child: Image.asset(
                  "assets/images/directions.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32.0),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomColors.webblenRed,
                CustomColors.webblenPink,
              ],
              begin: Alignment(-1.0, -0.8),
              end: Alignment(1.0, 0.7),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 45.0),
              CustomText(
                context: context,
                text: "Get the Most Out of Webblen",
                textColor: Colors.white,
                textAlign: TextAlign.center,
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 20.0),
              Container(
                child: Column(
                  children: [
                    CustomText(
                      context: context,
                      text: "Download the App",
                      textColor: Colors.white,
                      textAlign: TextAlign.center,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => URLService().openURL(context, 'https://apps.apple.com/us/app/webblen/id1196159158'),
                          child: Container(
                            width: 150,
                            child: Image.asset(
                              "assets/images/app_store_badge.png",
                              fit: BoxFit.contain,
                              scale: 1,
                            ),
                          ),
                        ).showCursorOnHover,
                        SizedBox(width: 16.0),
                        GestureDetector(
                          onTap: () => URLService().openURL(context, 'https://play.google.com/store/apps/details?id=com.webblen.events.webblen&hl=en_US'),
                          child: Container(
                            width: 150,
                            child: Image.asset(
                              "assets/images/google_play_badge.png",
                              fit: BoxFit.contain,
                              scale: 1,
                            ),
                          ),
                        ).showCursorOnHover,
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget tabletView(BuildContext context, SizingInformation screenSize) {
    return Column(
      //mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Find Events.",
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "Build Communities.",
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "Get Paid.",
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.0),
        CustomColorButton(
          onPressed: () => locator<NavigationService>().navigateTo(EventsRoute),
          text: "Browse Events",
          textColor: Colors.white,
          backgroundColor: CustomColors.webblenRed,
          textSize: 18.0,
          height: 40.0,
          width: 200.0,
        ).showCursorOnHover,
        Container(
          height: 300,
          child: Image.asset(
            "assets/images/directions.png",
            fit: BoxFit.cover,
            //scale: 1,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomColors.webblenRed,
                CustomColors.webblenPink,
              ],
              begin: Alignment(-1.0, -0.8),
              end: Alignment(1.0, 0.7),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 45.0),
              CustomText(
                context: context,
                text: "Get the Most Out of Webblen",
                textColor: Colors.white,
                textAlign: TextAlign.center,
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 20.0),
              Container(
                child: Column(
                  children: [
                    CustomText(
                      context: context,
                      text: "Download the App",
                      textColor: Colors.white,
                      textAlign: TextAlign.center,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => URLService().openURL(context, 'https://apps.apple.com/us/app/webblen/id1196159158'),
                          child: Container(
                            width: 150,
                            child: Image.asset(
                              "assets/images/app_store_badge.png",
                              fit: BoxFit.contain,
                              scale: 1,
                            ),
                          ),
                        ).showCursorOnHover,
                        SizedBox(width: 16.0),
                        GestureDetector(
                          onTap: () => URLService().openURL(context, 'https://play.google.com/store/apps/details?id=com.webblen.events.webblen&hl=en_US'),
                          child: Container(
                            width: 150,
                            child: Image.asset(
                              "assets/images/google_play_badge.png",
                              fit: BoxFit.contain,
                              scale: 1,
                            ),
                          ),
                        ).showCursorOnHover,
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget mobileView(BuildContext context, SizingInformation screenSize) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Find Events.",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "Build Communities.",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "Get Paid.",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.0),
        CustomColorButton(
          onPressed: () => locator<NavigationService>().navigateTo(EventsRoute),
          text: "Browse Events",
          textColor: Colors.white,
          backgroundColor: CustomColors.webblenRed,
          textSize: 18.0,
          height: 40.0,
          width: 200.0,
        ).showCursorOnHover,
        Center(
          child: Image.asset(
            "assets/images/directions.png",
            fit: BoxFit.cover,
            scale: 1,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomColors.webblenRed,
                CustomColors.webblenPink,
              ],
              begin: Alignment(-1.0, -0.8),
              end: Alignment(1.0, 0.7),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 45.0),
              CustomText(
                context: context,
                text: "Get the Most Out of Webblen",
                textColor: Colors.white,
                textAlign: TextAlign.center,
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 20.0),
              Container(
                child: Column(
                  children: [
                    CustomText(
                      context: context,
                      text: "Download the App",
                      textColor: Colors.white,
                      textAlign: TextAlign.center,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => URLService().openURL(context, 'https://apps.apple.com/us/app/webblen/id1196159158'),
                          child: Container(
                            width: 150,
                            child: Image.asset(
                              "assets/images/app_store_badge.png",
                              fit: BoxFit.contain,
                              scale: 1,
                            ),
                          ),
                        ).showCursorOnHover,
                        SizedBox(width: 16.0),
                        GestureDetector(
                          onTap: () => URLService().openURL(context, 'https://play.google.com/store/apps/details?id=com.webblen.events.webblen&hl=en_US'),
                          child: Container(
                            width: 150,
                            child: Image.asset(
                              "assets/images/google_play_badge.png",
                              fit: BoxFit.contain,
                              scale: 1,
                            ),
                          ),
                        ).showCursorOnHover,
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget trendingEventsListBuilder(SizingInformation screenSize) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: trendingEvents.length,
            itemBuilder: (BuildContext context, int index) {
              return FeaturedEventBlock(
                screenSize: screenSize,
                event: trendingEvents[index],
                viewEventDetails: () => trendingEvents[index].navigateToEvent(trendingEvents[index].id),
              );
            }),
      ),
    );
  }

  initialize() async {
    await Future.delayed(Duration(seconds: 2));
    EventDataService().getTrendingEvents().then((res) {
      trendingEvents = res;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 16.0),
            screenSize.isDesktop ? desktopView(context, screenSize) : screenSize.isTablet ? tabletView(context, screenSize) : mobileView(context, screenSize),
            Footer(),
          ],
        ),
      ),
    );
  }
}
