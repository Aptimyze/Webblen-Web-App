// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i6;
import 'package:stacked_themes/stacked_themes.dart' as _i28;

import '../services/algolia/algolia_search_service.dart' as _i4;
import '../services/auth/auth_service.dart' as _i5;
import '../services/dynamic_links/dynamic_link_service.dart' as _i9;
import '../services/firestore/common/firestore_storage_service.dart' as _i11;
import '../services/firestore/data/activity_data_service.dart' as _i3;
import '../services/firestore/data/comment_data_service.dart' as _i7;
import '../services/firestore/data/content_gift_pool_data_service.dart' as _i8;
import '../services/firestore/data/event_data_service.dart' as _i10;
import '../services/firestore/data/for_you_event_data_service.dart' as _i12;
import '../services/firestore/data/for_you_post_data_service.dart' as _i13;
import '../services/firestore/data/live_stream_chat_data_service.dart' as _i18;
import '../services/firestore/data/live_stream_data_service.dart' as _i19;
import '../services/firestore/data/notification_data_service.dart' as _i21;
import '../services/firestore/data/platform_data_service.dart' as _i22;
import '../services/firestore/data/post_data_service.dart' as _i23;
import '../services/firestore/data/redeemed_reward_data_service.dart' as _i24;
import '../services/firestore/data/ticket_distro_data_service.dart' as _i29;
import '../services/firestore/data/user_data_service.dart' as _i30;
import '../services/firestore/data/user_preference_data_service.dart' as _i31;
import '../services/location/google_places_service.dart' as _i14;
import '../services/location/location_service.dart' as _i20;
import '../services/services_module.dart' as _i39;
import '../services/share/share_service.dart' as _i25;
import '../services/stripe/stripe_connect_account_service.dart' as _i26;
import '../services/stripe/stripe_payment_service.dart' as _i27;
import '../ui/views/base/webblen_base_view_model.dart' as _i32;
import '../ui/views/home/tabs/home/home_view_model.dart' as _i35;
import '../ui/views/home/tabs/profile/profile_view_model.dart' as _i36;
import '../ui/views/home/tabs/search/recent_search_view_model.dart' as _i37;
import '../ui/views/home/tabs/wallet/wallet_view_model.dart' as _i38;
import '../ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_model.dart' as _i34;
import '../ui/widgets/list_builders/list_live_streams/home/list_home_live_streams_model.dart' as _i16;
import '../ui/widgets/list_builders/list_posts/home/list_home_posts_model.dart' as _i17; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get, {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final servicesModule = _$ServicesModule();
  gh.lazySingleton<_i3.ActivityDataService>(() => servicesModule.activityDataService);
  gh.lazySingleton<_i4.AlgoliaSearchService>(() => servicesModule.algoliaSearchService);
  gh.lazySingleton<_i5.AuthService>(() => servicesModule.authService);
  gh.lazySingleton<_i6.BottomSheetService>(() => servicesModule.bottomSheetService);
  gh.lazySingleton<_i7.CommentDataService>(() => servicesModule.commentDataService);
  gh.lazySingleton<_i8.ContentGiftPoolDataService>(() => servicesModule.contentGiftPoolDataService);
  gh.lazySingleton<_i6.DialogService>(() => servicesModule.dialogService);
  gh.lazySingleton<_i9.DynamicLinkService>(() => servicesModule.dynamicLinkService);
  gh.lazySingleton<_i10.EventDataService>(() => servicesModule.eventDataService);
  gh.lazySingleton<_i11.FirestoreStorageService>(() => servicesModule.firestoreStorageService);
  gh.lazySingleton<_i12.ForYouEventDataService>(() => servicesModule.forYouEventDataService);
  gh.lazySingleton<_i13.ForYouPostDataService>(() => servicesModule.forYouPostDataService);
  gh.lazySingleton<_i14.GooglePlacesService>(() => servicesModule.googlePlacesService);
  gh.lazySingleton<_i16.ListHomeLiveStreamsModel>(() => _i16.ListHomeLiveStreamsModel());
  gh.lazySingleton<_i17.ListHomePostsModel>(() => _i17.ListHomePostsModel());
  gh.lazySingleton<_i18.LiveStreamChatDataService>(() => servicesModule.liveStreamChatDataService);
  gh.lazySingleton<_i19.LiveStreamDataService>(() => servicesModule.liveStreamDataService);
  gh.lazySingleton<_i20.LocationService>(() => servicesModule.locationService);
  gh.lazySingleton<_i6.NavigationService>(() => servicesModule.navigationService);
  gh.lazySingleton<_i21.NotificationDataService>(() => servicesModule.notificationDataService);
  gh.lazySingleton<_i22.PlatformDataService>(() => servicesModule.platformDataService);
  gh.lazySingleton<_i23.PostDataService>(() => servicesModule.postDataService);
  gh.lazySingleton<_i24.RedeemedRewardDataService>(() => servicesModule.redeemedRewardDataService);
  gh.lazySingleton<_i25.ShareService>(() => servicesModule.shareService);
  gh.lazySingleton<_i6.SnackbarService>(() => servicesModule.snackBarService);
  gh.lazySingleton<_i26.StripeConnectAccountService>(() => servicesModule.stripeConnectAccountService);
  gh.lazySingleton<_i27.StripePaymentService>(() => servicesModule.stripePaymentService);
  gh.lazySingleton<_i28.ThemeService>(() => servicesModule.themeService);
  gh.lazySingleton<_i29.TicketDistroDataService>(() => servicesModule.ticketDistroDataService);
  gh.lazySingleton<_i30.UserDataService>(() => servicesModule.userDataService);
  gh.lazySingleton<_i31.UserPreferenceDataService>(() => servicesModule.userPreferenceDataService);
  gh.lazySingleton<_i32.WebblenBaseViewModel>(() => _i32.WebblenBaseViewModel());
  gh.singleton<_i34.CustomTopNavBarModel>(_i34.CustomTopNavBarModel());
  gh.singleton<_i35.HomeViewModel>(_i35.HomeViewModel());
  gh.singleton<_i36.ProfileViewModel>(_i36.ProfileViewModel());
  gh.singleton<_i37.RecentSearchViewModel>(_i37.RecentSearchViewModel());
  gh.singleton<_i38.WalletViewModel>(_i38.WalletViewModel());
  return get;
}

