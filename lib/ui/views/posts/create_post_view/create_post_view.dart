import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/add_image_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:webblen_web_app/ui/widgets/tags/tag_button.dart';
import 'package:webblen_web_app/ui/widgets/tags/tag_dropdown_field.dart';

import 'create_post_view_model.dart';

class CreatePostView extends StatelessWidget {
  final String id;
  final double promo;

  const CreatePostView({Key key, this.id, this.promo}) : super(key: key);

  Widget selectedTags(CreatePostViewModel model) {
    return model.post.tags == null || model.post.tags.isEmpty
        ? Container()
        : Container(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: model.post.tags.length,
              itemBuilder: (BuildContext context, int index) {
                return RemovableTagButton(onTap: () => model.removeTagAtIndex(index), tag: model.post.tags[index]);
              },
            ),
          );
  }

  Widget textFieldHeader(String header, String subHeader) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            header,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
          ),
          SizedBox(height: 4),
          Text(
            subHeader,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: appFontColorAlt(),
            ),
          ),
        ],
      ),
    );
  }

  Widget imgBtn(BuildContext context, CreatePostViewModel model) {
    return ImageButton(
      onTap: () => model.selectImage(context: context),
      isOptional: true,
    );
  }

  Widget imgPreview(BuildContext context, CreatePostViewModel model) {
    return model.img == null
        ? ImagePreviewButton(
            onTap: () => model.selectImage(context: context),
            file: null,
            imgURL: model.post.imageURL,
          )
        : ImagePreviewButton(
            onTap: () => model.selectImage(context: context),
            file: model.img,
            imgURL: null,
          );
  }

  Widget form(BuildContext context, CreatePostViewModel model) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          Align(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 500,
              ),
              child: Column(
                children: [
                  CustomText(
                    text: model.isEditing ? "Edit Post" : "New Post",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: appFontColor(),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpaceMedium,

                  ///POST IMAGE
                  model.img == null && model.post.imageURL == null ? imgBtn(context, model) : imgPreview(context, model),
                  verticalSpaceMedium,

                  ///POST TAGS
                  selectedTags(model),
                  verticalSpaceMedium,

                  ///POST FIELDS
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ///POST TAGS
                        textFieldHeader(
                          "Tags",
                          "What topics are related to this post?",
                        ),
                        verticalSpaceSmall,
                        TagDropdownField(
                          enabled: model.textFieldEnabled,
                          controller: model.tagTextController,
                          onTagSelected: (tag) => model.addTag(tag),
                        ),
                        verticalSpaceMedium,

                        ///POST BODY
                        textFieldHeader(
                          "Message",
                          "What would you like to share?",
                        ),
                        verticalSpaceSmall,
                        MultiLineTextField(
                          enabled: model.textFieldEnabled,
                          controller: model.postTextController,
                          hintText: "Don't be shy...",
                          initialValue: null,
                          maxLines: null,
                        ),
                        verticalSpaceMedium,
                        CustomButton(
                          text: "Done",
                          textSize: 18,
                          height: 40,
                          width: 200,
                          onPressed: () => model.submitForm(),
                          backgroundColor: appButtonColor(),
                          textColor: appFontColor(),
                          elevation: 2,
                          isBusy: model.isBusy,
                        ),
                        verticalSpaceMassive,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appBarLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: AppBarCircleProgressIndicator(color: appActiveColor(), size: 25),
    );
  }

  Widget doneButton(CreatePostViewModel model) {
    return Padding(
      padding: EdgeInsets.only(right: 16, top: 18),
      child: CustomTextButton(
        onTap: () => model.showNewContentConfirmationBottomSheet(),
        color: appFontColor(),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        text: 'Done',
        textAlign: TextAlign.right,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreatePostViewModel>.reactive(
      onModelReady: (model) => model.initialize(context: context),
      viewModelBuilder: () => CreatePostViewModel(),
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
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: screenHeight(context),
            width: screenWidth(context),
            color: appBackgroundColor,
            child: form(context, model),
          ),
        ),
      ),
    );
  }
}
