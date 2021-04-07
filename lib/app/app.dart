import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
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
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_connect_account_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_payment_service.dart';
import 'package:webblen_web_app/ui/views/auth/auth_view.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/ui/views/home/tabs/home/home_view_model.dart';
import 'package:webblen_web_app/ui/views/home/tabs/profile/profile_view_model.dart';
import 'package:webblen_web_app/ui/views/home/tabs/search/recent_search_view_model.dart';
import 'package:webblen_web_app/ui/views/home/tabs/wallet/wallet_view_model.dart';
import 'package:webblen_web_app/ui/views/live_streams/create_live_stream_view/create_live_stream_view.dart';
import 'package:webblen_web_app/ui/views/live_streams/live_stream_details_view/live_stream_details_view.dart';
import 'package:webblen_web_app/ui/views/posts/create_post_view/create_post_view.dart';
import 'package:webblen_web_app/ui/views/posts/post_view/post_view.dart';
import 'package:webblen_web_app/ui/views/search/all_search_results/all_search_results_view.dart';
import 'package:webblen_web_app/ui/views/users/edit_profile/edit_profile_view.dart';
import 'package:webblen_web_app/ui/views/users/followers/user_followers_view.dart';
import 'package:webblen_web_app/ui/views/users/following/user_following_view.dart';
import 'package:webblen_web_app/ui/views/users/profile/user_profile_view.dart';

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
    // MaterialRoute(page: OnboardingView, name: "OnboardingViewRoute"),

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
      path: "/post/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: CreatePostView,
      name: "CreatePostViewRoute",
      path: "/post/new/:id/:promo",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
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
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: CreateLiveStreamView,
      name: "CreateLiveStreamViewRoute",
      path: "/stream/new/:id/:promo",
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
    //
    // //NOTIFICATIONS
    // MaterialRoute(page: NotificationsView, name: "NotificationsViewRoute"),
    //
    //USER PROFILE & SETTINGS
    CustomRoute(
      page: UserProfileView,
      name: "UserProfileView",
      path: "/profile/:id",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: EditProfileView,
      name: "EditProfileViewRoute",
      path: "/profile/edit",
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
    //CustomRoute(page: SettingsView, name: "SettingsViewRoute"),
    //
    // //WALLET
    // MaterialRoute(page: RedeemedRewardsView, name: 'RedeemedRewardsViewRoute'),
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
    LazySingleton(classType: StripePaymentService),
    LazySingleton(classType: StripeConnectAccountService),
    LazySingleton(classType: LocationService),
    LazySingleton(classType: GooglePlacesService),
    LazySingleton(classType: AlgoliaSearchService),
    LazySingleton(classType: DynamicLinkService),
    LazySingleton(classType: ShareService),
    LazySingleton(classType: ActivityDataService),
    LazySingleton(classType: UserPreferenceDataService),

    //SINGLETONS
    Singleton(classType: WebblenBaseViewModel),
    Singleton(classType: HomeViewModel),
    Singleton(classType: RecentSearchViewModel),
    Singleton(classType: WalletViewModel),
    Singleton(classType: ProfileViewModel),
  ],
)
class AppSetup {
  /// no purpose outside of annotation
}
