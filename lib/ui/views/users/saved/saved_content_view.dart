import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/tab_bar/custom_tab_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_linear_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_events/saved/list_saved_events.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_live_streams/saved/list_saved_live_streams.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_posts/saved/list_saved_posts.dart';

import 'saved_content_view_model.dart';

class SavedContentView extends StatefulWidget {
  @override
  _SavedContentViewState createState() => _SavedContentViewState();
}

class _SavedContentViewState extends State<SavedContentView> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  Widget head(SavedContentViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: CustomText(
          text: "Saved",
          textAlign: TextAlign.center,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: appFontColor(),
        ),
      ),
    );
  }

  Widget body(SavedContentViewModel model) {
    return TabBarView(
      controller: _tabController,
      children: [
        ListSavedPosts(),
        ListSavedLiveStreams(),
        ListSavedEvents(),
      ],
    );
  }

  Widget tabBar() {
    return WebblenProfileTabBar(
      tabController: _tabController,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SavedContentViewModel>.reactive(
      disposeViewModel: true,
      viewModelBuilder: () => SavedContentViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: CustomTopNavBar(
            navBarItems: [
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(0),
                iconData: FontAwesomeIcons.home,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(1),
                iconData: FontAwesomeIcons.search,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(2),
                iconData: FontAwesomeIcons.wallet,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(3),
                iconData: FontAwesomeIcons.user,
                isActive: false,
              ),
            ],
          ),
        ),
        body: Container(
          height: screenHeight(context),
          color: appBackgroundColor,
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  head(model),
                  verticalSpaceSmall,
                  tabBar(),
                  verticalSpaceSmall,
                  model.isBusy ? CustomLinearProgressIndicator(color: appActiveColor()) : Container(),
                  SizedBox(height: 8),
                  Expanded(
                    child: body(model),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
