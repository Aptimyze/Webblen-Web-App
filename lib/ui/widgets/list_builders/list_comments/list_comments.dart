import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_post_comment.dart';
import 'package:webblen_web_app/ui/widgets/comments/comment_block/comment_block_view.dart';

class ListComments extends StatelessWidget {
  final List results;
  final bool showingReplies;
  final VoidCallback refreshData;
  final PageStorageKey pageStorageKey;
  final ScrollController scrollController;
  final bool refreshingData;
  final Function(WebblenPostComment) replyToComment;
  final Function(WebblenPostComment) deleteComment;
  ListComments({
    @required this.refreshData,
    @required this.results,
    @required this.showingReplies,
    @required this.pageStorageKey,
    @required this.scrollController,
    @required this.refreshingData,
    @required this.replyToComment,
    @required this.deleteComment,
  });

  Widget listReplies(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            WebblenPostComment comment;

            ///GET POST OBJECT
            if (results[index] is DocumentSnapshot) {
              comment = WebblenPostComment.fromMap(results[index].data());
            } else if (results[index] is Map<String, dynamic>) {
              comment = WebblenPostComment.fromMap(results[index]);
            } else {
              comment = results[index];
            }

            return CommentBlockView(
              replyToComment: replyToComment == null ? null : (val) => replyToComment(val),
              deleteComment: deleteComment == null ? null : (val) => deleteComment(val),
              comment: comment,
            );
          },
        ),
      ],
    ));
  }

  Widget listResults() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      controller: scrollController,
      key: pageStorageKey,
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      padding: EdgeInsets.only(
        top: 4.0,
        bottom: 4.0,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        WebblenPostComment comment;

        ///GET POST COMMENT OBJECT
        if (results[index] is DocumentSnapshot) {
          comment = WebblenPostComment.fromMap(results[index].data());
        } else {
          comment = results[index];
        }

        return CommentBlockView(
          replyToComment: (val) => replyToComment(val),
          deleteComment: (val) => deleteComment(val),
          comment: comment,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBackgroundColor,
      child: showingReplies ? listReplies(context) : listResults(),
    );
  }
}