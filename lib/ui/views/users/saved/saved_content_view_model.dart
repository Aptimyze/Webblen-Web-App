import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class SavedContentViewModel extends BaseViewModel {
  NavigationService? _navigationService = locator<NavigationService>();
  AlgoliaSearchService? _algoliaSearchService = locator<AlgoliaSearchService>();
  WebblenBaseViewModel? webblenBaseViewModel = locator<WebblenBaseViewModel>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
}
