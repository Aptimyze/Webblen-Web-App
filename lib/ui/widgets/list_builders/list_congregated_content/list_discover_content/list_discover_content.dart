import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/events/event_block/event_block_view.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_live_streams/horizontal_feed/list_horizontal_streams_feed.dart';
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
          : Container(
              height: screenHeight(context),
              color: appBackgroundColor,
              child: RefreshIndicator(
                onRefresh: model.refreshData,
                backgroundColor: appBackgroundColor,
                color: appFontColorAlt(),
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: model.dataResults.length + 1,
                  itemBuilder: (context, index) {
                    Map<String, dynamic>? snapshotData;
                    if (index != 0) {
                      snapshotData = model.dataResults[index - 1].data() as Map<String, dynamic>;
                    }
                    return LazyLoadingList(
                      key: PageStorageKey(model.listKey),
                      initialSizeOfItems: model.dataResults.length,
                      loadMore: () => model.loadAdditionalData(),
                      child: index == 0
                          ? _StreamsFeed()
                          : snapshotData!['postDateTimeInMilliseconds'] != null
                              ? model.getPostWidget(snapshotData)
                              : snapshotData['venueSize'] != null
                                  ? model.getEventWidget(snapshotData)
                                  : SizedBox(height: 0, width: 0),
                      index: index,
                      hasMore: model.moreDataAvailable,
                    );
                  },
                ),
              ),
            ),
    );
  }
}

class _StreamsFeed extends HookViewModelWidget<ListDiscoverContentModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ListDiscoverContentModel model) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 175,
          maxWidth: 500,
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: ListHorizontalStreamsFeed(),
        ),
      ),
    );
  }
}

class _PostsAndEventsFeed extends HookViewModelWidget<ListDiscoverContentModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ListDiscoverContentModel model) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
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
    );
  }
}
