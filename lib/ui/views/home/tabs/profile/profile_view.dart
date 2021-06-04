import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/home/tabs/profile/profile_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/tab_bar/custom_tab_bar.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_events/profile/list_profile_events.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_live_streams/profile/list_profile_live_streams.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_posts/profile/list_profile_posts.dart';
import 'package:webblen_web_app/ui/widgets/user/follow_stats_row.dart';
import 'package:webblen_web_app/ui/widgets/user/user_profile_pic.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Container(
        height: screenHeight(context),
        color: appBackgroundColor,
        child: SafeArea(
          child: Container(
            child: !model.isLoggedIn
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
                          onPressed: () => model.navigateToAuthView(),
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
                      _ProfileHead(
                        showOptions: () => model.showOptions(),
                      ),
                      _ProfileBody(
                        user: model.user,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHead extends StatelessWidget {
  final VoidCallback showOptions;
  const _ProfileHead({required this.showOptions});

  @override
  Widget build(BuildContext context) {
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
                onPressed: showOptions,
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
}

class _ProfileBody extends HookViewModelWidget<ProfileViewModel> {
  final WebblenUser user;
  _ProfileBody({required this.user});

  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    var _scrollController = useScrollController();
    var _tabController = useTabController(initialLength: 3);

    return Expanded(
      child: DefaultTabController(
        key: PageStorageKey('profile-tab-bar'),
        length: 4,
        child: NestedScrollView(
          key: PageStorageKey('profile-nested-scroll-key'),
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                key: PageStorageKey('profile-app-bar-key'),
                pinned: true,
                floating: true,
                snap: true,
                forceElevated: innerBoxIsScrolled,
                expandedHeight: ((user.bio?.isNotEmpty ?? true) || (user.website?.isNotEmpty ?? true)) ? 225 : 250,
                backgroundColor: appBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    child: Column(
                      children: [
                        _UserDetails(
                          user: user,
                          followerCount: user.followers!.length,
                          followingCount: user.following!.length,
                          viewFollowers: () => model.navigateToFollowers(),
                          viewFollowing: () => model.navigateToFollowing(),
                          viewWebsite: () => model.openWebsite(),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: WebblenProfileTabBar(
                    //key: PageStorageKey('profile-tab-bar'),
                    tabController: _tabController,
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              //posts
              ListProfilePosts(
                id: model.user.id!,
                isCurrentUser: true,
                scrollController: _scrollController,
              ),

              //scheduled streams
              ListProfileLiveStreams(
                id: model.user.id!,
                isCurrentUser: true,
                scrollController: _scrollController,
              ),

              //scheduled streams
              ListProfileEvents(
                id: model.user.id!,
                isCurrentUser: true,
                scrollController: _scrollController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserDetails extends StatelessWidget {
  final WebblenUser user;
  final int followerCount;
  final int followingCount;
  final VoidCallback viewFollowers;
  final VoidCallback viewFollowing;
  final VoidCallback viewWebsite;
  _UserDetails({
    required this.user,
    required this.followerCount,
    required this.followingCount,
    required this.viewFollowers,
    required this.viewFollowing,
    required this.viewWebsite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 16),

          ///USERNAME & PROFILE
          UserProfilePic(
            userPicUrl: user.profilePicURL,
            size: 60,
            isBusy: false,
          ),
          SizedBox(height: 8),
          Text(
            "@${user.username}",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          verticalSpaceSmall,

          ///FOLOWERS & FOLLOWING
          FollowStatsRow(
            followersLength: followerCount,
            followingLength: followingCount,
            viewFollowersAction: viewFollowers,
            viewFollowingAction: viewFollowing,
          ),
          verticalSpaceSmall,

          ///BIO & WEBSITE
          Container(
            child: Column(
              children: [
                user.bio != null && user.bio!.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(top: 4),
                        child: CustomText(
                          text: user.bio,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: appFontColor(),
                        ),
                      )
                    : Container(),
                user.website != null && user.website!.isNotEmpty
                    ? GestureDetector(
                        onTap: viewWebsite,
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
                                text: user.website,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: appFontColor(),
                              ),
                            ],
                          ),
                        ),
                      ).showCursorOnHover
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
