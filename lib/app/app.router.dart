// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/views/auth/auth_view.dart';
import '../ui/views/base/webblen_base_view.dart';
import '../ui/views/earnings/how_earnings_work/how_earnings_work_view.dart';
import '../ui/views/earnings/payout_methods/payout_methods_view.dart';
import '../ui/views/earnings/set_up_direct_deposit/set_up_direct_deposit_view.dart';
import '../ui/views/earnings/set_up_instant_deposit/set_up_instant_deposit_view.dart';
import '../ui/views/earnings/usd_balance_history/usd_balance_history_view.dart';
import '../ui/views/events/create_event_view/create_event_view.dart';
import '../ui/views/events/event_view/event_details_view.dart';
import '../ui/views/events/tickets/event_tickets/event_tickets_view.dart';
import '../ui/views/events/tickets/my_tickets/my_tickets_view.dart';
import '../ui/views/events/tickets/ticket_details/ticket_details_view.dart';
import '../ui/views/events/tickets/ticket_purchase/ticket_purchase_view.dart';
import '../ui/views/events/tickets/ticket_selection/ticket_selection_view.dart';
import '../ui/views/events/tickets/tickets_purchase_success/tickets_purchase_success_view.dart';
import '../ui/views/live_streams/create_live_stream_view/create_live_stream_view.dart';
import '../ui/views/live_streams/live_stream_details_view/live_stream_details_view.dart';
import '../ui/views/notifications/notifications_view.dart';
import '../ui/views/onboarding/event_host_path/event_host_path_view.dart';
import '../ui/views/onboarding/explorer_path/explorer_path_view.dart';
import '../ui/views/onboarding/onboarding_complete/onboarding_complete_view.dart';
import '../ui/views/onboarding/path_select/onboarding_path_select_view.dart';
import '../ui/views/onboarding/streamer_path/streamer_path_view.dart';
import '../ui/views/posts/create_post_view/create_post_view.dart';
import '../ui/views/posts/post_view/post_view.dart';
import '../ui/views/search/all_search_results/all_search_results_view.dart';
import '../ui/views/users/edit_profile/edit_profile_view.dart';
import '../ui/views/users/followers/user_followers_view.dart';
import '../ui/views/users/following/user_following_view.dart';
import '../ui/views/users/profile/user_profile_view.dart';
import '../ui/views/users/saved/saved_content_view.dart';

