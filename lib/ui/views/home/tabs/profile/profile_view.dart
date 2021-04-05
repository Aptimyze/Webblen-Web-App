import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/home/tabs/profile/profile_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/tab_bar/custom_tab_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_events/list_events.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_live_streams/list_streams.dart';
import 'package:webblen_web_app/ui/widgets/user/follow_stats_row.dart';
import 'package:webblen_web_app/ui/widgets/user/user_profile_pic.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget head(ProfileViewModel model) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Profile",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => model.showUserOptions(),
                icon: Icon(
                  FontAwesomeIcons.ellipsisH,
                  color: appIconColor(),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget userBioAndWebsite(ProfileViewModel model) {
    return Container(
      child: Column(
        children: [
          model.webblenBaseViewModel.user.bio != null && model.webblenBaseViewModel.user.bio.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 4),
                  child: CustomText(
                    text: model.webblenBaseViewModel.user.bio,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: appFontColor(),
                  ),
                )
              : Container(),
          model.webblenBaseViewModel.user.website != null && model.webblenBaseViewModel.user.website.isNotEmpty
              ? GestureDetector(
                  onTap: () => model.openWebsite(),
                  child: Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.link,
                          size: 12,
                          color: appFontColor(),
                        ),
                        horizontalSpaceTiny,
                        CustomText(
                          text: model.webblenBaseViewModel.user.website,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: appFontColor(),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget userDetails(ProfileViewModel model) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 16),
          UserProfilePic(
            userPicUrl: model.webblenBaseViewModel.user.profilePicURL,
            size: 60,
            isBusy: false,
          ),
          SizedBox(height: 8),
          Text(
            "@${model.webblenBaseViewModel.user.username}",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          verticalSpaceSmall,
          FollowStatsRow(
            followersLength: model.webblenBaseViewModel.user.followers.length,
            followingLength: model.webblenBaseViewModel.user.following.length,
            viewFollowersAction: () => model.navigateToUserFollowersView(),
            viewFollowingAction: () => model.navigateToUserFollowingView(),
          ),
          verticalSpaceSmall,
          userBioAndWebsite(model),
        ],
      ),
    );
  }

  Widget tabBar() {
    return WebblenProfileTabBar(
      //key: PageStorageKey('profile-tab-bar'),
      tabController: _tabController,
    );
  }

  Widget body(ProfileViewModel model) {
    return TabBarView(
      controller: _tabController,
      children: [
        //posts
        // model.postResults.isEmpty && !model.isBusy
        //     ?
        ZeroStateView(
          imageAssetName: "umbrella_chair",
          imageSize: 200,
          header: "You Have No Posts",
          subHeader: "Create a New Post to Share with the Community",
          mainActionButtonTitle: "Create Post",
          mainAction: () => model.webblenBaseViewModel.navigateToCreatePostPage(),
          secondaryActionButtonTitle: null,
          secondaryAction: null,
          refreshData: model.refreshPosts,
        ),
        // : ListPosts(
        //     pageStorageKey: PageStorageKey('profile-posts'),
        //     showPostOptions: (post) => model.showContentOptions(content: post),
        //   ),

        //scheduled streams
        model.streamResults.isEmpty && !model.reloadingStreams
            ? ZeroStateView(
                imageAssetName: "video_phone",
                imageSize: 200,
                header: "You Have Not Scheduled Any Streams",
                subHeader: "Find Your Audience and Create a Stream",
                mainActionButtonTitle: "Create Stream",
                mainAction: () => model.webblenBaseViewModel.navigateToCreateStreamPage(),
                secondaryActionButtonTitle: null,
                secondaryAction: null,
                refreshData: () async {},
              )
            : ListLiveStreams(
                refreshData: model.refreshEvents,
                dataResults: model.streamResults,
                pageStorageKey: PageStorageKey('home-events'),
                showStreamOptions: (stream) => model.showContentOptions(content: stream),
              ),
        model.eventResults.isEmpty && !model.reloadingEvents
            ? ZeroStateView(
                imageAssetName: "calendar",
                imageSize: 200,
                header: "You Have Not Scheduled Any Events",
                subHeader: "Create an Event for the Community",
                mainActionButtonTitle: "Create Event",
                mainAction: () => model.webblenBaseViewModel.navigateToCreateEventPage(),
                secondaryActionButtonTitle: null,
                secondaryAction: null,
                refreshData: () async {},
                scrollController: null,
              )
            : ListEvents(
                refreshData: model.refreshEvents,
                dataResults: model.eventResults,
                pageStorageKey: PageStorageKey('profile-events'),
                scrollController: null,
                showEventOptions: (event) => model.showContentOptions(content: event),
              ),
        // ZeroStateView(
        //   imageAssetName: null,
        //   header: "You Have No Recent Activity",
        //   subHeader: "Get Involved in Your Community to Change That!",
        //   mainActionButtonTitle: null,
        //   mainAction: null,
        //   secondaryActionButtonTitle: null,
        //   secondaryAction: null,
        //   refreshData: () async {},
        // ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, //4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(context: context, tabController: _tabController),
      viewModelBuilder: () => locator<ProfileViewModel>(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
        color: appBackgroundColor,
        child: SafeArea(
          child: Container(
            child: model.webblenBaseViewModel.user == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "You are not logged in",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: appFontColor(),
                        ),
                        CustomText(
                          text: "Please log in to view your profile",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appFontColor(),
                        ),
                        verticalSpaceMedium,
                        CustomButton(
                          text: "Log In",
                          textSize: 16,
                          height: 30,
                          width: 200,
                          onPressed: () => model.webblenBaseViewModel.navigateToAuthView(),
                          backgroundColor: appBackgroundColor,
                          textColor: appFontColor(),
                          elevation: 1.0,
                          isBusy: false,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      head(model),
                      Expanded(
                        child: DefaultTabController(
                          key: PageStorageKey('profile-tab-bar'),
                          length: 4,
                          child: NestedScrollView(
                            key: PageStorageKey('profile-nested-scroll-key'),
                            controller: model.scrollController,
                            headerSliverBuilder: (context, innerBoxIsScrolled) {
                              return [
                                SliverAppBar(
                                  key: PageStorageKey('profile-app-bar-key'),
                                  pinned: true,
                                  floating: true,
                                  snap: true,
                                  forceElevated: innerBoxIsScrolled,
                                  expandedHeight: (model.webblenBaseViewModel.user.bio == null || model.webblenBaseViewModel.user.bio.isEmpty) &&
                                          (model.webblenBaseViewModel.user.website == null || model.webblenBaseViewModel.user.website.isEmpty)
                                      ? 200
                                      : 250,
                                  backgroundColor: appBackgroundColor,
                                  flexibleSpace: FlexibleSpaceBar(
                                    background: Container(
                                      child: Column(
                                        children: [
                                          model.webblenBaseViewModel.user == null ? Container() : userDetails(model),
                                        ],
                                      ),
                                    ),
                                  ),
                                  bottom: PreferredSize(
                                    preferredSize: Size.fromHeight(40),
                                    child: tabBar(),
                                  ),
                                ),
                              ];
                            },
                            body: body(model),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
