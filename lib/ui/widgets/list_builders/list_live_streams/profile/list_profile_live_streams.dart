import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/live_streams/live_stream_block/live_stream_block_view.dart';

import 'list_profile_live_streams_model.dart';

class ListProfileLiveStreams extends StatelessWidget {
  final String id;
  final bool isCurrentUser;
  final ScrollController? scrollController;
  ListProfileLiveStreams({required this.id, required this.isCurrentUser, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListProfileLiveStreamsModel>.reactive(
      onModelReady: (model) => model.initialize(
        uid: id,
        embeddedScrollController: scrollController == null ? null : scrollController,
      ),
      viewModelBuilder: () => ListProfileLiveStreamsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
          ? isCurrentUser
              ? ZeroStateView(
                  imageAssetName: "video_phone",
                  imageSize: 200,
                  header: "You Do Not Have Any Streams",
                  subHeader: "Schedule a New Stream to Share with the Community",
                  mainActionButtonTitle: "Create Stream",
                  mainAction: () => model.webblenBaseViewModel!.navigateToCreateStreamPage(
                    id: null,
                    addPromo: false,
                  ),
                  secondaryActionButtonTitle: null,
                  secondaryAction: null,
                  refreshData: model.refreshData,
                  scrollController: scrollController == null ? model.scrollController : scrollController,
                )
              : ZeroStateView(
                  scrollController: model.scrollController,
                  imageAssetName: "video_phone",
                  imageSize: 200,
                  header: "This Account Has No Streams",
                  subHeader: "Check Back Later",
                  mainActionButtonTitle: "",
                  mainAction: null,
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
                  controller: scrollController == null ? model.scrollController : scrollController,
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