class Routes {
  static const String AuthViewRoute = '/login';
  static const String OnboardingPathSelectViewRoute = '/onboarding/path_select';
  static const String EventHostPathViewRoute = '/onboarding/event_host';
  static const String StreamerPathViewRoute = '/onboarding/streamer';
  static const String ExplorerPathViewRoute = '/onboarding/explorer';
  static const String OnboardingCompleteViewRoute = '/onboarding/completed';
  static const String WebblenBaseViewRoute = '/';
  static const String _PostViewRoute = '/posts/:id';
  static String PostViewRoute({@required dynamic id}) => '/posts/$id';
  static const String _CreatePostViewRoute = '/post/publish/:id/:promo';
  static String CreatePostViewRoute(
          {@required dynamic id, @required dynamic promo}) =>
      '/post/publish/$id/$promo';
  static const String _EventDetailsViewRoute = '/events/:id';
  static String EventDetailsViewRoute({@required dynamic id}) => '/events/$id';
  static const String _CreateEventViewRoute = '/event/publish/:id/:promo';
  static String CreateEventViewRoute(
          {@required dynamic id, @required dynamic promo}) =>
      '/event/publish/$id/$promo';
  static const String _LiveStreamViewRoute = '/streams/:id';
  static String LiveStreamViewRoute({@required dynamic id}) => '/streams/$id';
  static const String _CreateLiveStreamViewRoute = '/stream/publish/:id/:promo';
  static String CreateLiveStreamViewRoute(
          {@required dynamic id, @required dynamic promo}) =>
      '/stream/publish/$id/$promo';
  static const String _TicketSelectionViewRoute = '/tickets/select/:id';
  static String TicketSelectionViewRoute({@required dynamic id}) =>
      '/tickets/select/$id';
  static const String _TicketPurchaseViewRoute =
      '/tickets/purchase/:id/:ticketsToPurchase';
  static String TicketPurchaseViewRoute(
          {@required dynamic id, @required dynamic ticketsToPurchase}) =>
      '/tickets/purchase/$id/$ticketsToPurchase';
  static const String _AllSearchResultsViewRoute = '/all_results/:term';
  static String AllSearchResultsViewRoute({@required dynamic term}) =>
      '/all_results/$term';
  static const String NotificationsViewRoute = '/notifications';
  static const String _UserProfileView = '/profiles/:id';
  static String UserProfileView({@required dynamic id}) => '/profiles/$id';
  static const String EditProfileViewRoute = '/edit_profile';
  static const String SavedContentViewRoute = '/saved';
  static const String _UserFollowersViewRoute = '/profile/followers/:id';
  static String UserFollowersViewRoute({@required dynamic id}) =>
      '/profile/followers/$id';
  static const String _UserFollowingViewRoute = '/profile/following/:id';
  static String UserFollowingViewRoute({@required dynamic id}) =>
      '/profile/following/$id';
  static const String MyTicketsViewRoute = '/wallet/my_tickets';
  static const String _EventTicketsViewRoute = '/wallet/my_tickets/event/:id';
  static String EventTicketsViewRoute({@required dynamic id}) =>
      '/wallet/my_tickets/event/$id';
  static const String _TicketDetailsViewRoute = '/tickets/view/:id';
  static String TicketDetailsViewRoute({@required dynamic id}) =>
      '/tickets/view/$id';
  static const String _TicketsPurchaseSuccessViewRoute =
      '/ticket_purchase_success/:email';
  static String TicketsPurchaseSuccessViewRoute({@required dynamic email}) =>
      '/ticket_purchase_success/$email';
  static const String USDBalanceHistoryViewRoute = '/usd-balance-history';
  static const String PayoutMethodsViewRoute = '/payout-methods';
  static const String HowEarningsWorkViewRoute = '/how-earnings-work';
  static const String SetUpDirectDepositViewRoute = '/setup-direct-deposit';
  static const String SetUpInstantDepositViewRoute = '/setup-instant-deposit';
  static const all = <String>{
    AuthViewRoute,
    OnboardingPathSelectViewRoute,
    EventHostPathViewRoute,
    StreamerPathViewRoute,
    ExplorerPathViewRoute,
    OnboardingCompleteViewRoute,
    WebblenBaseViewRoute,
    _PostViewRoute,
    _CreatePostViewRoute,
    _EventDetailsViewRoute,
    _CreateEventViewRoute,
    _LiveStreamViewRoute,
    _CreateLiveStreamViewRoute,
    _TicketSelectionViewRoute,
    _TicketPurchaseViewRoute,
    _AllSearchResultsViewRoute,
    NotificationsViewRoute,
    _UserProfileView,
    EditProfileViewRoute,
    SavedContentViewRoute,
    _UserFollowersViewRoute,
    _UserFollowingViewRoute,
    MyTicketsViewRoute,
    _EventTicketsViewRoute,
    _TicketDetailsViewRoute,
    _TicketsPurchaseSuccessViewRoute,
    USDBalanceHistoryViewRoute,
    PayoutMethodsViewRoute,
    HowEarningsWorkViewRoute,
    SetUpDirectDepositViewRoute,
    SetUpInstantDepositViewRoute,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.AuthViewRoute, page: AuthView),
    RouteDef(Routes.OnboardingPathSelectViewRoute,
        page: OnboardingPathSelectView),
    RouteDef(Routes.EventHostPathViewRoute, page: EventHostPathView),
    RouteDef(Routes.StreamerPathViewRoute, page: StreamerPathView),
    RouteDef(Routes.ExplorerPathViewRoute, page: ExplorerPathView),
    RouteDef(Routes.OnboardingCompleteViewRoute, page: OnboardingCompleteView),
    RouteDef(Routes.WebblenBaseViewRoute, page: WebblenBaseView),
    RouteDef(Routes._PostViewRoute, page: PostView),
    RouteDef(Routes._CreatePostViewRoute, page: CreatePostView),
    RouteDef(Routes._EventDetailsViewRoute, page: EventDetailsView),
    RouteDef(Routes._CreateEventViewRoute, page: CreateEventView),
    RouteDef(Routes._LiveStreamViewRoute, page: LiveStreamDetailsView),
    RouteDef(Routes._CreateLiveStreamViewRoute, page: CreateLiveStreamView),
    RouteDef(Routes._TicketSelectionViewRoute, page: TicketSelectionView),
    RouteDef(Routes._TicketPurchaseViewRoute, page: TicketPurchaseView),
    RouteDef(Routes._AllSearchResultsViewRoute, page: AllSearchResultsView),
    RouteDef(Routes.NotificationsViewRoute, page: NotificationsView),
    RouteDef(Routes._UserProfileView, page: UserProfileView),
    RouteDef(Routes.EditProfileViewRoute, page: EditProfileView),
    RouteDef(Routes.SavedContentViewRoute, page: SavedContentView),
    RouteDef(Routes._UserFollowersViewRoute, page: UserFollowersView),
    RouteDef(Routes._UserFollowingViewRoute, page: UserFollowingView),
    RouteDef(Routes.MyTicketsViewRoute, page: MyTicketsView),
    RouteDef(Routes._EventTicketsViewRoute, page: EventTicketsView),
    RouteDef(Routes._TicketDetailsViewRoute, page: TicketDetailsView),
    RouteDef(Routes._TicketsPurchaseSuccessViewRoute,
        page: TicketsPurchaseSuccessView),
    RouteDef(Routes.USDBalanceHistoryViewRoute, page: USDBalanceHistoryView),
    RouteDef(Routes.PayoutMethodsViewRoute, page: PayoutMethodsView),
    RouteDef(Routes.HowEarningsWorkViewRoute, page: HowEarningsWorkView),
    RouteDef(Routes.SetUpDirectDepositViewRoute, page: SetupDirectDepositView),
    RouteDef(Routes.SetUpInstantDepositViewRoute,
        page: SetupInstantDepositView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    AuthView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    OnboardingPathSelectView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            OnboardingPathSelectView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    EventHostPathView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EventHostPathView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    StreamerPathView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StreamerPathView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    ExplorerPathView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ExplorerPathView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    OnboardingCompleteView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            OnboardingCompleteView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    WebblenBaseView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            WebblenBaseView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    PostView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PostView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    CreatePostView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreatePostView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    EventDetailsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EventDetailsView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    CreateEventView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateEventView(
          data.pathParams['id'].value,
          data.pathParams['promo'].value,
        ),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    LiveStreamDetailsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LiveStreamDetailsView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    CreateLiveStreamView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateLiveStreamView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    TicketSelectionView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TicketSelectionView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    TicketPurchaseView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TicketPurchaseView(
          data.pathParams['id'].value,
          data.pathParams['ticketsToPurchase'].value,
        ),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    AllSearchResultsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AllSearchResultsView(data.pathParams['term'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    NotificationsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NotificationsView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    UserProfileView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UserProfileView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    EditProfileView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditProfileView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    SavedContentView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SavedContentView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    UserFollowersView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UserFollowersView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    UserFollowingView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UserFollowingView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    MyTicketsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MyTicketsView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    EventTicketsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EventTicketsView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    TicketDetailsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TicketDetailsView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    TicketsPurchaseSuccessView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TicketsPurchaseSuccessView(data.pathParams['email'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    USDBalanceHistoryView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            USDBalanceHistoryView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    PayoutMethodsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PayoutMethodsView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    HowEarningsWorkView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            HowEarningsWorkView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    SetupDirectDepositView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SetupDirectDepositView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    SetupInstantDepositView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SetupInstantDepositView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
  };
}
