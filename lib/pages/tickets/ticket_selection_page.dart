import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/constants/strings.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/firebase/data/platform.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/text_field_container.dart';
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
  double ticketRate;
  double taxRate;
  double ticketCharge = 0.00;
  double ticketFeeCharge = 0.00;
  double customFeeCharge = 0.00;
  double taxCharge = 0.00;
  double chargeAmount = 0.0;
  double discountAmount = 0.0;
  String discountCodeDescription;
  List<String> appliedDiscountCodes = [];
  String discountCodeStatus;
  String discountCode;
  List<String> ticketEmails = [];

  //Customer Info
  String firstName;
  String lastName;
  String emailAddress;
  String areaCode;

  //Card Info
  String paymentFormError;
  var cardNumberMask = MaskedTextController(mask: '0000 0000 0000 0000');
  var expiryDateMask = MaskedTextController(mask: 'XX/XX');
  bool cvcFocused = false;
  String stripeUID;
  String cardNumber = "";
  String expiryDate = "MM/YY";
  int expMonth = DateTime.now().month;
  int expYear = DateTime.now().year;
  String cardHolderName = "";
  String cvcNumber = "";
  String cardType;

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

  calculateChargeTotals() {
    //Custom Fees
//    customFeeCharge = 0.00;
//    ticketDistro.fees.forEach((fee) {
//      customFeeCharge += (numOfTicketsToPurchased * fee['feeAmount']);
//    });
    ticketFeeCharge = numOfTicketsToPurchased * ticketRate;
    print("ticketFee charge: $ticketFeeCharge");
    taxCharge = (ticketCharge + ticketFeeCharge) * taxRate;
    print("tax charge: $taxCharge");
    print("fee totals: ${ticketFeeCharge + taxCharge}");

    chargeAmount = ticketCharge + ticketFeeCharge + taxCharge + customFeeCharge;
    setState(() {});
  }

  applyDiscountCode() async {
    print('applying discount code..');
    discountCodeFormKey.currentState.save();
    print(discountCode);
    int discountCodeIndex = ticketDistro.discountCodes.indexWhere((code) => code['discountCodeName'] == discountCode);
    if (appliedDiscountCodes.contains(discountCode)) {
      discountCodeStatus = 'duplicate';
    } else if (appliedDiscountCodes.isNotEmpty) {
      discountCodeStatus = 'multiple';
    } else {
      if (discountCodeIndex >= 0) {
        Map<String, dynamic> code = ticketDistro.discountCodes[discountCodeIndex];
        double discountPercent = code['discountCodePercentage'];
        discountAmount = chargeAmount * discountPercent;
        print(discountPercent * 100);
        discountCodeDescription = "${(discountPercent * 100).toInt().toString()}% Off";
        chargeAmount = chargeAmount - discountAmount;
        appliedDiscountCodes.add(discountCode);
        discountCodeStatus = 'passed';
      } else {
        discountCodeStatus = 'failed';
      }
    }
    setState(() {});
    Navigator.pop(context);
    CustomAlerts().ShowLoadingAlert(context, 'Applying Code...');
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    showTicketPurchaseInfoDialog();
//    Navigator.of(context).pop();
//    showPurchaseDialog();
  }

  ticketChargeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ticketsToPurchase.length,
      itemBuilder: (BuildContext context, int index) {
        double ticketPrice = double.parse(ticketsToPurchase[index]['ticketPrice'].toString().substring(1));
        double ticketCharge = ticketPrice * ticketsToPurchase[index]['qty'];
        return ticketsToPurchase[index]['qty'] > 0
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                height: 40.0,
                //width: MediaQuery.of(context).size.width * 0.60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      //width: MediaQuery.of(context).size.width * 0.60,
                      child: CustomText(
                        context: context,
                        text: "${ticketsToPurchase[index]["ticketName"]} (${ticketsToPurchase[index]["qty"]})",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      //width: 95,
                      child: CustomText(
                        context: context,
                        text: "+ \$${ticketCharge.toStringAsFixed(2)}",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }

  feeChargeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ticketDistro.fees.length,
      itemBuilder: (BuildContext context, int index) {
        return ticketDistro.fees.length > 0
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                height: 40.0,
                //width: MediaQuery.of(context).size.width * 0.60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      //width: MediaQuery.of(context).size.width * 0.60,
                      child: CustomText(
                        context: context,
                        text: "${ticketDistro.fees[index]["feeName"]}",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      //width: 95,
                      child: CustomText(
                        context: context,
                        text: "+ ${ticketDistro.fees[index]["feeAmount"]}",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }

  showTicketPurchaseInfoDialog() {
    Alert(
      context: context,
      title: event.title,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 32.0),
            ticketChargeList(),
            //feeChargeList(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              height: 40.0,
              //width: MediaQuery.of(context).size.width * 0.60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.60,
                    child: CustomText(
                      context: context,
                      text: "Additional Fees & Sales Tax",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    //width: 95,
                    child: CustomText(
                      context: context,
                      text: "+ \$${(ticketFeeCharge + taxCharge).toStringAsFixed(2)}",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            discountAmount == 0.0
                ? Container()
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    height: 40.0,
                    //width: MediaQuery.of(context).size.width * 0.60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          //width: MediaQuery.of(context).size.width * 0.60,
                          child: CustomText(
                            context: context,
                            text: "Discount ($discountCodeDescription)",
                            textColor: Colors.black,
                            textAlign: TextAlign.left,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          //width: 95,
                          child: CustomText(
                            context: context,
                            text: "- \$${discountAmount.toStringAsFixed(2)}",
                            textColor: Colors.red,
                            textAlign: TextAlign.left,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              height: 1.0,
              color: Colors.black38,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CustomText(
                    context: context,
                    text: "Total: ",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    context: context,
                    text: "\$${chargeAmount.toStringAsFixed(2)}",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            discountCode == null
                ? Container()
                : discountCodeStatus == 'duplicate'
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                        child: CustomText(
                          context: context,
                          text: "This Code Has Already Been Used",
                          textColor: Colors.red,
                          textAlign: TextAlign.left,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : discountCodeStatus == 'passed'
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                            child: CustomText(
                              context: context,
                              text: "Discount Applied Successfully",
                              textColor: Colors.green,
                              textAlign: TextAlign.left,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : discountCodeStatus == 'multiple'
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                child: CustomText(
                                  context: context,
                                  text: "Only One Code Can Be Used at a Time",
                                  textColor: Colors.red,
                                  textAlign: TextAlign.left,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                                child: CustomText(
                                  context: context,
                                  text: "Invalid Code",
                                  textColor: Colors.red,
                                  textAlign: TextAlign.left,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: CustomText(
                context: context,
                text: "Discount Code:",
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Form(
                key: discountCodeFormKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFieldContainer(
                      height: 35,
                      width: 200.0, //screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                        onSaved: (value) => discountCode = value.trim(),
                        decoration: InputDecoration(
                          hintText: "Enter Discount Code",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    DialogButton(
                      height: 35,
                      width: 100.0,
                      onPressed: () => applyDiscountCode(),
                      color: CustomColors.darkGray,
                      child: CustomText(
                        context: context,
                        text: "Apply",
                        textColor: Colors.white,
                        textAlign: TextAlign.left,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ).showCursorOnHover,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            showPaymentForm();
          },
          color: CustomColors.darkMountainGreen,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Center(
              child: CustomText(
                context: context,
                text: "Continue",
                textColor: Colors.white,
                textAlign: TextAlign.center,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ).showCursorOnHover,
        ),
      ],
    ).show();
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
                          ),
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

  Widget ticketContent() {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.7,
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
                  text: "@username",
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

  //Card Transaction
  validateAndSubmitPayment() {
    CustomAlerts().ShowLoadingAlert(context, "Processing...");
    ticketPaymentFormKey.currentState.save();
    cardNumber = cardNumber.replaceAll(" ", "");
    if (firstName == null || firstName.isEmpty) {
      Navigator.pop(context);
      paymentFormError = "First Name Cannot be Empty";
    } else if (lastName == null || lastName.isEmpty) {
      Navigator.of(context).pop();
      paymentFormError = "First Name Cannot be Empty";
    } else if (emailAddress == null || emailAddress.isEmpty) {
      Navigator.of(context).pop();
      paymentFormError = "Email Address Cannot be Empty";
    } else if (!Strings().isEmailValid(emailAddress)) {
      Navigator.of(context).pop();
      paymentFormError = "Please Provide a Valid Email Address";
    } else if (cardNumber == null || cardNumber.length != 16) {
      Navigator.of(context).pop();
      paymentFormError = "First Name Cannot be Empty";
    } else if (expMonth < 1 || expMonth > 12) {
      Navigator.of(context).pop();
      paymentFormError = "Invalid Expiry Month";
    } else if (expYear < DateTime.now().year) {
      Navigator.of(context).pop();
      paymentFormError = "Invalid Expiry Year";
    } else if (cardHolderName == null || cardHolderName.isEmpty) {
      Navigator.of(context).pop();
      paymentFormError = "Name Cannot Be Empty";
    } else if (cvcNumber == null || cvcNumber.length != 3) {
      Navigator.of(context).pop();
      paymentFormError = "Invalid CVC Code";
    } else {
      submitPayment();
    }
  }

  void submitPayment() {
//    totalPlatformFees = salesTax + userPlatformFees;
//    StripeCard card = StripeCard(number: cardNumber, expMonth: expMonth, expYear: expYear, cvc: cvcNumber, name: cardHolderName);
//    StripeApi.instance.createPaymentMethodFromCard(card).then((res) {
//      StripeDataService()
//          .submitTicketPurchaseToStripe(widget.currentUser.uid, chargeAmount, totalPlatformFees, numberOfTickets, widget.ticketsToPurchase,
//                                            widget.event.eventKey, widget.event.authorUid, cardNumber, expMonth, expYear, cvcNumber, cardHolderName, emailAddress)
//          .then((res) {
//        Navigator.of(context).pop();
//        if (res == 'passed') {
//          completePurchase();
//        } else {
//          ShowAlertDialogService().showFailureDialog(context, "Payment Failed", "There was an Issue Processing Your Card.");
//        }
//      });
//    }).catchError((e) {
//      Navigator.of(context).pop();
//      String error = e.toString();
//      showFormAlert(error);
//    });
  }

  void completePurchase() {
//    EventDataService().completeTicketPurchase(widget.currentUser.uid, widget.ticketsToPurchase, widget.event).then((res) {
//      ShowAlertDialogService().showActionSuccessDialog(context, "Purchase Successful!", "Your Tickets Can Be Found in Your Account", () {
//        Navigator.of(context).pop();
//        PageTransitionService(context: context).returnToRootPage();
//      });
//    });
  }

  Widget emailAddressField() {
    return Container(
      margin: EdgeInsets.only(
        top: 4.0,
        left: 32.0,
        right: 32.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: CustomColors.iosOffWhite,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
        decoration: InputDecoration(
          hintText: "Your Email Address",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          emailAddress = val;
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  Widget cardNumberField() {
    return Container(
      margin: EdgeInsets.only(
        top: 4.0,
        left: 32.0,
        right: 32.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: CustomColors.iosOffWhite,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 250,
            child: TextFormField(
              controller: cardNumberMask,
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
              decoration: InputDecoration(
                hintText: "XXXX XXXX XXXX XXXX",
                contentPadding: EdgeInsets.only(
                  left: 8,
                  top: 8,
                  bottom: 8,
                ),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                cardNumber = val.replaceAll(" ", "");
                print(cardType);
                setState(() {});
              },
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "Helvetica Neue",
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              inputFormatters: [
                LengthLimitingTextInputFormatter(19),
              ],
              textInputAction: TextInputAction.done,
              autocorrect: false,
            ),
          ),
          Container(
            width: 50,
            child: Icon(
                cardType == null
                    ? FontAwesomeIcons.creditCard
                    : cardType == "Visa" ? FontAwesomeIcons.ccVisa : cardType == "MasterCard" ? FontAwesomeIcons.ccMastercard : FontAwesomeIcons.creditCard,
                size: 18.0,
                color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget expiryMonthField() {
    return Container(
      width: 100,
      margin: EdgeInsets.only(
        top: 4.0,
        left: 32.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: CustomColors.iosOffWhite,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "01",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          expMonth = int.parse(val);
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  Widget expiryYearField() {
    return Container(
      width: 100,
      margin: EdgeInsets.only(
        top: 4.0,
        left: 32.0,
        right: 32.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: CustomColors.iosOffWhite,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "2024",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          expYear = int.parse(val);
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  Widget cardHolderNameField() {
    return Container(
      margin: EdgeInsets.only(
        top: 4.0,
        left: 32.0,
        right: 32.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: CustomColors.iosOffWhite,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Your Name",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          cvcFocused = false;
          cardHolderName = val;
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  Widget cvcField() {
    return Container(
      width: 100,
      margin: EdgeInsets.only(
        top: 4.0,
        left: 32.0,
        right: 32.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: CustomColors.iosOffWhite,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "XXX",
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          cvcFocused = true;
          cvcNumber = val;
          setState(() {});
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: "Helvetica Neue",
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }

  showPaymentForm() {
    Alert(
      context: context,
      title: event.title,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 32.0,
                right: 32.0,
                bottom: 4.0,
                top: 32.0,
              ),
              child: CustomText(
                context: context,
                text: "Email Address",
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            emailAddressField(),
            Container(
              margin: EdgeInsets.only(
                left: 32.0,
                right: 32.0,
                bottom: 4.0,
              ),
              child: CustomText(
                context: context,
                text: "Card Holder Name",
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            cardHolderNameField(),
            Container(
              margin: EdgeInsets.only(
                left: 32.0,
                right: 32.0,
                bottom: 4.0,
              ),
              child: CustomText(
                context: context,
                text: "Card Number",
                textColor: Colors.black,
                textAlign: TextAlign.left,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            cardNumberField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: 32.0,
                        right: 16.0,
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "Expiry Month",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    expiryMonthField(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: 32.0,
                        right: 32.0,
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "Expiry Year",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    expiryYearField(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: 32.0,
                        right: 32.0,
                        bottom: 4.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "CVC",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    cvcField(),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 32.0),
                  child: CustomText(
                    context: context,
                    text: "Purchase Total: \$${chargeAmount.toStringAsFixed(2)}",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            showTicketPurchaseInfoDialog();
          },
          color: CustomColors.textFieldGray,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Center(
              child: CustomText(
                context: context,
                text: "View Tickets",
                textColor: Colors.black,
                textAlign: TextAlign.center,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ).showCursorOnHover,
        ),
        DialogButton(
          onPressed: null,
          color: CustomColors.darkMountainGreen,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Center(
              child: CustomText(
                context: context,
                text: "Purchase Tickets",
                textColor: Colors.white,
                textAlign: TextAlign.center,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ).showCursorOnHover,
        ),
      ],
    ).show();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EventDataService().getEvent(widget.eventID).then((res) {
      event = res;
      EventDataService().getEventTicketDistro(widget.eventID).then((res) {
        ticketDistro = res;
        ticketDistro.tickets.forEach((ticket) {
          Map<String, dynamic> tData = Map<String, dynamic>.from(ticket);
          tData['qty'] = 0;
          ticketsToPurchase.add(tData);
        });
        PlatformDataService().getEventTicketFee().then((res) {
          ticketRate = res;
          PlatformDataService().getTaxRate().then((res) {
            taxRate = res;
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
    return Container(
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
                      ticketContent(),
                    ],
                  ),
                ),
          Footer(),
        ],
      ),
    );
  }
}
