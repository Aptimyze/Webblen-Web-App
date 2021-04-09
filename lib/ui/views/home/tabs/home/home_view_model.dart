import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/reactive/content_filter/reactive_content_filter_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class HomeViewModel extends ReactiveViewModel {
  ///SERVICES
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  ReactiveContentFilterService _reactiveContentFilterService = locator<ReactiveContentFilterService>();

  ///DATA
  String get cityName => _reactiveContentFilterService.cityName;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveContentFilterService];
}
