import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class TicketPurchaseSuccessPage extends StatefulWidget {
  @override
  _TicketPurchaseSuccessPageState createState() => _TicketPurchaseSuccessPageState();
}

class _TicketPurchaseSuccessPageState extends State<TicketPurchaseSuccessPage> {
  bool userExists = false;
  bool isLoading = true;

  Widget ticketConfirmationContent(SizingInformation screenSize) {
    return Container(
      height: screenSize.isMobile ? MediaQuery.of(context).size.height * 0.85 : MediaQuery.of(context).size.height * 0.70,
      margin: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            context: context,
            text: "🎉 Purchase Successful! 🎉",
            textColor: Colors.black,
            textAlign: TextAlign.center,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 16),
          isLoading
              ? Container()
              : CustomText(
                  context: context,
                  text: "A purchase confirmation email has been sent to you. Your tickets are located in your wallet.",
                  textColor: Colors.black,
                  textAlign: TextAlign.center,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
          SizedBox(height: 8),
          CustomColorButton(
            text: "View Wallet",
            textColor: Colors.white,
            backgroundColor: CustomColors.webblenRed,
            height: 35.0,
            width: 150,
            onPressed: () => locator<NavigationService>().navigateTo(WalletRoute),
          ).showCursorOnHover
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ticketConfirmationContent(screenSize),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
