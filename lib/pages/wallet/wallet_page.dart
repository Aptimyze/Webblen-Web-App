import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/models/event_ticket.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/common/url_service.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_payment.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/zero_state_view.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/events/event_ticket_block.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool isLoading = true;
  bool loadingTickets = true;
  bool userAccountSetup = false;
  String currentUID;
  bool dismissedNotice = false;
  String stripeConnectURL;
  bool stripeAccountIsSetup = false;
  String stripeUID;
  List<WebblenEvent> events = [];
  List<String> loadedEvents = [];
  Map<String, dynamic> ticsPerEvent = {};

  organizeNumOfTicketsByEvent(List<EventTicket> eventTickets) async {
    eventTickets.forEach((ticket) async {
      if (!loadedEvents.contains(ticket.eventID)) {
        loadedEvents.add(ticket.eventID);
        WebblenEvent event = await EventDataService().getEvent(ticket.eventID);
        if (event != null) {
          events.add(event);
          loadingTickets = false;
          setState(() {});
        }
      }
      if (ticsPerEvent[ticket.eventID] == null) {
        ticsPerEvent[ticket.eventID] = 1;
      } else {
        ticsPerEvent[ticket.eventID] += 1;
      }
      if (eventTickets.last == ticket) {
        setState(() {});
      }
    });
  }

  Widget ticketList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: EventTicketBlock(
            eventDescHeight: 120,
            event: events[index],
            shareEvent: null, //() => Share.share("https://app.webblen.io/#/event?id=${events[index].id}"),
            numOfTicsForEvent: ticsPerEvent[events[index].id],
            viewEventDetails: () => events[index].navigateToEvent(events[index].id),
            viewEventTickets: () => events[index].navigateToWalletTickets(events[index].id),
          ),
        );
      },
    );
  }

  Widget createEarningsAccountNotice() {
    return dismissedNotice
        ? Container()
        : Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: CustomColors.textFieldGray,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Row(
                  children: <Widget>[
                    CustomText(
                      context: context,
                      text: "Interested in Selling Tickets through Webblen for FREE? Create an Earnings Account to Get Started!",
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => URLService().openURL(context, stripeConnectURL),
                      child: CustomText(
                        context: context,
                        text: "Create Earnings Account",
                        textColor: Colors.blueAccent,
                        textAlign: TextAlign.left,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        underline: true,
                      ),
                    ).showCursorOnHover,
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    dismissedNotice = true;
                    setState(() {});
                  },
                  child: Icon(
                    FontAwesomeIcons.times,
                    color: Colors.black45,
                    size: 14.0,
                  ),
                ).showCursorOnHover,
              ],
            ),
          );
  }

  Widget completeAccountSetupNotice() {
    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: CustomColors.textFieldGray,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomText(
            context: context,
            text: "Earn Rewards through Webblen for Attending Events. Complete Your Account Setup to Get Started!",
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(width: 8.0),
          GestureDetector(
            onTap: () => locator<NavigationService>().navigateTo(AccountSetupRoute),
            child: CustomText(
              context: context,
              text: "Complete Account Setup",
              textColor: Colors.blueAccent,
              textAlign: TextAlign.left,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              underline: true,
            ),
          ).showCursorOnHover,
        ],
      ),
    );
  }

  checkAccountVerificationRequirements() {
    CustomAlerts().showLoadingAlert(context, "Checking Account Status...");
    StripePaymentService().checkAccountVerificationStatus(currentUID).then((res) {
      Navigator.of(context).pop();
      List eventuallyDue = res['eventually_due'];
      List pending = res['pending_verification'];
      if (pending.isNotEmpty) {
        CustomAlerts().showInfoAlert(
          context,
          "Account Is Under Review",
          "Verification Can Take Up to 24 Hours. Please Check Again Later",
        );
      } else if (eventuallyDue.length > 1) {
        bool needsToFillForm = false;
        bool photoNeeded = false;
        bool socialSecurityNeeded = false;
        if (eventuallyDue.length > 3) {
          needsToFillForm = true;
        }
        eventuallyDue.forEach((val) {
          if (val.toString().contains("individual.id_number")) {
            socialSecurityNeeded = true;
          }
          if (val.toString().contains("verification.document")) {
            photoNeeded = true;
          }
        });
        if (needsToFillForm == true) {
          URLService().openURL(context, stripeConnectURL);
        } else if (socialSecurityNeeded) {
          CustomAlerts().showActionRequiredDialog(
              context, "Social Security Number Required", "Please Provide A Valid SSN to Continue the Account Verification Process", "Continue", () {
            URLService().openURL(context, stripeConnectURL);
          });
        } else if (photoNeeded) {
          CustomAlerts().showActionRequiredDialog(
              context, "Photo ID Required", "Please Provide A Valid Photo ID to Continue the Account Verification Process", "Continue", () {
            URLService().openURL(context, stripeConnectURL);
          });
        }
      } else {
        StripePaymentService().updateAccountVerificationStatus(currentUID).then((status) {
          print(status);
          if (status == 'verified') {
            CustomAlerts().showSuccessActionAlert(
              context,
              "Your Account Has Been Approved!",
              "Please Provide Your Banking Information to Begin Receiving Payouts",
              () => locator<NavigationService>().navigateTo(WalletPayoutMethodsRoute),
              "Add Banking Info",
            );
          } else {
            CustomAlerts().showInfoAlert(
              context,
              "Account Is Under Review",
              "Verification Can Take Up to 24 Hours. Please Check Again Later",
            );
          }
        });
      }
    });
  }

  void performInstantPayout(double availableBalance) {
    CustomAlerts().showLoadingAlert(context, "Initiating Payout...");
    if (availableBalance == null || availableBalance < 10) {
      Navigator.of(context).pop();
      CustomAlerts().showErrorAlert(context, "Instant Payout Unavailbe", "You Need At Least \$10.00 USD in Your Account to Perform an Instant Payout.");
    } else {
      StripePaymentService().performInstantStripePayout(currentUID, stripeUID).then((res) {
        Navigator.of(context).pop();
        if (res == "passed") {
          CustomAlerts().showSuccessAlert(context, "Payout Success!", "Funds will Be Available on Your Account within 30 minutes to 1 hour");
        } else {
          CustomAlerts().showErrorAlert(context, "Instant Payout Failed", "There was a problem issuing your payout. Please Try Again Later.");
        }
      });
    }
  }

  Widget stripeActionButton(String verificationStatus, double availableBalance) {
    return verificationStatus == "verified"
        ? CustomColorButton(
            onPressed: () => performInstantPayout(availableBalance),
            text: "Instant Payout",
            textColor: Colors.white,
            backgroundColor: CustomColors.darkMountainGreen,
            textSize: 14.0,
            height: 35,
            width: 120,
          ).showCursorOnHover
        : CustomColorButton(
            onPressed: () => checkAccountVerificationRequirements(), //() => validateAndSubmitForm(),
            text: "Check Account Status",
            textColor: Colors.black,
            backgroundColor: Colors.white,
            textSize: 14.0,
            height: 35,
            width: 120,
          ).showCursorOnHover;
  }

  Widget stripeAccountMenu(String verificationStatus, SizingInformation screenSize, double availableBalance) {
    return screenSize.isDesktop
        ? Container(
            child: Row(
              children: [
                stripeActionButton(verificationStatus, availableBalance),
                SizedBox(width: 8.0),
                CustomColorButton(
                  onPressed: () => locator<NavigationService>().navigateTo(WalletPaymentsHistoryRoute),
                  text: "Payment History",
                  textColor: Colors.black,
                  backgroundColor: Colors.white,
                  textSize: 14.0,
                  height: 35,
                  width: 120,
                ).showCursorOnHover,
                SizedBox(width: 8.0),
                CustomColorButton(
                  onPressed: () => locator<NavigationService>().navigateTo(WalletPayoutMethodsRoute), //() => validateAndSubmitForm(),
                  text: "Payout Methods",
                  textColor: Colors.black,
                  backgroundColor: Colors.white,
                  textSize: 14.0,
                  height: 35,
                  width: 120,
                ).showCursorOnHover,
                SizedBox(width: 12.0),
                CustomColorButton(
                  onPressed: () => locator<NavigationService>().navigateTo(WalletEarningsGuideRoute), //() => validateAndSubmitForm(),
                  text: "How Do Earnings Work?",
                  textColor: Colors.black,
                  backgroundColor: Colors.white,
                  textSize: 14.0,
                  height: 35,
                  width: 150,
                ).showCursorOnHover,
              ],
            ),
          )
        : Container(
            child: Column(
              children: [
                Row(
                  children: [
                    stripeActionButton(verificationStatus, availableBalance),
                    SizedBox(width: 8.0),
                    CustomColorButton(
                      onPressed: () => locator<NavigationService>().navigateTo(WalletPaymentsHistoryRoute),
                      text: "Payment History",
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      textSize: 14.0,
                      height: 35,
                      width: 120,
                    ).showCursorOnHover,
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    CustomColorButton(
                      onPressed: () => locator<NavigationService>().navigateTo(WalletPayoutMethodsRoute), //() => validateAndSubmitForm(),
                      text: "Payout Methods",
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      textSize: 14.0,
                      height: 35,
                      width: 120,
                    ).showCursorOnHover,
                    SizedBox(width: 12.0),
                    CustomColorButton(
                      onPressed: () => locator<NavigationService>().navigateTo(WalletEarningsGuideRoute), //() => validateAndSubmitForm(),
                      text: "How Do Earnings Work?",
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      textSize: 35.0,
                      height: 35,
                      width: 150,
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
    FirebaseAuthenticationService().getCurrentUserID().then((res) {
      currentUID = res;
      WebblenUserData().userAccountIsSetup(currentUID).then((accountSetup) {
        if (accountSetup) {
          userAccountSetup = true;
          stripeConnectURL = "https://us-central1-webblen-events.cloudfunctions.net/connectStripeCustomAccount?uid=${currentUID}";
        } else {
          userAccountSetup = false;
        }
        EventDataService().getPurchasedTickets(currentUID).then((res) async {
          await organizeNumOfTicketsByEvent(res);
          if (userAccountSetup) {
            StripePaymentService().getStripeUID(currentUID).then((res) {
              if (res != null) {
                stripeUID = res;
                stripeAccountIsSetup = true;
                StripePaymentService().updateAccountVerificationStatus(currentUID).then((res) {
                  StripePaymentService().getStripeAccountBalance(currentUID, stripeUID).then((res) {
                    isLoading = false;
                    setState(() {});
                  });
                });
              } else {
                isLoading = false;
                setState(() {});
              }
            });
          } else {
            isLoading = false;
            setState(() {});
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            isLoading || user == null || user.isAnonymous
                ? Container()
                : userAccountSetup
                    ? stripeAccountIsSetup
                        ? Container()
                        : createEarningsAccountNotice()
                    : completeAccountSetupNotice(),
            //isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
            isLoading || user == null || user.isAnonymous
                ? Container()
                : Container(
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: 1.0,
                      ),
                      child: CustomText(
                        context: context,
                        text: "Wallet",
                        textColor: Colors.black,
                        textAlign: TextAlign.left,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
            user == null
                ? Container(height: MediaQuery.of(context).size.height)
                : user.isAnonymous
                    ? ZeroStateView(
                        title: "You Are Not Logged In",
                        desc: "Please Login to View Your Wallet",
                        buttonTitle: "Login",
                        buttonAction: () => locator<NavigationService>().navigateTo(AccountLoginRoute),
                      )
                    : userAccountSetup
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 24.0),
                            child: StreamBuilder(
                              stream: WebblenUserData().streamStripeAccount(user.uid),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return Container();
                                var userData = snapshot;
                                double availableBalance = 0.001;
                                double pendingBalance = 0.001;
                                String verificationStatus = "pending";
                                if (userData.data != null) {
                                  availableBalance = userData.data['availableBalance'] * 1.000001;
                                  pendingBalance = userData.data['pendingBalance'] * 1.000001;
                                  verificationStatus = userData.data['verified'];
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: 8.0),
                                    CustomText(
                                      context: context,
                                      text: '\$' + availableBalance.toStringAsFixed(2),
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CustomText(
                                      context: context,
                                      text: 'USD Balance',
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomText(
                                      context: context,
                                      text: "Money you've earned through Webblen via ticketing",
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(height: 12.0),
                                    CustomText(
                                      context: context,
                                      text: '\$' + pendingBalance.toStringAsFixed(2),
                                      textColor: Colors.black38,
                                      textAlign: TextAlign.left,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CustomText(
                                      context: context,
                                      text: 'Pending Balance',
                                      textColor: Colors.black38,
                                      textAlign: TextAlign.left,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(height: 12.0),
                                    stripeAccountMenu(verificationStatus, screenSize, availableBalance),
                                  ],
                                );
                              },
                            ),
                          )
                        : Container(),
            user == null || user.isAnonymous
                ? Container(height: MediaQuery.of(context).size.height)
                : userAccountSetup
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                        child: StreamBuilder<WebblenUser>(
                            stream: WebblenUserData().streamCurrentUser(user.uid),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return Container();
                              WebblenUser currentUser = snapshot.data;
                              return Container(
                                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(height: 32.0),
                                    CustomText(
                                      context: context,
                                      text: '${currentUser.eventPoints.toStringAsFixed(2)}',
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CustomText(
                                      context: context,
                                      text: 'Webblen Balance',
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    CustomText(
                                      context: context,
                                      text:
                                          "Webblen are tokens that can be transferred or traded at anytime.  Webblen can be used to create new events and communities.",
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      context: context,
                                      text: "Earn more Webblen by attending events and posting to communities.",
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(height: 32.0),
                                    CustomText(
                                      context: context,
                                      text: 'My Tickets',
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    isLoading
                                        ? Container(
                                            margin: EdgeInsets.symmetric(horizontal: 16),
                                            child: CustomText(
                                              context: context,
                                              text: "Loading Tickets...",
                                              textColor: Colors.black,
                                              textAlign: TextAlign.left,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : events.isEmpty
                                            ? Container(
                                                child: CustomText(
                                                  context: context,
                                                  text: "You Do Not Have Any Tickets",
                                                  textColor: Colors.black,
                                                  textAlign: TextAlign.left,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : ticketList(),
                                  ],
                                ),
                              );
                            }),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: CustomText(
                              context: context,
                              text: 'My Tickets',
                              textColor: Colors.black,
                              textAlign: TextAlign.left,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 16),
                          events.isEmpty
                              ? loadingTickets
                                  ? Container(
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      child: CustomText(
                                        context: context,
                                        text: "Loading Tickets...",
                                        textColor: Colors.black,
                                        textAlign: TextAlign.left,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : Container(
                                      child: CustomText(
                                        context: context,
                                        text: "You Do Not Have Any Tickets",
                                        textColor: Colors.black,
                                        textAlign: TextAlign.left,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                              : ticketList(),
                        ],
                      ),
            SizedBox(height: 32.0),
            Footer(),
          ],
        ),
      ),
    );
  }
}
