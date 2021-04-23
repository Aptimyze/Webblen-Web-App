import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/add_image_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/text_field/single_line_text_field.dart';

import 'edit_profile_view_model.dart';

class EditProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => EditProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: CustomTopNavBar(
            navBarItems: [
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(0),
                iconData: FontAwesomeIcons.home,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(1),
                iconData: FontAwesomeIcons.search,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(2),
                iconData: FontAwesomeIcons.wallet,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(3),
                iconData: FontAwesomeIcons.user,
                isActive: false,
              ),
            ],
          ),
        ),
        body: Container(
          height: screenHeight(context),
          color: appBackgroundColor,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Align(
                alignment: getValueForScreenType(context: context, mobile: Alignment.topCenter, desktop: Alignment.center, tablet: Alignment.center),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  constraints: BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      verticalSpaceMedium,

                      ///IMAGE
                      _ImagePreview(
                        selectImage: () => model.selectImage(),
                        fileToUploadByteMemory: model.fileToUploadByteMemory,
                        imageURL: model.user.profilePicURL,
                      ),

                      verticalSpaceSmall,
                      Align(
                        child: GestureDetector(
                          onTap: () => model.selectImage(),
                          child: CustomText(
                            text: "Change Profile Pic",
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: appTextButtonColor(),
                          ),
                        ),
                      ),
                      verticalSpaceMedium,
                      CustomText(
                        text: "Username",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appFontColor(),
                      ),
                      verticalSpaceSmall,
                      SingleLineTextField(
                        controller: model.usernameTextController,
                        hintText: "Username",
                        textLimit: 50,
                        isPassword: false,
                      ),
                      verticalSpaceMedium,

                      CustomText(
                        text: "Short Bio",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appFontColor(),
                      ),
                      verticalSpaceSmall,
                      SingleLineTextField(
                        controller: model.bioTextController,
                        hintText: "What are you about?",
                        textLimit: 50,
                        isPassword: false,
                      ),
                      verticalSpaceMedium,
                      CustomText(
                        text: "Website",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appFontColor(),
                      ),
                      verticalSpaceSmall,
                      SingleLineTextField(
                        controller: model.websiteTextController,
                        hintText: "https://mysite.com",
                        isPassword: false,
                        textLimit: null,
                      ),
                      verticalSpaceLarge,
                      CustomButton(
                        text: "Update",
                        textSize: 14,
                        height: 30,
                        width: screenWidth(context),
                        onPressed: () => model.updateProfile(),
                        backgroundColor: appButtonColor(),
                        textColor: appFontColor(),
                        elevation: 1,
                        isBusy: model.updatingData,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final VoidCallback selectImage;
  final Uint8List? fileToUploadByteMemory;
  final String? imageURL;
  _ImagePreview({required this.selectImage, this.fileToUploadByteMemory, this.imageURL});

  @override
  Widget build(BuildContext context) {
    return fileToUploadByteMemory!.isEmpty
        ? UserProfilePicButtonPreview(
            onTap: selectImage,
            imgByteMemory: null,
            imgURL: imageURL,
          )
        : UserProfilePicButtonPreview(
            onTap: selectImage,
            imgByteMemory: fileToUploadByteMemory,
            imgURL: null,
          );
  }
}
