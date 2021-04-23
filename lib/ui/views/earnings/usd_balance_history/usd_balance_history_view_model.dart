import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class USDBalanceHistoryViewModel extends BaseViewModel {
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///FILTER DATA
  String searchTerm = "";

  updateSearchTerm(String val) {
    searchTerm = val.toLowerCase();
    notifyListeners();
  }
}
