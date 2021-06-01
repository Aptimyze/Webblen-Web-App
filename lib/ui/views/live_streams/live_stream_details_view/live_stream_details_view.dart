import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/live_streams/live_stream_details_view/live_stream_details_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text_with_links.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/notices/app_required/app_required_block_view.dart';
import 'package:webblen_web_app/ui/widgets/tags/tag_button.dart';
import 'package:webblen_web_app/ui/widgets/user/user_profile_pic.dart';

class LiveStreamDetailsView extends StatelessWidget {
  final String? id;
  LiveStreamDetailsView(@PathParam() this.id);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveStreamDetailsViewModel>.reactive(
      onModelReady: (model) => model.initialize(id),
      viewModelBuilder: () => LiveStreamDetailsViewModel(),
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
          child: model.isBusy
              ? Container()
              : Stack(
                  children: [
                    RefreshIndicator(
                      backgroundColor: appBackgroundColor,
                      onRefresh: () async {},
                      child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: null,
                        shrinkWrap: true,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 500,
                              ),
                              child: Column(
                                children: [
                                  _Body(),
                                  SizedBox(height: 50),
                                  SizedBox(height: 80),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: model.isBusy ? Container() : _AppRequiredNotice(),
      ),
    );
  }
}

class _SectionDivider extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  final String sectionName;
  _SectionDivider({required this.sectionName});

  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            sectionName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: appFontColorAlt(),
            ),
          ),
          verticalSpaceTiny,
        ],
      ),
    );
  }
}

class _Head extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () => model.navigateToUserView(model.host!.id),
            child: Row(
              children: <Widget>[
                UserProfilePic(
                  isBusy: false,
                  userPicUrl: model.host!.profilePicURL,
                  size: 35,
                ),
                horizontalSpaceSmall,
                Text(
                  "@${model.host!.username}",
                  style: TextStyle(color: appFontColor(), fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          model.streamIsLive
              ? Container(
                  width: 120,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: appActiveColor(),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                      "LIVE",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () => model.customBottomSheetService.showContentOptions(content: model.stream),
                  icon: Icon(
                    FontAwesomeIcons.ellipsisH,
                    size: 16,
                    color: appIconColor(),
                  ),
                ).showCursorOnHover,
        ],
      ),
    );
  }
}

class _AppRequiredNotice extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    return AppRequiredBlock(content: model.stream!);
  }
}

class _Image extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    return FadeInImage.memoryNetwork(
      image: model.stream!.imageURL!,
      fit: BoxFit.cover,
      placeholder: kTransparentImage,
    );
  }
}

class _Tags extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    return model.stream!.tags == null || model.stream!.tags!.isEmpty
        ? Container()
        : Container(
            margin: EdgeInsets.only(top: 4, bottom: 8, left: 16, right: 16),
            height: 30,
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 4.0,
                bottom: 4.0,
              ),
              itemCount: model.stream!.tags!.length,
              itemBuilder: (context, index) {
                return TagButton(
                  onTap: null,
                  tag: model.stream!.tags![index],
                );
              },
            ),
          );
  }
}

class _Description extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    List<TextSpan> linkifiedText = [];

    linkifiedText.addAll(linkify(text: model.stream!.description!.trim(), fontSize: 16));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        text: TextSpan(
          children: linkifiedText,
        ),
      ),
    );
  }
}

class _DateAndTime extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "${model.stream!.startDate} | ${model.stream!.startTime} - ${model.stream!.endTime} ${model.stream!.timezone}",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: appFontColor(),
          ),
        ],
      ),
    );
  }
}

class _Location extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: model.stream!.city,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: appFontColor(),
          ),
          verticalSpaceTiny,
          CustomTextButton(
            onTap: () => model.openMaps(),
            text: "View in Maps",
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: appTextButtonColor(),
          ).showCursorOnHover,
        ],
      ),
    );
  }
}

class _SocialAccounts extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceTiny,
          Row(
            children: [
              model.stream!.fbUsername == null || model.stream!.fbUsername!.isEmpty
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => model.openFacebook(),
                        child: Icon(
                          FontAwesomeIcons.facebook,
                          size: 20,
                          color: appIconColor(),
                        ),
                      ).showCursorOnHover,
                    ),
              model.stream!.instaUsername == null || model.stream!.instaUsername!.isEmpty
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => model.openInstagram(),
                        child: Icon(
                          FontAwesomeIcons.instagram,
                          size: 20,
                          color: appIconColor(),
                        ),
                      ).showCursorOnHover,
                    ),
              model.stream!.twitterUsername == null || model.stream!.twitterUsername!.isEmpty
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => model.openTwitter(),
                        child: Icon(
                          FontAwesomeIcons.twitter,
                          size: 20,
                          color: appIconColor(),
                        ),
                      ).showCursorOnHover,
                    ),
              model.stream!.website == null || model.stream!.website!.isEmpty
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => model.openWebsite(),
                        child: Icon(
                          FontAwesomeIcons.link,
                          size: 20,
                          color: appIconColor(),
                        ),
                      ).showCursorOnHover,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Body extends HookViewModelWidget<LiveStreamDetailsViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, LiveStreamDetailsViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          verticalSpaceSmall,
          _Head(),
          verticalSpaceSmall,
          _Image(),
          _Tags(),
          verticalSpaceSmall,
          _SectionDivider(sectionName: "Details"),
          _Description(),
          verticalSpaceMedium,
          _SectionDivider(sectionName: "Date & Time"),
          _DateAndTime(),
          verticalSpaceMedium,
          _SectionDivider(sectionName: "Location"),
          _Location(),
          verticalSpaceMedium,
          model.hasSocialAccounts ? _SectionDivider(sectionName: "Social Accounts & Websites") : Container(),
          _SocialAccounts(),
          verticalSpaceMedium,
        ],
      ),
    );
  }
}
