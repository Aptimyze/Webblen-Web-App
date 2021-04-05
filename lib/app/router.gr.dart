// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/views/auth/auth_view.dart';
import '../ui/views/base/webblen_base_view.dart';
import '../ui/views/live_streams/create_live_stream_view/create_live_stream_view.dart';
import '../ui/views/live_streams/live_stream_details_view/live_stream_details_view.dart';
import '../ui/views/posts/create_post_view/create_post_view.dart';
import '../ui/views/posts/post_view/post_view.dart';
import '../ui/views/search/all_search_results/all_search_results_view.dart';
import '../ui/views/users/edit_profile/edit_profile_view.dart';
import '../ui/views/users/followers/user_followers_view.dart';
import '../ui/views/users/following/user_following_view.dart';
import '../ui/views/users/profile/user_profile_view.dart';

class Routes {
  static const String AuthViewRoute = '/login';
  static const String WebblenBaseViewRoute = '/';
  static const String _PostViewRoute = '/post/:id';
  static String PostViewRoute({@required dynamic id}) => '/post/$id';
  static const String _CreatePostViewRoute = '/post/new/:id/:promo';
  static String CreatePostViewRoute(
          {@required dynamic id, @required dynamic promo}) =>
      '/post/new/$id/$promo';
  static const String _LiveStreamViewRoute = '/stream/:id';
  static String LiveStreamViewRoute({@required dynamic id}) => '/stream/$id';
  static const String _CreateLiveStreamViewRoute = '/stream/new/:id/:promo';
  static String CreateLiveStreamViewRoute(
          {@required dynamic id, @required dynamic promo}) =>
      '/stream/new/$id/$promo';
  static const String _AllSearchResultsViewRoute = '/all_results/:term';
  static String AllSearchResultsViewRoute({@required dynamic term}) =>
      '/all_results/$term';
  static const String _UserProfileView = '/profile/:id';
  static String UserProfileView({@required dynamic id}) => '/profile/$id';
  static const String EditProfileViewRoute = '/profile/edit';
  static const String _UserFollowersViewRoute = '/profile/followers/:id';
  static String UserFollowersViewRoute({@required dynamic id}) =>
      '/profile/followers/$id';
  static const String _UserFollowingViewRoute = '/profile/following/:id';
  static String UserFollowingViewRoute({@required dynamic id}) =>
      '/profile/following/$id';
  static const all = <String>{
    AuthViewRoute,
    WebblenBaseViewRoute,
    _PostViewRoute,
    _CreatePostViewRoute,
    _LiveStreamViewRoute,
    _CreateLiveStreamViewRoute,
    _AllSearchResultsViewRoute,
    _UserProfileView,
    EditProfileViewRoute,
    _UserFollowersViewRoute,
    _UserFollowingViewRoute,
  };
}

class WebblenRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.AuthViewRoute, page: AuthView),
    RouteDef(Routes.WebblenBaseViewRoute, page: WebblenBaseView),
    RouteDef(Routes._PostViewRoute, page: PostView),
    RouteDef(Routes._CreatePostViewRoute, page: CreatePostView),
    RouteDef(Routes._LiveStreamViewRoute, page: LiveStreamDetailsView),
    RouteDef(Routes._CreateLiveStreamViewRoute, page: CreateLiveStreamView),
    RouteDef(Routes._AllSearchResultsViewRoute, page: AllSearchResultsView),
    RouteDef(Routes._UserProfileView, page: UserProfileView),
    RouteDef(Routes.EditProfileViewRoute, page: EditProfileView),
    RouteDef(Routes._UserFollowersViewRoute, page: UserFollowersView),
    RouteDef(Routes._UserFollowingViewRoute, page: UserFollowingView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    AuthView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    WebblenBaseView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            WebblenBaseView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    PostView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => PostView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    CreatePostView: (data) {
      final args = data.getArgs<CreatePostViewArguments>(
        orElse: () => CreatePostViewArguments(),
      );
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => CreatePostView(
          key: args.key,
          id: args.id,
          promo: args.promo,
        ),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    LiveStreamDetailsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LiveStreamDetailsView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    CreateLiveStreamView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateLiveStreamView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    AllSearchResultsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AllSearchResultsView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    UserProfileView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UserProfileView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    EditProfileView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditProfileView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    UserFollowersView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UserFollowersView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    UserFollowingView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UserFollowingView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// CreatePostView arguments holder class
class CreatePostViewArguments {
  final Key key;
  final String id;
  final double promo;
  CreatePostViewArguments({this.key, this.id, this.promo});
}