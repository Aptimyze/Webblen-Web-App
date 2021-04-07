import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/enums/init_error_status.dart';
import 'package:webblen_web_app/ui/init_error_views/network_error/network_error_view.dart';
import 'package:webblen_web_app/ui/views/home/init_error_views/location_error/location_error_view.dart';
import 'package:webblen_web_app/ui/views/home/tabs/home/home_view.dart';
import 'package:webblen_web_app/ui/views/home/tabs/profile/profile_view.dart';
import 'package:webblen_web_app/ui/views/home/tabs/search/search_view.dart';
import 'package:webblen_web_app/ui/views/home/tabs/wallet/wallet_view.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';

import 'webblen_base_view_model.dart';

class WebblenBaseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget getViewForIndex(int index, WebblenBaseViewModel model) {
      switch (index) {
        case 0:
          return model.isBusy
              ? Center(
                  child: CustomCircleProgressIndicator(
                    color: appActiveColor(),
                    size: 32,
                  ),
                )
              : HomeView();
        case 1:
          return SearchView();
        case 2:
          return WalletView();
        case 3:
          return ProfileView();
        default:
          return model.isBusy
              ? Container(
                  color: appBackgroundColor,
                )
              : HomeView();
      }
    }

    return ViewModelBuilder<WebblenBaseViewModel>.reactive(
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => locator<WebblenBaseViewModel>(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: CustomTopNavBar(
            navBarItems: [
              CustomTopNavBarItem(
                onTap: () => model.setNavBarIndex(0),
                iconData: FontAwesomeIcons.home,
                isActive: model.navBarIndex == 0 ? true : false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.setNavBarIndex(1),
                iconData: FontAwesomeIcons.search,
                isActive: model.navBarIndex == 1 ? true : false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.setNavBarIndex(2),
                iconData: FontAwesomeIcons.wallet,
                isActive: model.navBarIndex == 2 ? true : false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.setNavBarIndex(3),
                iconData: FontAwesomeIcons.user,
                isActive: model.navBarIndex == 3 ? true : false,
              ),
            ],
          ),
        ),
        body: model.isBusy
            ? Container(
                color: appBackgroundColor,
                child: Center(
                  child: CustomCircleProgressIndicator(
                    color: appActiveColor(),
                    size: 32,
                  ),
                ),
              )
            : model.initErrorStatus == InitErrorStatus.network
                ? NetworkErrorView(
                    tryAgainAction: () => model.initialize(),
                  )
                : model.initErrorStatus == InitErrorStatus.location
                    ? LocationErrorView(
                        tryAgainAction: () => model.initialize(),
                      )
                    : getViewForIndex(model.navBarIndex, model),
        floatingActionButton: Container(
          width: 100,
          child: Row(
            mainAxisAlignment: model.isAnonymous == null || model.isAnonymous ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
            children: [
              model.cityName == null
                  ? Container(
                      width: 0,
                      height: 0,
                    )
                  : FloatingActionButton(
                      heroTag: "showFilter",
                      onPressed: () => model.openFilter(),
                      backgroundColor: appActiveColor(),
                      foregroundColor: Colors.white,
                      mini: true,
                      child: Icon(
                        FontAwesomeIcons.slidersH,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
              model.isAnonymous == null || model.isAnonymous
                  ? Container(
                      width: 0,
                      height: 0,
                    )
                  : FloatingActionButton(
                      heroTag: "addContent",
                      onPressed: () => model.showAddContentOptions(),
                      backgroundColor: appActiveColor(),
                      foregroundColor: Colors.white,
                      mini: true,
                      child: Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
