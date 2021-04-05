import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/users/profile/user_profile_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/tab_bar/custom_tab_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_linear_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_posts/profile/user/list_user_posts.dart';
import 'package:webblen_web_app/ui/widgets/user/follow_unfollow_button.dart';
import 'package:webblen_web_app/ui/widgets/user/user_profile_pic.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget head(UserProfileViewModel model) {
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

  Widget userDetails(UserProfileViewModel model) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 16),
          UserProfilePic(
            userPicUrl: model.user.profilePicURL,
            size: 60,
            isBusy: false,
          ),
          SizedBox(height: 8),
          Text(
            "@${model.user.username}",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8),
          model.isFollowingUser == null
              ? Container()
              : FollowUnfollowButton(isFollowing: model.isFollowingUser, followUnfollowAction: () => model.followUnfollowUser()),
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

  Widget body(UserProfileViewModel model) {
    return TabBarView(
      controller: _tabController,
      children: [
        //posts
        ListUserPosts(
          user: model.user,
          showPostOptions: (content) => model.webblenBaseViewModel.showContentOptions(content: content),
        ),

        //scheduled streams
        ZeroStateView(
          imageAssetName: "video_phone",
          imageSize: 200,
          header: "@${model.user.username} Has Not Scheduled Any Streams",
          subHeader: "",
          mainActionButtonTitle: null,
          mainAction: null,
          secondaryActionButtonTitle: null,
          secondaryAction: null,
          refreshData: () async {},
        ),
        ZeroStateView(
          imageAssetName: "calendar",
          imageSize: 200,
          header: "@${model.user.username} Has Not Scheduled Any Events",
          subHeader: "",
          mainActionButtonTitle: null,
          mainAction: null,
          secondaryActionButtonTitle: null,
          secondaryAction: null,
          refreshData: () async {},
        ),
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
    return ViewModelBuilder<UserProfileViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(context: context, tabController: _tabController),
      viewModelBuilder: () => UserProfileViewModel(),
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

        // CustomAppBar().basicActionAppBar(
        //   title: model.user == null ? "" : model.user.username,
        //   showBackButton: true,
        //   actionWidget: IconButton(
        //     onPressed: () => model.showUserOptions(),
        //     icon: Icon(
        //       FontAwesomeIcons.ellipsisH,
        //       size: 16,
        //       color: appIconColor(),
        //     ),
        //   ),
        // ),
        body: Container(
          height: screenHeight(context),
          width: screenWidth(context),
          color: appBackgroundColor,
          child: model.isBusy
              ? Column(
                  children: [
                    CustomLinearProgressIndicator(color: appActiveColor()),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: DefaultTabController(
                        key: null,
                        length: 4,
                        child: NestedScrollView(
                          key: null,
                          controller: model.scrollController,
                          headerSliverBuilder: (context, innerBoxIsScrolled) {
                            return [
                              SliverAppBar(
                                key: null,
                                pinned: true,
                                floating: true,
                                snap: true,
                                forceElevated: innerBoxIsScrolled,
                                expandedHeight: model.isFollowingUser == null ? 150 : 200,
                                leading: Container(),
                                backgroundColor: appBackgroundColor,
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Container(
                                    child: Column(
                                      children: [
                                        model.user == null ? Container() : userDetails(model),
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
                          body: model.isBusy ? Container() : body(model),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "user-profile-options",
          onPressed: () => model.showUserOptions(),
          backgroundColor: appActiveColor(),
          foregroundColor: Colors.white,
          mini: true,
          child: Icon(
            FontAwesomeIcons.ellipsisH,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}
