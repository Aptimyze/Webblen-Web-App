import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/live_streams/live_stream_block/live_stream_block_view.dart';

import 'list_home_live_streams_model.dart';

class ListHomeLiveStreams extends StatelessWidget {
  final Function(WebblenLiveStream) showStreamOptions;

  ListHomeLiveStreams({
    @required this.showStreamOptions,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListHomeLiveStreamsModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => locator<ListHomeLiveStreamsModel>(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
              ? ZeroStateView(
                  scrollController: model.scrollController,
                  imageAssetName: "video_phone",
                  imageSize: 200,
                  header: "No Streams in ${model.webblenBaseViewModel.cityName} Found",
                  subHeader: model.webblenBaseViewModel.streamPromo != null
                      ? "Schedule a Stream for ${model.cityName} Now and Earn ${model.webblenBaseViewModel.streamPromo.toStringAsFixed(2)} WBLN!"
                      : "Schedule a Stream for ${model.cityName} Now!",
                  mainActionButtonTitle: model.webblenBaseViewModel.streamPromo != null
                      ? "Earn ${model.webblenBaseViewModel.streamPromo.toStringAsFixed(2)} WBLN"
                      : "Create Stream",
                  mainAction: () => model.webblenBaseViewModel.navigateToCreateStreamPage(
                    id: null,
                    addPromo: model.webblenBaseViewModel.streamPromo != null,
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
                      key: PageStorageKey('home-streams'),
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      itemCount: model.dataResults.length + 1,
                      itemBuilder: (context, index) {
                        if (index < model.dataResults.length) {
                          WebblenLiveStream stream;
                          stream = WebblenLiveStream.fromMap(model.dataResults[index].data());
                          return LiveStreamBlockView(
                            stream: stream,
                            showStreamOptions: (stream) => showStreamOptions(stream),
                          );
                        } else {
                          if (model.moreDataAvailable) {
                            model.loadAdditionalData();
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
