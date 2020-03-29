import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/constants/strings.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/layout/centered_view.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String cityFilter = "Fargo, ND";

  GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: Strings.googleAPIKEY,
  );

  openGoogleAutoComplete() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Strings.googleAPIKEY,
      onError: (res) {
        print(res.errorMessage);
      },
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

  @override
  Widget build(BuildContext context) {
    return CenteredView(
      child: ScreenTypeLayout(
        desktop: DesktopView(
          cityFilter: cityFilter,
          openGoogleAutoComplete: () => openGoogleAutoComplete(), //() => openGoogleAutoComplete(),
        ),
        tablet: TabletView(
          cityFilter: cityFilter,
          openGoogleAutoComplete: () => openGoogleAutoComplete(),
        ),
        mobile: MobileView(
          cityFilter: cityFilter,
          openGoogleAutoComplete: () => openGoogleAutoComplete(),
        ),
      ),
    );
  }
}

class DesktopView extends StatelessWidget {
  final String cityFilter;
  final VoidCallback openGoogleAutoComplete;
  DesktopView({this.cityFilter, this.openGoogleAutoComplete});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
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
            CustomColorButton(
              text: "Create Event",
              textColor: Colors.black,
              backgroundColor: Colors.white,
              height: 35.0,
              width: 200,
              onPressed: () => locator<NavigationService>().navigateTo(CreateEventRoute),
            ).showCursorOnHover,
          ],
        ),
      ],
    );
  }
}

class TabletView extends StatelessWidget {
  final String cityFilter;
  final VoidCallback openGoogleAutoComplete;
  TabletView({this.cityFilter, this.openGoogleAutoComplete});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
        CustomColorButton(
          text: "Create Event",
          textColor: Colors.black,
          backgroundColor: Colors.white,
          height: 35.0,
          width: 200,
          onPressed: null,
        ).showCursorOnHover,
      ],
    );
  }
}

class MobileView extends StatelessWidget {
  final String cityFilter;
  final VoidCallback openGoogleAutoComplete;
  MobileView({this.cityFilter, this.openGoogleAutoComplete});
  @override
  Widget build(BuildContext context) {
    return Column(
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
            textAlign: TextAlign.left,
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          ).showCursorOnHover,
        ),
      ],
    );
  }
}
