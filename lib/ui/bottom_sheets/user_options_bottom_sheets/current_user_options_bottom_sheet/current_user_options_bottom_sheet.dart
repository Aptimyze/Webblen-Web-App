import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';

import 'current_user_options_bottom_sheet_model.dart';

class CurrentUserOptionsBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const CurrentUserOptionsBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CurrentUserOptionsBottomSheetModel>.nonReactive(
      viewModelBuilder: () => CurrentUserOptionsBottomSheetModel(),
      builder: (context, model, child) => Container(
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomIconButton(
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 16,
              ),
              height: 45,
              width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
              onPressed: () => completer!(SheetResponse(responseData: "saved")),
              backgroundColor: appButtonColor(),
              elevation: 1,
              text: "Saved",
              textColor: appFontColor(),
              centerContent: false,
            ),
            verticalSpaceSmall,
            CustomIconButton(
              icon: Icon(
                FontAwesomeIcons.edit,
                size: 16,
              ),
              height: 45,
              width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
              onPressed: () => completer!(SheetResponse(responseData: "edit profile")),
              backgroundColor: appButtonColor(),
              elevation: 1,
              text: "Edit Profile",
              textColor: appFontColor(),
              centerContent: false,
            ),
            verticalSpaceSmall,
            CustomIconButton(
              icon: Icon(
                FontAwesomeIcons.link,
                size: 16,
              ),
              height: 45,
              width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
              onPressed: () => completer!(SheetResponse(responseData: "share profile")),
              backgroundColor: appButtonColor(),
              elevation: 1,
              text: "Share Profile",
              textColor: appFontColor(),
              centerContent: false,
            ),
            verticalSpaceSmall,
            CustomIconButton(
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                size: 16,
              ),
              height: 45,
              width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
              onPressed: () => completer!(SheetResponse(responseData: "log out")),
              backgroundColor: appButtonColor(),
              elevation: 1,
              text: "Log Out",
              textColor: appFontColor(),
              centerContent: false,
            ),
          ],
        ),
      ),
    );
  }
}