class _$ServicesModule extends _i39.ServicesModule {
  @override
  _i3.ActivityDataService get activityDataService => _i3.ActivityDataService();
  @override
  _i4.AlgoliaSearchService get algoliaSearchService => _i4.AlgoliaSearchService();
  @override
  _i5.AuthService get authService => _i5.AuthService();
  @override
  _i6.BottomSheetService get bottomSheetService => _i6.BottomSheetService();
  @override
  _i7.CommentDataService get commentDataService => _i7.CommentDataService();
  @override
  _i8.ContentGiftPoolDataService get contentGiftPoolDataService => _i8.ContentGiftPoolDataService();
  @override
  _i6.DialogService get dialogService => _i6.DialogService();
  @override
  _i9.DynamicLinkService get dynamicLinkService => _i9.DynamicLinkService();
  @override
  _i10.EventDataService get eventDataService => _i10.EventDataService();
  @override
  _i11.FirestoreStorageService get firestoreStorageService => _i11.FirestoreStorageService();
  @override
  _i12.ForYouEventDataService get forYouEventDataService => _i12.ForYouEventDataService();
  @override
  _i13.ForYouPostDataService get forYouPostDataService => _i13.ForYouPostDataService();
  @override
  _i14.GooglePlacesService get googlePlacesService => _i14.GooglePlacesService();
  @override
  _i18.LiveStreamChatDataService get liveStreamChatDataService => _i18.LiveStreamChatDataService();
  @override
  _i19.LiveStreamDataService get liveStreamDataService => _i19.LiveStreamDataService();
  @override
  _i20.LocationService get locationService => _i20.LocationService();
  @override
  _i6.NavigationService get navigationService => _i6.NavigationService();
  @override
  _i21.NotificationDataService get notificationDataService => _i21.NotificationDataService();
  @override
  _i22.PlatformDataService get platformDataService => _i22.PlatformDataService();
  @override
  _i23.PostDataService get postDataService => _i23.PostDataService();
  @override
  _i24.RedeemedRewardDataService get redeemedRewardDataService => _i24.RedeemedRewardDataService();
  @override
  _i25.ShareService get shareService => _i25.ShareService();
  @override
  _i6.SnackbarService get snackBarService => _i6.SnackbarService();
  @override
  _i26.StripeConnectAccountService get stripeConnectAccountService => _i26.StripeConnectAccountService();
  @override
  _i27.StripePaymentService get stripePaymentService => _i27.StripePaymentService();
  @override
  _i29.TicketDistroDataService get ticketDistroDataService => _i29.TicketDistroDataService();
  @override
  _i30.UserDataService get userDataService => _i30.UserDataService();
  @override
  _i31.UserPreferenceDataService get userPreferenceDataService => _i31.UserPreferenceDataService();
}
