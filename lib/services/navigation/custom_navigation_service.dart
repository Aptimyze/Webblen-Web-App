import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/ui/views/home/tabs/search/search_view.dart';

class CustomNavigationService {
  NavigationService _navigationService = locator<NavigationService>();

  navigateBack() {
    _navigationService.back();
  }

  navigateToBase() {
    _navigationService.pushNamedAndRemoveUntil(Routes.WebblenBaseViewRoute);
  }

  ///AUTH
  navigateToAuthView() {
    _navigationService.pushNamedAndRemoveUntil(Routes.AuthViewRoute);
  }

  ///ONBOARDING
  navigateToOnboardingView() {
    _navigationService.pushNamedAndRemoveUntil(Routes.OnboardingPathSelectViewRoute);
  }

  navigateToCompleteOnboardingView() {
    _navigationService.pushNamedAndRemoveUntil(Routes.OnboardingCompleteViewRoute);
  }

  ///POSTS
  navigateToPostView(String id) {
    _navigationService.navigateTo(Routes.PostViewRoute(id: id));
  }

  navigateToCreatePostView(String id) {
    _navigationService.navigateTo(Routes.CreatePostViewRoute(id: id, promo: "0"));
  }

  navigateToCreatePostViewWithPromo(String id, String promo) {
    _navigationService.navigateTo(Routes.CreatePostViewRoute(id: id, promo: promo));
  }

  ///EVENTS
  navigateToEventView(String id) {
    _navigationService.navigateTo(Routes.EventDetailsViewRoute(id: id));
  }

  navigateToCreateEventView(String id) {
    _navigationService.navigateTo(Routes.CreateEventViewRoute(id: id, promo: "0"));
  }

  navigateToCreateEventViewWithPromo(String id, String promo) {
    _navigationService.navigateTo(Routes.CreateEventViewRoute(id: id, promo: promo));
  }

  ///TICKETS
  navigateToMyTicketsView() {
    _navigationService.navigateTo(Routes.MyTicketsViewRoute);
  }

  navigateToEventTickets(String id) {
    _navigationService.navigateTo(Routes.EventTicketsViewRoute(id: id));
  }

  navigateToTicketView(String id) {
    _navigationService.navigateTo(Routes.TicketDetailsViewRoute(id: id));
  }

  navigateToTicketSelectionView(String id) {
    _navigationService.navigateTo(Routes.TicketSelectionViewRoute(id: id));
  }

  navigateToTicketPurchaseView({required String eventID, required String ticketJSONData}) {
    _navigationService.navigateTo(Routes.TicketPurchaseViewRoute(id: eventID, ticketsToPurchase: ticketJSONData));
  }

  navigateToTicketPurchaseSuccessView(String email) {
    _navigationService.replaceWith(Routes.TicketsPurchaseSuccessViewRoute(email: email));
  }

  ///STREAMS
  navigateToLiveStreamView(String id) {
    _navigationService.navigateTo(Routes.LiveStreamViewRoute(id: id));
  }

  navigateToCreateLiveStreamView(String id) {
    _navigationService.navigateTo(Routes.CreateLiveStreamViewRoute(id: id, promo: "0"));
  }

  navigateToCreateLiveStreamViewRouteWithPromo(String id, String promo) {
    _navigationService.navigateTo(Routes.CreateLiveStreamViewRoute(id: id, promo: promo));
  }

  ///USERS
  navigateToCurrentUserView() {
    // _navigationService.pushNamedAndRemoveUntil(Routes.AppBaseViewRoute(page: "4"));
  }

  navigateToUserView(String id) {
    _navigationService.navigateTo(Routes.UserProfileView(id: id));
  }

  ///WALLET
  navigateToWalletView() {
    // _navigationService.pushNamedAndRemoveUntil(Routes.AppBaseViewRoute(page: "3"));
  }

  ///EARNINGS
  navigateToSetUpInstantDepositView() {
    _navigationService.navigateTo(Routes.SetUpInstantDepositViewRoute);
  }

  navigateToSetUpDirectDepositView() {
    _navigationService.navigateTo(Routes.SetUpDirectDepositViewRoute);
  }

  navigateToUSDBalanceHistoryView() {
    _navigationService.navigateTo(Routes.USDBalanceHistoryViewRoute);
  }

  ///SEARCH
  navigateToSearchView() {
    _navigationService.navigateWithTransition(SearchView(), transition: 'fade', opaque: true);
  }

  navigateToSearchViewWithTerm(String term) {
    _navigationService.navigateWithTransition(SearchView(term: term), transition: 'fade', opaque: true);
  }

  ///NOTIFICATIONS
  navigateToNotificationsView() {
    _navigationService.navigateTo(Routes.NotificationsViewRoute);
  }
}
