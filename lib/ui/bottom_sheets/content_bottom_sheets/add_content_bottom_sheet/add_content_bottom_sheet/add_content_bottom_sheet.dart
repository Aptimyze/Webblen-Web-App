import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';

import 'add_content_bottom_sheet_model.dart';

class AddContentBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const AddContentBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddContentBottomSheetModel>.nonReactive(
      viewModelBuilder: () => AddContentBottomSheetModel(),
      builder: (context, model, child) => Container(
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () => completer!(SheetResponse(responseData: "new post")),
              text: "New Post",
              textSize: 16,
              textColor: appFontColor(),
              height: 45,
              width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
              backgroundColor: appButtonColor(),
              elevation: 1.0,
              isBusy: false,
            ),
            SizedBox(height: 16),
            CustomButton(
              onPressed: () => completer!(SheetResponse(responseData: "new stream")),
              text: "New Stream",
              textSize: 16,
              textColor: appFontColor(),
              height: 45,
              width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
              backgroundColor: appButtonColor(),
              elevation: 1.0,
              isBusy: false,
            ),
            SizedBox(height: 16),
            CustomButton(
              onPressed: () => completer!(SheetResponse(responseData: "new event")),
              text: "New Event",
              textSize: 16,
              textColor: appFontColor(),
              height: 45,
              width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
              backgroundColor: appButtonColor(),
              elevation: 1.0,
              isBusy: false,
            ),
          ],
        ),
      ),
    );
  }
}
