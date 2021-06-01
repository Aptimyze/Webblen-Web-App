import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/posts/post_view/post_view_model.dart';
import 'package:webblen_web_app/ui/widgets/comments/comment_text_field/comment_text_field_view.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text_with_links.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/list_builders/list_comments/list_comments.dart';
import 'package:webblen_web_app/ui/widgets/notices/open_app/open_app_block_view.dart';
import 'package:webblen_web_app/ui/widgets/user/user_profile_pic.dart';
import 'package:webblen_web_app/utils/time_calc.dart';

class PostView extends StatelessWidget {
  final String? id;
  PostView(@PathParam() this.id);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostViewModel>.reactive(
      onModelReady: (model) => model.initialize(id),
      viewModelBuilder: () => PostViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: CustomTopNavBar(
            navBarItems: [
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(0),
                iconData: FontAwesomeIcons.home,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(1),
                iconData: FontAwesomeIcons.search,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(2),
                iconData: FontAwesomeIcons.wallet,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(3),
                iconData: FontAwesomeIcons.user,
                isActive: false,
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => model.unFocusKeyboard(context),
          child: Container(
            height: screenHeight(context),
            color: appBackgroundColor,
            child: model.isBusy
                ? Container()
                : model.post == null
                    ? Container()
                    : Stack(
                        children: [
                          RefreshIndicator(
                            backgroundColor: appBackgroundColor,
                            onRefresh: () async {},
                            child: ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: model.postScrollController,
                              shrinkWrap: true,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 500,
                                    ),
                                    child: Column(
                                      children: [
                                        _Body(),
                                        _Comments(),
                                        SizedBox(height: 100),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CommentTextFieldView(
                              onSubmitted: model.isReplying
                                  ? (val) => model.replyToComment(
                                        context: context,
                                        commentData: val,
                                      )
                                  : (val) => model.submitComment(context: context, commentData: val),
                              focusNode: model.focusNode,
                              commentTextController: model.commentTextController,
                              isReplying: model.isReplying,
                              replyReceiverUsername: model.isReplying ? model.commentToReplyTo!.username : null,
                              contentID: '',
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}

class _Head extends HookViewModelWidget<PostViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () => model.navigateToUserView(model.author!.id),
            child: Row(
              children: <Widget>[
                UserProfilePic(
                  isBusy: false,
                  userPicUrl: model.author!.profilePicURL,
                  size: 35,
                ),
                horizontalSpaceSmall,
                Text(
                  "@${model.author!.username}",
                  style: TextStyle(color: appFontColor(), fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => model.customBottomSheetService.showContentOptions(content: model.post),
            icon: Icon(
              FontAwesomeIcons.ellipsisH,
              size: 16,
              color: appIconColor(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenAppNotice extends HookViewModelWidget<PostViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
    return OpenAppBlock(content: model.post!);
  }
}

class _Image extends HookViewModelWidget<PostViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
    return FadeInImage.memoryNetwork(
      image: model.post!.imageURL!,
      fit: BoxFit.cover,
      placeholder: kTransparentImage,
    );
  }
}

class _Message extends HookViewModelWidget<PostViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
    List<TextSpan> linkifiedText = [];

    if (model.post!.imageURL == null) {
      linkifiedText = linkify(text: model.post!.body!.trim(), fontSize: 18);
    } else {
      TextSpan usernameTextSpan = TextSpan(
        text: '@${model.author!.username} ',
        style: TextStyle(
          color: appFontColor(),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      linkifiedText.add(usernameTextSpan);
      linkifiedText.addAll(linkify(text: model.post!.body!.trim(), fontSize: 14));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        text: TextSpan(
          children: linkifiedText,
        ),
      ),
    );
  }
}

class _CommentCountAndTime extends HookViewModelWidget<PostViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.comment,
                size: 16,
                color: appFontColor(),
              ),
              horizontalSpaceSmall,
              Text(
                model.post!.commentCount.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: appFontColor(),
                ),
              ),
            ],
          ),
          Text(
            TimeCalc().getPastTimeFromMilliseconds(model.post!.postDateTimeInMilliseconds!),
            style: TextStyle(
              color: appFontColorAlt(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Comments extends HookViewModelWidget<PostViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      child: ListComments(
        refreshData: () async {},
        scrollController: null,
        showingReplies: false,
        pageStorageKey: model.commentStorageKey,
        refreshingData: false,
        results: model.commentResults,
        replyToComment: (val) => model.toggleReply(model.focusNode, val),
        deleteComment: (val) => model.showDeleteCommentConfirmation(context: context, comment: val),
      ),
    );
  }
}

class _Body extends HookViewModelWidget<PostViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
    return model.post!.imageURL == null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                verticalSpaceSmall,
                _OpenAppNotice(),
                verticalSpaceSmall,
                _Head(),
                verticalSpaceSmall,
                _Message(),
                verticalSpaceSmall,
                _CommentCountAndTime(),
                verticalSpaceSmall,
                Divider(
                  thickness: 8.0,
                  color: appDividerColor(),
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                verticalSpaceSmall,
                _Head(),
                verticalSpaceSmall,
                _Image(),
                verticalSpaceSmall,
                _CommentCountAndTime(),
                verticalSpaceSmall,
                _Message(),
                verticalSpaceSmall,
                Divider(
                  thickness: 8.0,
                  color: appDividerColor(),
                ),
              ],
            ),
          );
  }
}
