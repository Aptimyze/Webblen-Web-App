import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/vertical_schedule_stream_button/vertical_schedule_stream_button.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/live_streams/vertical_live_stream_block/vertical_live_stream_block_view.dart';

import 'list_horizontal_streams_feed_model.dart';

class ListHorizontalStreamsFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListHorizontalStreamsFeedModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => ListHorizontalStreamsFeedModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : ListView.builder(
              controller: model.scrollController,
              padding: EdgeInsets.symmetric(vertical: 10),
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              key: PageStorageKey(model.listKey),
              addAutomaticKeepAlives: true,
              shrinkWrap: true,
              itemCount: model.dataResults.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return VerticalScheduleStreamButton();
                } else if (index < model.dataResults.length + 1) {
                  WebblenLiveStream stream;
                  stream = WebblenLiveStream.fromMap(model.dataResults[index - 1].data()!);
                  return VerticalLiveStreamBlockView(
                    stream: stream,
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
    );
  }
}
