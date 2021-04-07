import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class RecentSearchViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///DATA RESULTS
  List recentSearchTerms = [];
  String uid;

  showAddContentOptions() async {
    webblenBaseViewModel.showAddContentOptions();
  }

  researchTerm(String term) {}

  navigateToSearchView() {}
}
