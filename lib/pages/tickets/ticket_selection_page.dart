import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class TicketSelectionPage extends StatefulWidget {
  final String eventID;

  TicketSelectionPage({this.eventID});

  @override
  State<StatefulWidget> createState() {
    return _TicketSelectionPageState();
  }
}

class _TicketSelectionPageState extends State<TicketSelectionPage> {
  bool isLoading = true;
  //Keys
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ticketQuantityFormKey = GlobalKey<FormState>();
  final ticketPaymentFormKey = GlobalKey<FormState>();
  final discountCodeFormKey = GlobalKey<FormState>();

  //Event Info
  WebblenUser eventHost;
  WebblenEvent event;
  TicketDistro ticketDistro;

  //payments
  List<String> ticketPurchaseAmounts = ['0', '1', '2', '3', '4'];
  List<Map<String, dynamic>> ticketsToPurchase = [];
  int numOfTicketsToPurchased = 0;
  double ticketCharge = 0.00;

  //TICKETING
  didSelectTicketQty(String selectedValue, int index) {
    numOfTicketsToPurchased = 0;
    ticketCharge = 0.00;
    int qtyAmount = int.parse(selectedValue);
    ticketsToPurchase[index]['qty'] = qtyAmount;
    ticketsToPurchase.forEach((ticket) {
      print(ticket);
      double ticketPrice = double.parse(ticket['ticketPrice'].toString().substring(1));
      double charge = ticketPrice * ticket['qty'];
      numOfTicketsToPurchased += ticket['qty'];
      ticketCharge += charge;
    });
    print(ticketCharge);
    print(numOfTicketsToPurchased);
    setState(() {});
  }

  Widget ticketListBuilder() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: ticketsToPurchase.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 40.0,
            margin: EdgeInsets.only(top: 8.0),
            //width: MediaQuery.of(context).size.width * 0.60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  //width: MediaQuery.of(context).size.width * 0.60,
                  child: CustomText(
                    context: context,
                    text: ticketsToPurchase[index]["ticketName"],
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  width: 150.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomText(
                        context: context,
                        text: ticketsToPurchase[index]["ticketPrice"],
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: CustomColors.textFieldGray,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            4.0,
                          ),
                          child: DropdownButton<String>(
                            underline: Container(),
                            iconSize: 16.0,
                            isDense: true,
                            isExpanded: false,
                            value: ticketsToPurchase[index]['qty'].toString(),
                            items: ticketPurchaseAmounts.map((val) {
                              return DropdownMenuItem(
                                child: CustomText(
                                  context: context,
                                  text: val,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.left,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                value: val,
                              );
                            }).toList(),
                            onChanged: (val) => didSelectTicketQty(val, index),
                          ).showCursorOnHover,
                        ),
                      ),
                      SizedBox(width: 8.0),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget ticketContent(SizingInformation screenSize) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: screenSize.isMobile
          ? MediaQuery.of(context).size.width * 0.9
          : screenSize.isTablet ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1.5,
            blurRadius: 2.0,
            offset: Offset(0.0, 1.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8.0),
          CustomText(
            context: context,
            text: event.title,
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 32.0,
            fontWeight: FontWeight.w700,
          ),
          Row(
            children: <Widget>[
              CustomText(
                context: context,
                text: "Hosted By ",
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
              GestureDetector(
                onTap: null,
                child: CustomText(
                  context: context,
                  text: "@${eventHost.username}",
                  textColor: CustomColors.webblenRed,
                  textAlign: TextAlign.left,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ).showCursorOnHover,
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.mapMarkerAlt,
                size: 14.0,
                color: Colors.black38,
              ),
              SizedBox(width: 4.0),
              CustomText(
                context: context,
                text: "${event.city}, ${event.province}",
                textColor: Colors.black38,
                textAlign: TextAlign.left,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          CustomText(
            context: context,
            text: "${event.startDate} | ${event.startTime}",
            textColor: Colors.black38,
            textAlign: TextAlign.left,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 40.0,
            decoration: BoxDecoration(
              color: CustomColors.iosOffWhite,
              border: Border.all(
                color: Colors.black26,
                width: 0.8,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: CustomText(
                    context: context,
                    text: "Ticket Type",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomText(
                        context: context,
                        text: "Price",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        context: context,
                        text: "Qty",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(width: 8.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ticketListBuilder(),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ticketsToPurchase.where((ticket) => ticket['qty'] != 0).length == 0
                  ? CustomColorButton(
                      text: "Purchase Tickets",
                      textColor: Colors.black38,
                      backgroundColor: Colors.white,
                      height: 35.0,
                      width: 150,
                      onPressed: null,
                    )
                  : CustomColorButton(
                      text: "Purchase Tickets",
                      textColor: Colors.white,
                      backgroundColor: CustomColors.darkMountainGreen,
                      height: 35.0,
                      width: 150,
                      onPressed: () {
                        event.navigateToPurchaseTicketsPage(event.id, ticketsToPurchase);
//                        calculateChargeTotals();
//                        showTicketPurchaseInfoDialog();
                      },
                    ).showCursorOnHover,
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EventDataService().getEvent(widget.eventID).then((res) {
      event = res;
      WebblenUserData().getUser(event.authorID).then((res) {
        eventHost = res;
        EventDataService().getEventTicketDistro(widget.eventID).then((res) {
          ticketDistro = res;
          ticketDistro.tickets.forEach((ticket) {
            Map<String, dynamic> tData = Map<String, dynamic>.from(ticket);
            tData['qty'] = 0;
            ticketsToPurchase.add(tData);
            isLoading = false;
            setState(() {});
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
            isLoading
                ? Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 200,
                    ),
                  )
                : Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 200,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ticketContent(screenSize),
                      ],
                    ),
                  ),
            Footer(),
          ],
        ),
      ),
    );
  }
}
