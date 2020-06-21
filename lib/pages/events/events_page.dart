import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:webblen_web_app/algolia/algolia_search.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/constants/strings.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/text_field_container.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/events/event_block.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool isLoading = true;
  bool dismissedNotice = false;
  String cityFilter = "Fargo, ND";
  String eventTypeFilter = "None";
  String eventCategoryFilter = "None";
  List<WebblenEvent> events = [];

  GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: Strings.googleAPIKEY,
    baseUrl: Strings.proxyMapsURL,
  );

  openGoogleAutoComplete() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Strings.googleAPIKEY,
      onError: (res) {
        print(res.errorMessage);
      },
      proxyBaseUrl: Strings.proxyMapsURL,
      mode: Mode.overlay,
      language: "en",
      components: [
        Component(
          Component.country,
          "us",
        ),
      ],
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    String cityName = detail.result.addressComponents[0].longName;
    String stateAbbr = detail.result.addressComponents[2].shortName;
    setState(() {
      cityFilter = "$cityName, $stateAbbr";
    });
  }

  Widget notLoggedInNotice() {
    return dismissedNotice
        ? Container()
        : Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: CustomColors.textFieldGray,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Row(
                  children: <Widget>[
                    CustomText(
                      context: context,
                      text: "Interested in Creating an Event?",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => locator<NavigationService>().navigateTo(AccountLoginRoute),
                      child: CustomText(
                        context: context,
                        text: "Login Here",
                        textColor: Colors.blueAccent,
                        textAlign: TextAlign.left,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        underline: true,
                      ),
                    ).showCursorOnHover,
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    dismissedNotice = true;
                    setState(() {});
                  },
                  child: Icon(
                    FontAwesomeIcons.times,
                    color: Colors.black45,
                    size: 14.0,
                  ),
                ).showCursorOnHover,
              ],
            ),
          );
  }

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
              Container(
                child: Row(
                  children: <Widget>[
                    CustomText(
                      context: context,
                      text: "Find Events In ",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                    ),
                    GestureDetector(
                      onTap: openGoogleAutoComplete,
                      child: CustomText(
                        context: context,
                        text: cityFilter,
                        textColor: CustomColors.webblenRed,
                        textAlign: TextAlign.left,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                      ).showCursorOnHover,
                    ),
                  ],
                ),
              ),
              Container(
                width: 310,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isLoggedIn
                        ? CustomColorButton(
                            text: "My Events",
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            height: 35.0,
                            width: 150,
                            onPressed: () => locator<NavigationService>().navigateTo(CreateEventRoute),
                          ).showCursorOnHover
                        : Container(),
                    isLoggedIn
                        ? CustomColorButton(
                            text: "Create Event",
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            height: 35.0,
                            width: 150,
                            onPressed: () => locator<NavigationService>().navigateTo(CreateEventRoute),
                          ).showCursorOnHover
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.only(left: 24.0, top: 8.0),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    context: context,
                    text: "Category:",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8.0),
                  TextFieldContainer(
                    height: 35,
                    width: 200,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        child: DropdownButton(
                            style: TextStyle(fontSize: 12.0, color: Colors.black),
                            isExpanded: true,
                            underline: Container(),
                            value: eventCategoryFilter,
                            items: Strings.eventCategoryFilters.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                eventCategoryFilter = val;
                              });
                              queryAndFilterEvents();
                            }).showCursorOnHover),
                  ),
                ],
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    context: context,
                    text: "Type:",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8.0),
                  TextFieldContainer(
                    height: 35,
                    width: 200,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        child: DropdownButton(
                            style: TextStyle(fontSize: 12.0, color: Colors.black),
                            isExpanded: true,
                            underline: Container(),
                            value: eventTypeFilter,
                            items: Strings.eventTypeFilters.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                eventTypeFilter = val;
                              });
                              queryAndFilterEvents();
                            }).showCursorOnHover),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: eventGrid(),
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
              GestureDetector(
                onTap: openGoogleAutoComplete,
                child: CustomText(
                  context: context,
                  text: cityFilter,
                  textColor: CustomColors.webblenRed,
                  textAlign: TextAlign.center,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                ).showCursorOnHover,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    context: context,
                    text: "Category:",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8.0),
                  TextFieldContainer(
                    height: 35,
                    width: 200,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        child: DropdownButton(
                            style: TextStyle(fontSize: 12.0, color: Colors.black),
                            isExpanded: true,
                            underline: Container(),
                            value: eventCategoryFilter,
                            items: Strings.eventCategoryFilters.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                eventCategoryFilter = val;
                              });
                              queryAndFilterEvents();
                            }).showCursorOnHover),
                  ),
                ],
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    context: context,
                    text: "Type:",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8.0),
                  TextFieldContainer(
                    height: 35,
                    width: 200,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        child: DropdownButton(
                            style: TextStyle(fontSize: 12.0, color: Colors.black),
                            isExpanded: true,
                            underline: Container(),
                            value: eventTypeFilter,
                            items: Strings.eventTypeFilters.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                eventTypeFilter = val;
                              });
                              queryAndFilterEvents();
                            }).showCursorOnHover),
                  ),
                ],
              ),
            ],
          ),
          isLoggedIn
              ? Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomColorButton(
                        text: "My Events",
                        textColor: Colors.black,
                        backgroundColor: Colors.white,
                        height: 35.0,
                        width: 200,
                        onPressed: () => locator<NavigationService>().navigateTo(CreateEventRoute),
                      ).showCursorOnHover,
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
            child: eventGrid(),
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
          GestureDetector(
            onTap: openGoogleAutoComplete,
            child: CustomText(
              context: context,
              text: cityFilter,
              textColor: CustomColors.webblenRed,
              textAlign: TextAlign.left,
              fontSize: 30.0,
              fontWeight: FontWeight.w700,
            ).showCursorOnHover,
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    context: context,
                    text: "Category:",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8.0),
                  TextFieldContainer(
                    height: 35,
                    width: 175,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        child: DropdownButton(
                            style: TextStyle(fontSize: 12.0, color: Colors.black),
                            isExpanded: true,
                            underline: Container(),
                            value: eventCategoryFilter,
                            items: Strings.eventCategoryFilters.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                eventCategoryFilter = val;
                              });
                              queryAndFilterEvents();
                            }).showCursorOnHover),
                  ),
                ],
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    context: context,
                    text: "Type:",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8.0),
                  TextFieldContainer(
                    height: 35,
                    width: 175,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        child: DropdownButton(
                            style: TextStyle(fontSize: 12.0, color: Colors.black),
                            isExpanded: true,
                            underline: Container(),
                            value: eventTypeFilter,
                            items: Strings.eventTypeFilters.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                eventTypeFilter = val;
                              });
                              queryAndFilterEvents();
                            }).showCursorOnHover),
                  ),
                ],
              ),
            ],
          ),
          isLoggedIn
              ? Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomColorButton(
                        text: "My Events",
                        textColor: Colors.black,
                        backgroundColor: Colors.white,
                        height: 35.0,
                        width: 175,
                        onPressed: () => locator<NavigationService>().navigateTo(CreateEventRoute),
                      ).showCursorOnHover,
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
            child: eventGrid(),
          ),
        ],
      ),
    );
  }

  queryAndFilterEvents() {
    isLoading = true;
    setState(() {});
    AlgoliaSearch().queryEvents(cityFilter).then((res) {
      if (eventCategoryFilter != "None") {
        events = res.where((event) => event.category == eventCategoryFilter).toList(growable: true);
      }
      if (eventTypeFilter != "None") {
        events = res.where((event) => event.type == eventTypeFilter).toList(growable: true);
      }
      if (eventCategoryFilter == "None" && eventTypeFilter == "None") {
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
    queryAndFilterEvents();
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
              user == null || user.isAnonymous ? isLoading ? Container() : notLoggedInNotice() : Container(),
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
