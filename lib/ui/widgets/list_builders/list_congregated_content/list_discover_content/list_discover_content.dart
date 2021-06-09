import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/events/event_block/event_block_view.dart';
import 'package:webblen_web_app/ui/widgets/live_streams/live_stream_block/live_stream_block_view.dart';
import 'package:webblen_web_app/ui/widgets/posts/post_img_block/post_img_block_view.dart';
import 'package:webblen_web_app/ui/widgets/posts/post_text_block/post_text_block_view.dart';

import 'list_discover_content_model.dart';

class ListDiscoverContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListDiscoverContentModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => ListDiscoverContentModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
              ? ZeroStateView(
                  scrollController: model.scrollController,
                  imageAssetName: "modern_city",
                  imageSize: 200,
                  header: "No Posts, Streams, or Events in ${model.cityName} Found",
                  subHeader: "Create Something for ${model.cityName} Now!",
                  mainActionButtonTitle: "Create",
                  mainAction: () => model.customBottomSheetService.showAddContentOptions(),
                  secondaryActionButtonTitle: null,
                  secondaryAction: null,
                  refreshData: model.refreshData,
                )
              : Container(
                  height: screenHeight(context),
                  color: appBackgroundColor,
                  child: RefreshIndicator(
                    onRefresh: model.refreshData,
                    backgroundColor: appBackgroundColor,
                    color: appFontColorAlt(),
                    child: SingleChildScrollView(
                      controller: model.scrollController,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        key: PageStorageKey(model.listKey),
                        shrinkWrap: true,
                        itemCount: model.dataResults.length + 1,
                        itemBuilder: (context, index) {
                          if (index < model.dataResults.length) {
                            if (model.dataResults[index].data()!['postDateTimeInMilliseconds'] != null) {
                              WebblenPost post;
                              post = WebblenPost.fromMap(model.dataResults[index].data()!);
                              return post.imageURL == null
                                  ? PostTextBlockView(
                                      post: post,
                                      showPostOptions: (post) => model.showContentOptions(post),
                                    )
                                  : PostImgBlockView(
                                      post: post,
                                      showPostOptions: (post) => model.showContentOptions(post),
                                    );
                            } else if (model.dataResults[index].data()!['hostID'] != null) {
                              WebblenLiveStream stream;
                              stream = WebblenLiveStream.fromMap(model.dataResults[index].data()!);
                              return LiveStreamBlockView(
                                stream: stream,
                                showStreamOptions: (stream) => model.showContentOptions(stream),
                              );
                            } else if (model.dataResults[index].data()!['venueSize'] != null) {
                              WebblenEvent event;
                              event = WebblenEvent.fromMap(model.dataResults[index].data()!);
                              return EventBlockView(
                                event: event,
                                showEventOptions: (event) => model.showContentOptions(event),
                              );
                            } else {
                              return SizedBox(height: 0, width: 0);
                            }
                          } else {
                            if (model.moreDataAvailable) {
                              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                await model.loadAdditionalData();
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
                ),
    );
  }
}
