import 'package:flutter/material.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class DesktopHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 600.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: <Widget>[
          Row(
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
                      fontSize: 65.0,
                      fontWeight: FontWeight.w700,
                    ),
                    CustomText(
                      context: context,
                      text: "Build Communities.",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 65.0,
                      fontWeight: FontWeight.w700,
                    ),
                    CustomText(
                      context: context,
                      text: "Get Paid.",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 65.0,
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
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                CustomColors.webblenRed,
                CustomColors.webblenLightGray,
                CustomColors.webblenMatteBlue,
              ]),
            ),
            child: Row(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
