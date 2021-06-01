import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
import 'package:webblen_web_app/services/email/email_service.dart';
import 'package:webblen_web_app/services/firestore/common/firestore_storage_service.dart';
import 'package:webblen_web_app/services/firestore/data/activity_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/comment_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_preference_data_service.dart';
import 'package:webblen_web_app/services/location/google_places_service.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/services/navigation/custom_navigation_service.dart';
import 'package:webblen_web_app/services/reactive/content_filter/reactive_content_filter_service.dart';
import 'package:webblen_web_app/services/reactive/file_uploader/reactive_file_uploader_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_connect_account_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_payment_service.dart';
import 'package:webblen_web_app/ui/views/auth/auth_view.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/ui/views/earnings/how_earnings_work/how_earnings_work_view.dart';
import 'package:webblen_web_app/ui/views/earnings/payout_methods/payout_methods_view.dart';
import 'package:webblen_web_app/ui/views/earnings/set_up_direct_deposit/set_up_direct_deposit_view.dart';
import 'package:webblen_web_app/ui/views/earnings/set_up_instant_deposit/set_up_instant_deposit_view.dart';
import 'package:webblen_web_app/ui/views/earnings/usd_balance_history/usd_balance_history_view.dart';
import 'package:webblen_web_app/ui/views/events/create_event_view/create_event_view.dart';
import 'package:webblen_web_app/ui/views/events/event_view/event_details_view.dart';
import 'package:webblen_web_app/ui/views/events/tickets/event_tickets/event_tickets_view.dart';
import 'package:webblen_web_app/ui/views/events/tickets/my_tickets/my_tickets_view.dart';
import 'package:webblen_web_app/ui/views/events/tickets/ticket_details/ticket_details_view.dart';
import 'package:webblen_web_app/ui/views/events/tickets/ticket_purchase/ticket_purchase_view.dart';
import 'package:webblen_web_app/ui/views/events/tickets/ticket_selection/ticket_selection_view.dart';
import 'package:webblen_web_app/ui/views/events/tickets/tickets_purchase_success/tickets_purchase_success_view.dart';
import 'package:webblen_web_app/ui/views/home/tabs/home/home_view_model.dart';
import 'package:webblen_web_app/ui/views/home/tabs/search/recent_search_view_model.dart';
import 'package:webblen_web_app/ui/views/home/tabs/wallet/wallet_view_model.dart';
import 'package:webblen_web_app/ui/views/live_streams/create_live_stream_view/create_live_stream_view.dart';
import 'package:webblen_web_app/ui/views/live_streams/live_stream_details_view/live_stream_details_view.dart';
import 'package:webblen_web_app/ui/views/notifications/notifications_view.dart';
import 'package:webblen_web_app/ui/views/onboarding/event_host_path/event_host_path_view.dart';
import 'package:webblen_web_app/ui/views/onboarding/explorer_path/explorer_path_view.dart';
import 'package:webblen_web_app/ui/views/onboarding/onboarding_complete/onboarding_complete_view.dart';
import 'package:webblen_web_app/ui/views/onboarding/path_select/onboarding_path_select_view.dart';
import 'package:webblen_web_app/ui/views/onboarding/streamer_path/streamer_path_view.dart';
import 'package:webblen_web_app/ui/views/posts/create_post_view/create_post_view.dart';
import 'package:webblen_web_app/ui/views/posts/post_view/post_view.dart';
import 'package:webblen_web_app/ui/views/search/all_search_results/all_search_results_view.dart';
import 'package:webblen_web_app/ui/views/users/edit_profile/edit_profile_view.dart';
import 'package:webblen_web_app/ui/views/users/followers/user_followers_view.dart';
import 'package:webblen_web_app/ui/views/users/following/user_following_view.dart';
import 'package:webblen_web_app/ui/views/users/profile/user_profile_view.dart';
import 'package:webblen_web_app/ui/views/users/saved/saved_content_view.dart';

