import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/live_streams/live_stream_block/live_stream_block_view.dart';

import 'list_home_live_streams_model.dart';

class ListHomeLiveStreams extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListHomeLiveStreamsModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => ListHomeLiveStreamsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
          ? ZeroStateView(
              scrollController: model.scrollController,
              imageAssetName: "video_phone",
              imageSize: 200,
              header: "No Streams in ${model.cityName} Found",
              subHeader: model.webblenBaseViewModel!.streamPromo != null
                  ? "Schedule a Stream for ${model.cityName} Now and Earn ${model.webblenBaseViewModel!.streamPromo!.toStringAsFixed(2)} WBLN!"
                  : "Schedule a Stream for ${model.cityName} Now!",
              mainActionButtonTitle: model.webblenBaseViewModel!.streamPromo != null
                  ? "Earn ${model.webblenBaseViewModel!.streamPromo!.toStringAsFixed(2)} WBLN"
                  : "Create Stream",
              mainAction: () => model.webblenBaseViewModel!.navigateToCreateStreamPage(
                id: null,
                addPromo: model.webblenBaseViewModel!.streamPromo != null,
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
                  cacheExtent: 8000,
                  controller: model.scrollController,
                  key: PageStorageKey(model.listKey),
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  itemCount: model.dataResults.length + 1,
                  itemBuilder: (context, index) {
                    if (index < model.dataResults.length) {
                      WebblenLiveStream stream;
                      stream = WebblenLiveStream.fromMap(model.dataResults[index].data()!);
                      return LiveStreamBlockView(
                        stream: stream,
                        showStreamOptions: (stream) => model.showContentOptions(stream),
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
