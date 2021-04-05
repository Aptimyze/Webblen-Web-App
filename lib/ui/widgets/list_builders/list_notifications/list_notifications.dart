import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_notification.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/notifications/notification_block/notification_block_widget.dart';

class ListNotifications extends StatelessWidget {
  final List data;
  final VoidCallback refreshData;
  final PageStorageKey pageStorageKey;
  final ScrollController scrollController;
  ListNotifications({@required this.refreshData, @required this.data, @required this.pageStorageKey, @required this.scrollController});

  Widget listCauses() {
    return RefreshIndicator(
      onRefresh: refreshData,
      backgroundColor: appBackgroundColor,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        key: pageStorageKey,
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: 4.0,
          bottom: 4.0,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          WebblenNotification notification;

          ///GET CAUSE OBJECT
          if (data[index] is DocumentSnapshot) {
            notification = WebblenNotification.fromMap(data[index].data());
          } else {
            notification = data[index];
          }

          return NotificationBlockWidget(
            notification: notification,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      color: appBackgroundColor,
      child: listCauses(),
    );
  }
}