@StackedApp(
  routes: [
    //AUTHENTICATION
    CustomRoute(
      page: AuthView,
      name: "AuthViewRoute",
      path: "/login",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),

    //ONBOARDING
    CustomRoute(
      page: OnboardingPathSelectView,
      name: "OnboardingPathSelectViewRoute",
      path: "/onboarding/path_select",
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: EventHostPathView,
      name: "EventHostPathViewRoute",
      path: "/onboarding/event_host",
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: StreamerPathView,
      name: "StreamerPathViewRoute",
      path: "/onboarding/streamer",
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: ExplorerPathView,
      name: "ExplorerPathViewRoute",
      path: "/onboarding/explorer",
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: OnboardingCompleteView,
      name: "OnboardingCompleteViewRoute",
      path: "/onboarding/completed",
      durationInMilliseconds: 0,
    ),

    //HOME
    CustomRoute(
      page: WebblenBaseView,
      initial: true,
      name: "WebblenBaseViewRoute",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    //POST
    CustomRoute(
      page: PostView,
      name: "PostViewRoute",
      path: "/posts/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: CreatePostView,
      name: "CreatePostViewRoute",
      path: "/post/publish/:id/:promo",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    // //EVENT
    CustomRoute(
      page: EventDetailsView,
      name: "EventDetailsViewRoute",
      path: "/events/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: CreateEventView,
      name: "CreateEventViewRoute",
      path: "/event/publish/:id/:promo",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    // //STREAM
    CustomRoute(
      page: LiveStreamDetailsView,
      name: "LiveStreamViewRoute",
      path: "/streams/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: CreateLiveStreamView,
      name: "CreateLiveStreamViewRoute",
      path: "/stream/publish/:id/:promo",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    //TICKETS
    CustomRoute(
      page: TicketSelectionView,
      name: "TicketSelectionViewRoute",
      path: "/tickets/select/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: TicketPurchaseView,
      name: "TicketPurchaseViewRoute",
      path: "/tickets/purchase/:id/:ticketsToPurchase",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    // //SEARCH
    CustomRoute(
      page: AllSearchResultsView,
      name: "AllSearchResultsViewRoute",
      path: "/all_results/:term",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    //NOTIFICATIONS
    CustomRoute(
      page: NotificationsView,
      name: "NotificationsViewRoute",
      path: "/notifications",
      durationInMilliseconds: 0,
    ),

    //USER PROFILE & SETTINGS
    CustomRoute(
      page: UserProfileView,
      name: "UserProfileView",
      path: "/profiles/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: EditProfileView,
      name: "EditProfileViewRoute",
      path: "/edit_profile",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: SavedContentView,
      name: "SavedContentViewRoute",
      path: "/saved",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: UserFollowersView,
      name: "UserFollowersViewRoute",
      path: "/profile/followers/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: UserFollowingView,
      name: "UserFollowingViewRoute",
      path: "/profile/following/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    // //WALLET
    // MaterialRoute(page: RedeemedRewardsView, name: 'RedeemedRewardsViewRoute'),

    //TICKETS
    CustomRoute(
      page: MyTicketsView,
      name: "MyTicketsViewRoute",
      path: "/wallet/my_tickets",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: EventTicketsView,
      name: "EventTicketsViewRoute",
      path: "/wallet/my_tickets/event/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: TicketDetailsView,
      name: "TicketDetailsViewRoute",
      path: "/tickets/view/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: TicketsPurchaseSuccessView,
      name: "TicketsPurchaseSuccessViewRoute",
      path: "/ticket_purchase_success/:email",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),

    //EARNINGS
    CustomRoute(
      page: USDBalanceHistoryView,
      name: "USDBalanceHistoryViewRoute",
      path: "/usd-balance-history",
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: PayoutMethodsView,
      name: "PayoutMethodsViewRoute",
      path: "/payout-methods",
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: HowEarningsWorkView,
      name: "HowEarningsWorkViewRoute",
      path: "/how-earnings-work",
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: SetupDirectDepositView,
      name: "SetUpDirectDepositViewRoute",
      path: "/setup-direct-deposit",
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: SetupInstantDepositView,
      name: "SetUpInstantDepositViewRoute",
      path: "/setup-instant-deposit",
      durationInMilliseconds: 0,
    ),
  ],
  dependencies: [
    //LAZY SINGLETONS
    LazySingleton(
      classType: ThemeService,
      resolveUsing: ThemeService.getInstance,
    ),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: CustomNavigationService),
    LazySingleton(classType: CustomBottomSheetService),
    LazySingleton(classType: CustomDialogService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: FirestoreStorageService),
    LazySingleton(classType: PlatformDataService),
    LazySingleton(classType: NotificationDataService),
    //LazySingleton(classType: ForYouPostDataService),
    LazySingleton(classType: UserDataService),
    LazySingleton(classType: PostDataService),
    LazySingleton(classType: EventDataService),
    LazySingleton(classType: LiveStreamDataService),
    //LazySingleton(classType: LiveStreamChatDataService),
    //LazySingleton(classType: ContentGiftPoolDataService),
    //LazySingleton(classType: RedeemedRewardDataService),
    LazySingleton(classType: TicketDistroDataService),
    LazySingleton(classType: CommentDataService),
    LazySingleton(classType: EmailService),
    LazySingleton(classType: StripePaymentService),
    LazySingleton(classType: StripeConnectAccountService),
    LazySingleton(classType: LocationService),
    LazySingleton(classType: GooglePlacesService),
    LazySingleton(classType: AlgoliaSearchService),
    LazySingleton(classType: DynamicLinkService),
    LazySingleton(classType: ShareService),
    LazySingleton(classType: ActivityDataService),
    LazySingleton(classType: UserPreferenceDataService),

    //REACTIVE LAZY SINGLETONS
    LazySingleton(classType: ReactiveWebblenUserService),
    LazySingleton(classType: ReactiveContentFilterService),
    LazySingleton(classType: ReactiveFileUploaderService),

    //SINGLETONS
    Singleton(classType: WebblenBaseViewModel),
    Singleton(classType: HomeViewModel),
    Singleton(classType: RecentSearchViewModel),
    Singleton(classType: WalletViewModel),
  ],
)
class AppSetup {
  /// no purpose outside of annotation
}
