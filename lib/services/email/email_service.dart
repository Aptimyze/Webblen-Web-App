import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';

class EmailService {
  CollectionReference stripeRef = FirebaseFirestore.instance.collection("stripe");
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  // CollectionReference stripeActivityRef = FirebaseFirestore.instance.collection("stripe_connect_activity");
  // CollectionReference ticketDistroRef = FirebaseFirestore.instance.collection("ticket_distros");
  // CollectionReference purchasedTicketsRef = FirebaseFirestore.instance.collection("purchased_tickets");

  Future<void> sendTicketPurchaseConfirmationEmail({
    required String emailAddress,
    required String eventTitle,
    required List purchasedTickets,
    required String additionalTaxesAndFees,
    required String discountCodeDescription,
    required String discountValue,
    required String totalCharge,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'sendTicketPurchaseConfirmationEmail',
    );

    callable.call(
      <String, dynamic>{
        'emailAddress': emailAddress,
        'eventTitle': eventTitle,
        'purchasedTickets': purchasedTickets,
        'additionalTaxesAndFees': additionalTaxesAndFees,
        'discountCodeDescription': discountCodeDescription,
        'discountValue': discountValue,
        'totalCharge': totalCharge,
      },
    );
  }
}
