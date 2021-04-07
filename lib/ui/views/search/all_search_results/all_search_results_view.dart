import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/tab_bar/custom_tab_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_linear_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_live_streams/list_streams.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_users.dart';
import 'package:webblen_web_app/ui/widgets/search/search_field.dart';

import 'all_search_results_view_model.dart';

class AllSearchResultsView extends StatefulWidget {
  final String term;
  AllSearchResultsView(@PathParam() this.term);

  @override
  _AllSearchResultsViewState createState() => _AllSearchResultsViewState();
}

class _AllSearchResultsViewState extends State<AllSearchResultsView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget noResultsFound(AllSearchResultsViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomText(
        text: "No Results for \"${model.searchTerm}\"",
        textAlign: TextAlign.center,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: appFontColorAlt(),
      ),
    );
  }

  Widget head(AllSearchResultsViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
            heroTag: 'search',
            onTap: () => model.navigateToPreviousPage(),
            enabled: false,
            textEditingController: model.searchTextController,
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () => model.navigateToPreviousPage(),
            child: CustomText(
              text: "Cancel",
              textAlign: TextAlign.right,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: appTextButtonColor(),
            ),
          ).showCursorOnHover,
        ],
      ),
    );
  }

  Widget body(AllSearchResultsViewModel model) {
    return TabBarView(
      controller: _tabController,
      children: [
        noResultsFound(model),
        model.streamResults.isNotEmpty
            ? ListLiveStreams(
                refreshData: model.refreshStreams,
                dataResults: model.streamResults,
                pageStorageKey: PageStorageKey('stream-results'),
                scrollController: model.streamScrollController,
              )
            : noResultsFound(model),
        model.eventResults.isNotEmpty
            ? ListLiveStreams(
                refreshData: model.refreshEvents,
                dataResults: model.eventResults,
                pageStorageKey: PageStorageKey('event-results'),
                scrollController: model.eventScrollController,
              )
            : noResultsFound(model),
        model.userResults.isNotEmpty
            ? ListUsers(
                refreshData: model.refreshUsers,
                userResults: model.userResults,
                pageStorageKey: PageStorageKey('user-results'),
                scrollController: model.userScrollController,
              )
            : noResultsFound(model),
      ],
    );
  }

  Widget tabBar() {
    return WebblenAllSearchResultsTabBar(
      tabController: _tabController,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AllSearchResultsViewModel>.reactive(
      disposeViewModel: true,
      onModelReady: (model) => model.initialize(widget.term),
      viewModelBuilder: () => AllSearchResultsViewModel(),
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
