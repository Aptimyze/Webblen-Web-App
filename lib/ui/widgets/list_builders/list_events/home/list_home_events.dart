import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/events/event_block/event_block_view.dart';

import 'list_home_events_model.dart';

class ListHomeEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListHomeEventsModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => ListHomeEventsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
          ? ZeroStateView(
              scrollController: model.scrollController,
              imageAssetName: "calendar",
              imageSize: 200,
              header: "No Events in ${model.cityName} Found",
              subHeader: model.webblenBaseViewModel!.streamPromo != null
                  ? "Schedule an Event for ${model.cityName} Now and Earn ${model.webblenBaseViewModel!.eventPromo!.toStringAsFixed(2)} WBLN!"
                  : "Schedule an Event for ${model.cityName} Now!",
              mainActionButtonTitle:
                  model.webblenBaseViewModel!.streamPromo != null ? "Earn ${model.webblenBaseViewModel!.eventPromo!.toStringAsFixed(2)} WBLN" : "Create Stream",
              mainAction: () => model.webblenBaseViewModel!.navigateToCreateEventPage(
                id: null,
                addPromo: model.webblenBaseViewModel!.eventPromo != null,
              ),
              secondaryActionButtonTitle: null,
              secondaryAction: null,
              refreshData: model.refreshData,
            )
          : Container(
              height: screenHeight(context),
              color: appBackgroundColor,
              child: RefreshIndicator(
                onRefresh: model.refreshData,
                child: ListView.builder(
                  controller: model.scrollController,
                  key: PageStorageKey(model.listKey),
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  itemCount: model.dataResults.length + 1,
                  itemBuilder: (context, index) {
                    if (index < model.dataResults.length) {
                      WebblenEvent event;
                      event = WebblenEvent.fromMap(model.dataResults[index].data()!);
                      return EventBlockView(
                        event: event,
                        showEventOptions: (event) => model.showContentOptions(event),
                      );
                    } else {
                      if (model.moreDataAvailable) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          model.loadAdditionalData();
                        });
                        return Align(
                          alignment: Alignment.center,
                          child: CustomCircleProgressIndicator(size: 10, color: appActiveColor()),
                        );
                      }
                      return Container();
                    }
                  },
                ),
              ),
            ),
    );
  }
}
