import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/strings.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/styles/custom_colors.dart';
import 'package:webblen_web_app/styles/custom_text.dart';
import 'package:webblen_web_app/widgets/layout/centered_view.dart';

class IndexEventsPage extends StatefulWidget {
  @override
  _IndexEventsPageState createState() => _IndexEventsPageState();
}

class _IndexEventsPageState extends State<IndexEventsPage> {
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
          openGoogleAutoComplete: () => openGoogleAutoComplete(),
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
