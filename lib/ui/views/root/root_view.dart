import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/enums/init_error_status.dart';
import 'package:webblen_web_app/ui/init_error_views/network_error/network_error_view.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';

import 'root_view_model.dart';

class RootView extends StatelessWidget {
  Widget getViewForIndex(int index, RootViewModel model) {
    switch (index) {
      case 0:
        return Container();
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
      case 4:
        return Container();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RootViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => RootViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: CustomNavBar(
            navBarItems: [
              CustomNavBarItem(
                onTap: () => model.setNavBarIndex(0),
                iconData: FontAwesomeIcons.home,
                isActive: model.navBarIndex == 0 ? true : false,
              ),
              CustomNavBarItem(
                onTap: () => model.setNavBarIndex(1),
                iconData: FontAwesomeIcons.wallet,
                isActive: model.navBarIndex == 1 ? true : false,
              ),
              CustomNavBarItem(
                onTap: () => model.setNavBarIndex(2),
                iconData: FontAwesomeIcons.user,
                isActive: model.navBarIndex == 2 ? true : false,
              ),
              CustomNavBarItem(
                onTap: () => model.setNavBarIndex(3),
                iconData: FontAwesomeIcons.cog,
                isActive: model.navBarIndex == 3 ? true : false,
              ),
            ],
          ),
        ),
        body: model.isBusy
            ? Container(
                color: appBackgroundColor(),
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
                : getViewForIndex(model.navBarIndex, model),
      ),
    );
  }
}
