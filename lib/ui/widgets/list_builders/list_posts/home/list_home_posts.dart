import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_posts/home/list_home_posts_model.dart';
import 'package:webblen_web_app/ui/widgets/posts/post_img_block/post_img_block_view.dart';
import 'package:webblen_web_app/ui/widgets/posts/post_text_block/post_text_block_view.dart';

class ListHomePosts extends StatefulWidget {
  @override
  _ListHomePostsState createState() => _ListHomePostsState();
}

class _ListHomePostsState extends State<ListHomePosts> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<ListHomePostsModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => ListHomePostsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
          ? ZeroStateView(
              imageAssetName: "umbrella_chair",
              imageSize: 200,
              header: "You Have No Posts",
              subHeader: "Create a New Post to Share with the Community",
              mainActionButtonTitle: "Create Post",
              mainAction: () => model.webblenBaseViewModel.navigateToCreatePostPage(),
              secondaryActionButtonTitle: null,
              secondaryAction: null,
              refreshData: model.refreshData,
              scrollController: null,
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
