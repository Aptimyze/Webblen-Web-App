import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_congregated_content/list_discover_content/list_discover_content.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_events/home/list_home_events.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_live_streams/home/list_home_live_streams.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_posts/home/list_home_posts.dart';

import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => locator<HomeViewModel>(),
      builder: (context, model, child) => Container(
        height: screenHeight(context),
        color: appBackgroundColor,
        child: Center(
          child: Container(
            child: model.webblenBaseViewModel.isBusy
                ? Center(
                    child: CustomCircleProgressIndicator(
                      color: appActiveColor(),
                      size: 32,
                    ),
                  )
                : model.cityName.isEmpty
                    ? _ChooseLocationView(openFilter: () => model.customBottomSheetService.openFilter())
                    : ResponsiveBuilder(
                        builder: (context, screenSize) {
                          if (screenSize.isDesktop) {
                            return _DesktopHomeBody();
                          } else {
                            return _HomeBody();
                          }
                        },
                      ),
          ),
        ),
      ),
    );
  }
}

class _ChooseLocationView extends StatelessWidget {
  final VoidCallback openFilter;
  _ChooseLocationView({required this.openFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "Welcome to Webblen",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
            CustomText(
              text: "Choose a location and see what's going on",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: appFontColor(),
            ),
            verticalSpaceMedium,
            CustomButton(
              text: "Select a Location",
              textSize: 16,
              height: 30,
              width: 200,
              onPressed: openFilter,
              backgroundColor: appBackgroundColor,
              textColor: appFontColor(),
              elevation: 1.0,
              isBusy: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopHomeBody extends HookViewModelWidget<HomeViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, HomeViewModel model) {
    return Stack(
      children: [
        Column(
          children: [
            verticalSpaceMedium,
            Expanded(
                child: model.contentType == "Posts Only"
                    ? ListHomePosts()
                    : model.contentType == "Streams Only"
                        ? ListHomeLiveStreams()
                        : model.contentType == "Events Only"
                            ? ListHomeEvents()
                            : ListDiscoverContent()),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: _FeedController(
            cityName: model.cityName,
            index: 0, //_tabController.index,
            navigateToIndex: null, //(index) => _tabController.animateTo(index),
          ),
        ),
      ],
    );
  }
}

class _HomeBody extends HookViewModelWidget<HomeViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, HomeViewModel model) {
    return Column(
      children: [
        SizedBox(height: 16),
        Expanded(
            child: model.contentType == "Posts Only"
                ? ListHomePosts()
                : model.contentType == "Streams Only"
                    ? ListHomeLiveStreams()
                    : model.contentType == "Events Only"
                        ? ListHomeEvents()
                        : ListDiscoverContent()),
      ],
    );
  }
}

class _FeedController extends StatelessWidget {
  final String? cityName;
  final int index;
  final Function(int)? navigateToIndex;

  const _FeedController({
    required this.cityName,
    required this.index,
    required this.navigateToIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 32, top: 32, right: 16),
      constraints: BoxConstraints(
        maxHeight: 120,
        maxWidth: MediaQuery.of(context).size.width * 0.3,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: appShadowColor(),
        //     spreadRadius: 0.5,
        //     blurRadius: 1.0,
        //     offset: Offset(0.0, 0.0),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: cityName == "Worldwide" ? "See What's Going on" : "See What's Going on In",
            color: appFontColor(),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          CustomText(
            text: "$cityName",
            color: appFontColor(),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          verticalSpaceMedium,
          // GestureDetector(
          //   onTap: () => navigateToIndex(0),
          //   child: Container(
          //     width: 100,
          //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //     decoration: BoxDecoration(
          //       color: index == 0 ? appActiveColor() : Colors.transparent,
          //       borderRadius: BorderRadius.circular(60),
          //     ),
          //     child: CustomText(
          //       text: "For You",
          //       color: index == 0 ? Colors.white : appFontColor(),
          //       fontSize: 14,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ).showCursorOnHover,
          // verticalSpaceSmall,
          // GestureDetector(
          //   onTap: () => navigateToIndex(1),
          //   child: Container(
          //     width: 100,
          //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //     decoration: BoxDecoration(
          //       color: index == 1 ? appActiveColor() : Colors.transparent,
          //       borderRadius: BorderRadius.circular(60),
          //     ),
          //     child: CustomText(
          //       text: "Posts",
          //       color: index == 1 ? Colors.white : appFontColor(),
          //       fontSize: 14,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ).showCursorOnHover,
          // verticalSpaceSmall,
          // GestureDetector(
          //   onTap: () => navigateToIndex(2),
          //   child: Container(
          //     width: 100,
          //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //     decoration: BoxDecoration(
          //       color: index == 2 ? appActiveColor() : Colors.transparent,
          //       borderRadius: BorderRadius.circular(60),
          //     ),
          //     child: CustomText(
          //       text: "Events",
          //       color: index == 2 ? Colors.white : appFontColor(),
          //       fontSize: 14,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ).showCursorOnHover,
        ],
      ),
    );
  }
}
