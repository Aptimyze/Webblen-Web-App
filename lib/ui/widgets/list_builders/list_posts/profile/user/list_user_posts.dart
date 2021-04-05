import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/zero_state_view.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_posts/profile/user/list_user_posts_model.dart';
import 'package:webblen_web_app/ui/widgets/posts/post_img_block/post_img_block_view.dart';
import 'package:webblen_web_app/ui/widgets/posts/post_text_block/post_text_block_view.dart';

class ListUserPosts extends StatelessWidget {
  final WebblenUser user;
  final Function(WebblenPost) showPostOptions;

  ListUserPosts({
    @required this.user,
    @required this.showPostOptions,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListUserPostsModel>.reactive(
      onModelReady: (model) => model.initialize(id: user.id),
      viewModelBuilder: () => ListUserPostsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
              ? ZeroStateView(
                  imageAssetName: "umbrella_chair",
                  imageSize: 200,
                  header: "@${user.username} Does Not Have Any Posts",
                  subHeader: "Maybe someday they will? Check back later",
                  mainActionButtonTitle: null,
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
                      controller: model.scrollController,
                      key: PageStorageKey('user-posts'),
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
                        // if (model.dataResults[index] is WebblenPost) {
                        //   post = model.dataResults[index];
                        // } else {
                        //   post = WebblenPost.fromMap(model.dataResults[index].data());
                        // }

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
