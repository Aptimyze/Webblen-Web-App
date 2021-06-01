import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';

import 'open_app_block_view_model.dart';

class OpenAppBlock extends StatelessWidget {
  final dynamic content;
  OpenAppBlock({required this.content});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OpenAppBlockViewModel>.reactive(
      onModelReady: (model) => model.initialize(content),
      viewModelBuilder: () => OpenAppBlockViewModel(),
      builder: (context, model, child) => (model.isBusy || model.appLink == null || model.dismissedNotice) ||
              (getValueForScreenType(context: context, mobile: false, desktop: true, tablet: false))
          ? SizedBox(height: 0, width: 0)
          : Container(
              height: 140,
              constraints: BoxConstraints(
                maxWidth: 500,
              ),
              padding: EdgeInsets.only(left: 16, right: 16),
              color: CustomColors.webblenRed,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CustomText(
                          text: "Webblen is Better on the App",
                          color: Colors.white,
                          textAlign: TextAlign.center,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 3.0),
                        CustomText(
                          text: "Earn Money and Rewards from Events, Streams, and More!",
                          color: Colors.white,
                          textAlign: TextAlign.center,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 3.0),
                        CustomText(
                          text: "Open this in the Webblen App to Get the Full Experience!",
                          color: Colors.white,
                          textAlign: TextAlign.center,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 8.0),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 200,
                            child: CustomButton(
                              text: "Open in the App",
                              textSize: 14,
                              height: 30,
                              width: 200,
                              onPressed: () => model.openApp(),
                              backgroundColor: Colors.white,
                              textColor: CustomColors.webblenRed,
                              elevation: 0,
                              isBusy: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => model.dismissNotice(),
                      child: Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Icon(
                          FontAwesomeIcons.times,
                          color: Colors.white70,
                          size: 16.0,
                        ),
                      ),
                    ).showCursorOnHover,
                  ),
                  verticalSpaceSmall,
                ],
              ),
            ),
    );
  }
}
