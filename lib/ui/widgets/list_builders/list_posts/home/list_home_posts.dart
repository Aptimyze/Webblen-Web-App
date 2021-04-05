import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_posts/home/list_home_posts_model.dart';
import 'package:webblen_web_app/ui/widgets/posts/post_img_block/post_img_block_view.dart';
import 'package:webblen_web_app/ui/widgets/posts/post_text_block/post_text_block_view.dart';

class ListHomePosts extends StatelessWidget {
  final Function(WebblenPost) showPostOptions;

  ListHomePosts({
    @required this.showPostOptions,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListHomePostsModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => locator<ListHomePostsModel>(),
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
                )
              : Container(
                  height: screenHeight(context),
                  color: appBackgroundColor,
                  child: RefreshIndicator(
                    onRefresh: model.refreshData,
                    child: ListView.builder(
                      controller: model.scrollController,
                      key: PageStorageKey('home-posts'),
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      itemCount: model.dataResults.length,
                      itemBuilder: (context, index) {
                        WebblenPost post;
                        post = WebblenPost.fromMap(model.dataResults[index].data());
                        return post.imageURL == null
                            ? PostTextBlockView(
                                post: post,
                                showPostOptions: (post) => showPostOptions(post),
                              )
                            : PostImgBlockView(
                                post: post,
                                showPostOptions: (post) => showPostOptions(post),
                              );
                      },
                    ),
                  ),
                ),
    );
  }
}
