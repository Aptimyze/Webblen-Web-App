import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/services/time/time_service.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class WalletPaymentHistoryPage extends StatefulWidget {
  @override
  _WalletPaymentHistoryPageState createState() => _WalletPaymentHistoryPageState();
}

class _WalletPaymentHistoryPageState extends State<WalletPaymentHistoryPage> {
  static final firestore = fb.firestore();
  CollectionReference stripeRef = firestore.collection("stripe");
  CollectionReference stripeActivityRef = firestore.collection("stripe_connect_activity");

  String currentUID;
  List<DocumentSnapshot> paymentHistoryResults = [];
  DocumentSnapshot lastDocumentSnapshot;
  int resultsPerPage = 10;
  bool isLoading = true;
  bool loadingAdditionalData = false;
  bool moreDataAvailable = true;

  ScrollController scrollController = ScrollController();

  getPaymentHistory() async {
    Query paymentsHistoryQuery = stripeActivityRef.where("uid", "==", "Dya8eg1EToYMBTiCyAgFekN5J232").orderBy("timePosted", "desc").limit(resultsPerPage);
    QuerySnapshot querySnapshot = await paymentsHistoryQuery.get();
    lastDocumentSnapshot = querySnapshot.docs[querySnapshot.docs.length - 1];
    paymentHistoryResults = querySnapshot.docs;
    isLoading = false;
    setState(() {});
  }

  getAdditionalPaymentHistory() async {
    if (isLoading || !moreDataAvailable || loadingAdditionalData) {
      return;
    }
    loadingAdditionalData = true;
    setState(() {});
    Query paymentsHistoryQuery = stripeActivityRef
        .where("uid", "==", "Dya8eg1EToYMBTiCyAgFekN5J232")
        .orderBy("timePosted", "desc")
        .startAfter(snapshot: lastDocumentSnapshot)
        .limit(resultsPerPage);

    QuerySnapshot querySnapshot = await paymentsHistoryQuery.get();
    lastDocumentSnapshot = querySnapshot.docs[querySnapshot.docs.length - 1];
    paymentHistoryResults.addAll(querySnapshot.docs);
    if (querySnapshot.docs.length == 0) {
      moreDataAvailable = false;
    }
    loadingAdditionalData = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuthenticationService().getCurrentUserID().then((res) {
      currentUID = res;
      setState(() {});
      getPaymentHistory();
    });
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll < delta) {
        getAdditionalPaymentHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            isLoading ? CustomLinearProgress(progressBarColor: CustomColors.webblenRed) : Container(),
            SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                    context: context,
                    text: "Payments History",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1.5,
                          blurRadius: 1.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    child: Container(
                      color: Colors.white,
                      child: isLoading
                          ? Container()
                          : ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: paymentHistoryResults.length,
                              itemBuilder: (_, int index) {
                                final Map<String, dynamic> docData = paymentHistoryResults[index].data();
                                final dynamic message = docData['description'];
                                final dynamic timePosted = docData['timePosted'];
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    title: CustomText(
                                      context: context,
                                      text: message,
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    subtitle: CustomText(
                                      context: context,
                                      text: TimeService().getPastTimeFromMilliseconds(timePosted),
                                      textColor: Colors.black,
                                      textAlign: TextAlign.left,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
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
