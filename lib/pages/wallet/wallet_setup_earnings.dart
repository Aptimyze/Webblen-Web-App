import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/common/url_service.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_payment.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/state/zero_state_view.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/events/event_block.dart';

class WalletSetupEarningsPage extends StatefulWidget {
  @override
  _WalletSetupEarningsPageState createState() => _WalletSetupEarningsPageState();
}

class _WalletSetupEarningsPageState extends State<WalletSetupEarningsPage> {
  static final firestore = firebase.firestore();
  CollectionReference userRef = firestore.collection("users");
  bool isLoading = true;
  String currentUID;
  bool dismissedNotice = false;
  String stripeConnectURL;
  bool stripeAccountIsSetup = false;
  String stripeUID;
  List<WebblenEvent> events = [];
  List<String> loadedEvents = [];
  Map<String, dynamic> ticsPerEvent = {};

  Widget ticketEventGrid() {
    return ResponsiveGridList(
      scroll: false,
      desiredItemWidth: 260,
      minSpacing: 10,
      children: events
          .map((e) => EventBlock(
                eventImgSize: 260,
                eventDescHeight: 120,
                event: e,
                shareEvent: null,
                numOfTicsForEvent: ticsPerEvent[e.id],
                viewEventDetails: () => e.navigateToEvent(e.id),
                viewEventTickets: () => e.navigateToWalletTickets(e.id),
              ))
          .toList(),
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
          "Verifcation Can Take Up to 24 Hours. Please Check Again Later",
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
              "Verifcation Can Take Up to 24 Hours. Please Check Again Later",
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
      stripeConnectURL = "https://us-central1-webblen-events.cloudfunctions.net/connectStripeCustomAccount?uid=${currentUID}";
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
            isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
            user == null
                ? Container(height: MediaQuery.of(context).size.height)
                : user.isAnonymous
                    ? ZeroStateView(
                        title: "You Are Not Logged In",
                        desc: "Please Login to View Your Wallet",
                        buttonTitle: "Login",
                        buttonAction: () => locator<NavigationService>().navigateTo(AccountLoginRoute),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.90,
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                        child: StreamBuilder(
                          stream: WebblenUserData().streamStripeAccount(user.uid),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    context: context,
                                    text: "You're almost all set!",
                                    textColor: Colors.black,
                                    textAlign: TextAlign.center,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  CustomText(
                                    context: context,
                                    text: "Please Set Up Your Business Account to Begin Earning from Ticket Sales",
                                    textColor: Colors.black,
                                    textAlign: TextAlign.center,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(height: 8.0),
                                  CustomColorButton(
                                    onPressed: () => URLService().openURL(context, stripeConnectURL), //() => validateAndSubmitForm(),
                                    text: "Create Business Account",
                                    textColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    textSize: 18.0,
                                    height: 35,
                                    width: 200,
                                  ).showCursorOnHover,
                                ],
                              );
                            var userData = snapshot;
                            String verificationStatus = userData.data == null ? "unverified" : userData.data['verified'];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 8.0),
                                verificationStatus == "unverified"
                                    ? CustomText(
                                        context: context,
                                        text: "You're almost all set!",
                                        textColor: Colors.black,
                                        textAlign: TextAlign.center,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w700,
                                      )
                                    : verificationStatus == "pending"
                                        ? CustomText(
                                            context: context,
                                            text: "Your Account is Currently Under Review",
                                            textColor: Colors.black,
                                            textAlign: TextAlign.center,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w700,
                                          )
                                        : CustomText(
                                            context: context,
                                            text: "Your Account has Been Verified!",
                                            textColor: Colors.black,
                                            textAlign: TextAlign.center,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                verificationStatus == "unverified"
                                    ? CustomText(
                                        context: context,
                                        text: "Please Set Up Your Business Account to Begin Earning from Ticket Sales",
                                        textColor: Colors.black,
                                        textAlign: TextAlign.center,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                      )
                                    : verificationStatus == "pending"
                                        ? CustomText(
                                            context: context,
                                            text: "Account Review Can Take Up to 24hrs. \n Until Then, You Can Still Get Started and Create an Event!",
                                            textColor: Colors.black,
                                            textAlign: TextAlign.center,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                          )
                                        : CustomText(
                                            context: context,
                                            text: "You Can Now Begin Selling Tickets!",
                                            textColor: Colors.black,
                                            textAlign: TextAlign.center,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                SizedBox(height: 18.0),
                                verificationStatus == "unverified"
                                    ? CustomColorButton(
                                        onPressed: () => URLService().openURL(context, stripeConnectURL), //() => validateAndSubmitForm(),
                                        text: "Create Business Account",
                                        textColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        textSize: 18.0,
                                        height: 35,
                                        width: 200,
                                      ).showCursorOnHover
                                    : verificationStatus == "pending" || verificationStatus == "verified"
                                        ? CustomColorButton(
                                            onPressed: () => locator<NavigationService>().navigateTo(CreateEventRoute), //() => validateAndSubmitForm(),
                                            text: "Create an Event",
                                            textColor: Colors.black,
                                            backgroundColor: Colors.white,
                                            textSize: 18.0,
                                            height: 35,
                                            width: 200,
                                          ).showCursorOnHover
                                        : Container(),
                                SizedBox(height: 16.0),
                                verificationStatus == "pending" || verificationStatus == "unverified"
                                    ? GestureDetector(
                                        onTap: () => URLService().openURL(context, stripeConnectURL),
                                        child: CustomText(
                                          context: context,
                                          text: "Complete Setting Up Business Account",
                                          textColor: Colors.blue,
                                          textAlign: TextAlign.center,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ).showCursorOnHover,
                                      )
                                    : Container(),
                              ],
                            );
                          },
                        ),
                      ),
            SizedBox(height: 32.0),
            Footer(),
          ],
        ),
      ),
    );
  }
}
