import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/user/user_block/user_block_view_model.dart';

import '../user_profile_pic.dart';

class UserBlockView extends StatelessWidget {
  final WebblenUser user;
  final bool displayBottomBorder;
  UserBlockView({this.user, this.displayBottomBorder});

  final WebblenBaseViewModel _webblenBaseViewModel = locator<WebblenBaseViewModel>();

  Widget isFollowingUser() {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.userAlt,
            size: 10,
            color: appIconColorAlt(),
          ),
          horizontalSpaceTiny,
          CustomText(
            text: "following",
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: appFontColorAlt(),
          ),
        ],
      ),
    );
  }

  Widget body(UserBlockViewModel model) {
    return GestureDetector(
      onTap: () => model.navigateToUserView(user.id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: displayBottomBorder ? appBorderColor() : Colors.transparent, width: 0.5),
          ),
        ),
        child: Row(
          children: <Widget>[
            UserProfilePic(userPicUrl: user.profilePicURL, size: 35, isBusy: false),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _webblenBaseViewModel.user != null && _webblenBaseViewModel.user.following.contains(user.id) ? isFollowingUser() : Container(),
                CustomText(
                  text: "@${user.username}",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: appFontColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserBlockViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      fireOnModelReadyOnce: true,
      viewModelBuilder: () => UserBlockViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => model.navigateToUserView(user.id),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              body(model),
            ],
          ),
        ),
      ),
    ).showCursorOnHover;
  }
}
