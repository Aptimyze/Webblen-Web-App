import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/tags/tag_button.dart';
import 'package:webblen_web_app/ui/widgets/user/user_profile_pic.dart';

import 'event_block_view_model.dart';

class EventBlockView extends StatelessWidget {
  final WebblenEvent event;
  final Function(WebblenEvent) showEventOptions;

  EventBlockView({required this.event, required this.showEventOptions});

  Widget eventStartDate(EventBlockViewModel model) {
    return Container(
      width: 50,
      child: Column(
        children: [
          SizedBox(height: 16),
          CustomText(
            text: event.startDate!.substring(4, event.startDate!.length - 6),
            color: appFontColor(),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            text: event.startDate!.substring(0, event.startDate!.length - 9),
            color: appFontColorAlt(),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          verticalSpaceTiny,
          GestureDetector(
            onTap: () => model.saveUnsaveEvent(event: event),
            child: Icon(
              model.savedEvent ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
              size: 18,
              color: model.savedEvent ? appSavedContentColor() : appIconColorAlt(),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventBody(BuildContext context, EventBlockViewModel model) {
    return Container(
      width: 400,
      child: Stack(
        children: [
          Container(
            height: 250,
            width: 350,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FadeInImage.memoryNetwork(
                image: event.imageURL!,
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
              ),
            ),
          ),
          Container(
            height: 250,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.4),
                ],
              ),
            ),
          ),
          Container(
            height: 250,
            width: 350,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => model.navigateToUserView(event.authorID),
                        child: Container(
                          child: Row(
                            children: [
                              UserProfilePic(
                                userPicUrl: model.authorImageURL,
                                size: 30,
                                isBusy: false,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              CustomText(
                                text: "@${model.authorUsername}",
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.more_horiz, color: Colors.white),
                              onPressed: () => showEventOptions(event),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: event.title,
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      verticalSpaceTiny,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "${event.city}, ${event.province}",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          model.eventIsHappeningNow
                              ? Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: appActiveColor(),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Happening Now",
                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      CustomText(
                                        text: "${event.startTime} - ${event.endTime}",
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      verticalSpaceSmall,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget eventTags(EventBlockViewModel model) {
    return event.tags == null || event.tags!.isEmpty
        ? Container()
        : Container(
            margin: EdgeInsets.only(top: 4, bottom: 8, right: 16),
            height: 30,
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 4.0,
                bottom: 4.0,
              ),
              itemCount: event.tags!.length,
              itemBuilder: (context, index) {
                return TagButton(
                  onTap: null,
                  tag: event.tags![index],
                );
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EventBlockViewModel>.reactive(
      onModelReady: (model) => model.initialize(event),
      viewModelBuilder: () => EventBlockViewModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : Align(
              alignment: Alignment.center,
              child: Container(
                height: 330,
                constraints: BoxConstraints(
                  maxWidth: 500,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: GestureDetector(
                  onDoubleTap: () => model.saveUnsaveEvent(event: event),
                  onLongPress: () {
                    HapticFeedback.lightImpact();
                    showEventOptions(event);
                  },
                  onTap: () => model.navigateToEventView(event.id!),
                  child: Row(
                    children: [
                      eventStartDate(model),
                      horizontalSpaceSmall,
                      eventBody(context, model),
                    ],
                  ),
                ),
              ).showCursorOnHover,
            ),
    );
  }
}
