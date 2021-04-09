import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';

import 'add_content_successful_bottom_sheet_model.dart';

class AddContentSuccessfulBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const AddContentSuccessfulBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddContentSuccessfulBottomSheetModel>.nonReactive(
      viewModelBuilder: () => AddContentSuccessfulBottomSheetModel(),
      builder: (context, model, child) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: appBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpaceSmall,
              CustomText(
                text: request!.title,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: appFontColor(),
              ),
              verticalSpaceTiny,
              CustomText(
                text: "Don't Forget to Share it!",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: appFontColorAlt(),
              ),
              verticalSpaceMedium,
              CustomTextButton(
                onTap: () => model.shareContentLink(request!.customData),
                text: "Share",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: appTextButtonColor(),
              ).showCursorOnHover,
              verticalSpaceMedium,
              CustomTextButton(
                onTap: () => model.copyContentLink(request!.customData),
                text: "Copy Link",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: appTextButtonColor(),
              ).showCursorOnHover,
              verticalSpaceMedium,
              CustomButton(
                onPressed: () => completer!(SheetResponse(responseData: "done")),
                text: "Done",
                textSize: 16,
                textColor: appFontColor(),
                height: 45,
                width: screenWidth(context),
                backgroundColor: appButtonColorAlt(),
                elevation: 1.0,
                isBusy: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
