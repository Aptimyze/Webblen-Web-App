import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:webblen_web_app/ui/views/auth/auth_view.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view.dart';
import 'package:webblen_web_app/ui/views/live_streams/create_live_stream_view/create_live_stream_view.dart';
import 'package:webblen_web_app/ui/views/live_streams/live_stream_details_view/live_stream_details_view.dart';
import 'package:webblen_web_app/ui/views/posts/create_post_view/create_post_view.dart';
import 'package:webblen_web_app/ui/views/posts/post_view/post_view.dart';
import 'package:webblen_web_app/ui/views/search/all_search_results/all_search_results_view.dart';
import 'package:webblen_web_app/ui/views/users/edit_profile/edit_profile_view.dart';
import 'package:webblen_web_app/ui/views/users/followers/user_followers_view.dart';
import 'package:webblen_web_app/ui/views/users/following/user_following_view.dart';
import 'package:webblen_web_app/ui/views/users/profile/user_profile_view.dart';

///RUN "flutter pub run build_runner build --delete-conflicting-outputs" in Project Terminal to Generate Routes

@MaterialAutoRouter(
  routes: <AutoRoute>[
    //AUTHENTICATION
    CustomRoute(
      page: AuthView,
      name: "AuthViewRoute",
      path: "/login",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    //ONBOARDING
    // MaterialRoute(page: OnboardingView, name: "OnboardingViewRoute"),

    //HOME
    CustomRoute(
      page: WebblenBaseView,
      initial: true,
      name: "WebblenBaseViewRoute",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    //POST
    CustomRoute(
      page: PostView,
      name: "PostViewRoute",
      path: "/post/:id",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: CreatePostView,
      name: "CreatePostViewRoute",
      path: "/post/new/:id/:promo",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    // //EVENT
    // MaterialRoute(page: EventView, name: "EventViewRoute"),
    // MaterialRoute(page: CreateEventView, name: "CreateEventViewRoute"),
    //
    // //STREAM
    CustomRoute(
      page: LiveStreamDetailsView,
      name: "LiveStreamViewRoute",
      path: "/stream/:id",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: CreateLiveStreamView,
      name: "CreateLiveStreamViewRoute",
      path: "/stream/new/:id/:promo",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    // //SEARCH
    CustomRoute(
      page: AllSearchResultsView,
      name: "AllSearchResultsViewRoute",
      path: "/all_results/:term",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    //
    // //NOTIFICATIONS
    // MaterialRoute(page: NotificationsView, name: "NotificationsViewRoute"),
    //
    //USER PROFILE & SETTINGS
    CustomRoute(
      page: UserProfileView,
      name: "UserProfileView",
      path: "/profile/:id",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: EditProfileView,
      name: "EditProfileViewRoute",
      path: "/profile/edit",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: UserFollowersView,
      name: "UserFollowersViewRoute",
      path: "/profile/followers/:id",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: UserFollowingView,
      name: "UserFollowingViewRoute",
      path: "/profile/following/:id",
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    //CustomRoute(page: SettingsView, name: "SettingsViewRoute"),
    //
    // //WALLET
    // MaterialRoute(page: RedeemedRewardsView, name: 'RedeemedRewardsViewRoute'),
  ],
)
class $WebblenRouter {}
