import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';

import 'post_author_bottom_sheet_model.dart';

class PostAuthorBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const PostAuthorBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostAuthorBottomSheetModel>.nonReactive(
      viewModelBuilder: () => PostAuthorBottomSheetModel(),
      builder: (context, model, child) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomButton(
                onPressed: () => completer!(SheetResponse(responseData: "edit")),
                text: "Edit",
                textSize: 16,
                textColor: appFontColor(),
                height: 45,
                width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
                backgroundColor: appBackgroundColor,
                elevation: 1.0,
                isBusy: false,
              ),
              verticalSpaceSmall,
              CustomButton(
                onPressed: () => completer!(SheetResponse(responseData: "share")),
                text: "Share",
                textSize: 16,
                textColor: appFontColor(),
                height: 45,
                width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
                backgroundColor: appBackgroundColor,
                elevation: 1.0,
                isBusy: false,
              ),
              verticalSpaceSmall,
              CustomButton(
                onPressed: () => completer!(SheetResponse(responseData: "delete")),
                text: "Delete",
                textSize: 16,
                textColor: appDestructiveColor(),
                height: 45,
                width: getValueForScreenType(context: context, mobile: screenWidth(context), tablet: 600, desktop: 700),
                backgroundColor: appBackgroundColor,
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
