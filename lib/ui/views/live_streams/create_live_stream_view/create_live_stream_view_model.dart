import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/constants/time.dart';
import 'package:webblen_web_app/enums/bottom_sheet_type.dart';
import 'package:webblen_web_app/extensions/custom_date_time_extensions.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_ticket_distro.dart';
import 'package:webblen_web_app/services/firestore/common/firestore_storage_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_connect_account_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';
import 'package:webblen_web_app/utils/webblen_image_picker.dart';

class CreateLiveStreamViewModel extends BaseViewModel {
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  LocationService _locationService = locator<LocationService>();
  FirestoreStorageService _firestoreStorageService = locator<FirestoreStorageService>();
  LiveStreamDataService _liveStreamDataService = locator<LiveStreamDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  TicketDistroDataService _ticketDistroDataService = locator<TicketDistroDataService>();
  StripeConnectAccountService _stripeConnectAccountService = locator<StripeConnectAccountService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  SharedPreferences _sharedPreferences;

  ///STREAM DETAILS CONTROLLERS
  TextEditingController tagTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController startDateTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();
  TextEditingController instaUsernameTextController = TextEditingController();
  TextEditingController fbUsernameTextController = TextEditingController();
  TextEditingController twitterUsernameTextController = TextEditingController();
  TextEditingController websiteTextController = TextEditingController();

  ///TICKET DETAILS CONTROLLERS
  TextEditingController ticketNameTextController = TextEditingController();
  TextEditingController ticketQuantityTextController = TextEditingController();
  MoneyMaskedTextController ticketPriceTextController = MoneyMaskedTextController(
    leftSymbol: "\$",
    precision: 2,
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

  ///FEE DETAILS CONTROLLERS
  TextEditingController feeNameTextController = TextEditingController();
  MoneyMaskedTextController feePriceTextController = MoneyMaskedTextController(
    leftSymbol: "\$",
    precision: 2,
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

  ///DISCOUNT DETAILS CONTROLLERS
  TextEditingController discountNameTextController = TextEditingController();
  TextEditingController discountLimitTextController = TextEditingController();
  MoneyMaskedTextController discountValueTextController = MoneyMaskedTextController(
    leftSymbol: "\$",
    precision: 2,
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

  ///HELPERS
  bool initialized = false;
  bool textFieldEnabled = true;

  ///USER DATA
  bool hasEarningsAccount;

  ///STREAM DATA
  String id;
  bool isEditing = false;
  double uploadProgress;
  File imgToUpload;
  Uint8List imgToUploadByteMemory;
  int ticketToEditIndex;
  int feeToEditIndex;
  int discountToEditIndex;

  WebblenLiveStream stream = WebblenLiveStream();

  ///FORMATTERS
  //Date & Time Details
  DateTime selectedDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
  );

  DateFormat dateFormatter = DateFormat('MMM dd, yyyy');
  DateFormat timeFormatter = DateFormat('h:mm a');
  DateFormat dateTimeFormatter = DateFormat('MMM dd, yyyy h:mm a');
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate;

  ///TICKETING
  WebblenTicketDistro ticketDistro = WebblenTicketDistro(tickets: [], fees: [], discountCodes: []);
  GlobalKey ticketFormKey = GlobalKey<FormState>();
  GlobalKey feeFormKey = GlobalKey<FormState>();
  GlobalKey discountFormKey = GlobalKey<FormState>();

  bool showTicketForm = false;
  bool showFeeForm = false;
  bool showDiscountCodeForm = false;

  String ticketName;
  String ticketPrice;
  String ticketQuantity;
  String feeName;
  String feeAmount;
  String discountCodeName;
  String discountCodeQuantity;
  String discountCodePercentage;

  ///WEBBLEN CURRENCY
  double newStreamTaxRate;
  double promo;

  ///INITIALIZE
  initialize({String streamID}) async {
    setBusy(true);

    _sharedPreferences = await SharedPreferences.getInstance();

    //generate new event
    stream = WebblenLiveStream().generateNewWebblenLiveStream(hostID: webblenBaseViewModel.user.id);

    //check if user has earnings account
    hasEarningsAccount = await _stripeConnectAccountService.isStripeConnectAccountSetup(webblenBaseViewModel.user.id);

    //set timezone
    stream.timezone = getCurrentTimezone();
    stream.startTime = timeFormatter.format(DateTime.now().add(Duration(hours: 1)).roundDown(delta: Duration(minutes: 30)));
    stream.endTime = timeFormatter.format(DateTime.now().add(Duration(hours: 2)).roundDown(delta: Duration(minutes: 30)));
    notifyListeners();

    //set previously used social accounts
    fbUsernameTextController.text = _sharedPreferences.getString('fbUsername');
    instaUsernameTextController.text = _sharedPreferences.getString('instaUsername');
    twitterUsernameTextController.text = _sharedPreferences.getString('twitterUsername');
    websiteTextController.text = _sharedPreferences.getString('website');

    id = streamID;

    //check if editing existing post
    if (id != null) {
      WebblenLiveStream existingStream = await _liveStreamDataService.getStreamForEditingByID(id);
      if (existingStream != null) {
        stream = existingStream;
        titleTextController.text = stream.title;
        descTextController.text = stream.description;
        startDateTextController.text = stream.startDate;
        endDateTextController.text = stream.endDate;
        fbUsernameTextController.text = stream.fbUsername;
        instaUsernameTextController.text = stream.instaUsername;
        twitterUsernameTextController.text = stream.twitterUsername;
        websiteTextController.text = stream.website;
        selectedStartDate = dateFormatter.parse(stream.startDate);
        selectedEndDate = dateFormatter.parse(stream.endDate);
        isEditing = true;
        //check if editing with ticket distro
        if (stream.hasTickets) {
          ticketDistro = await _ticketDistroDataService.getTicketDistroByID(stream.id);
        }
      }
    }

    // listener for uploader
    webblenBaseViewModel.addListener(() {
      bool uploadStatusChanged = false;
      if (uploadProgress != webblenBaseViewModel.uploadProgress) {
        uploadStatusChanged = true;
        uploadProgress = webblenBaseViewModel.uploadProgress;
      }
      if (imgToUpload != webblenBaseViewModel.imgToUpload) {
        uploadStatusChanged = true;
        imgToUpload = webblenBaseViewModel.imgToUpload;
      }
      if (imgToUploadByteMemory != webblenBaseViewModel.imgToUploadByteMemory) {
        uploadStatusChanged = true;
        imgToUploadByteMemory = webblenBaseViewModel.imgToUploadByteMemory;
      }
      if (uploadStatusChanged) {
        notifyListeners();
      }
    });

    //get webblen rates
    newStreamTaxRate = await _platformDataService.getNewStreamTaxRate();
    if (newStreamTaxRate == null) {
      newStreamTaxRate = 0.05;
    }

    //complete initialization
    initialized = true;

    notifyListeners();
    setBusy(false);
  }

  ///STREAM IMAGE
  selectImage() async {
    WebblenImagePicker().retrieveImageFromLibrary();
  }

  ///STREAM TAGS
  addTag(String tag) {
    List tags = stream.tags == null ? [] : stream.tags.toList(growable: true);

    //check if tag already listed
    if (!tags.contains(tag)) {
      //check if tag limit has been reached
      if (tags.length == 3) {
        _dialogService.showDialog(
          title: "Tag Limit Reached",
          description: "You can only add up to 3 tags for your stream",
        );
      } else {
        //add tag
        tags.add(tag);
        stream.tags = tags;
        notifyListeners();
      }
    }
    tagTextController.clear();
  }

  removeTagAtIndex(int index) {
    List tags = stream.tags == null ? [] : stream.tags.toList(growable: true);
    tags.removeAt(index);
    stream.tags = tags;
    notifyListeners();
  }

  ///STREAM INFO
  setStreamTitle(String val) {
    stream.title = val;
    notifyListeners();
  }

  setStreamDescription(String val) {
    stream.description = val;
    notifyListeners();
  }

  onSelectedPrivacyFromDropdown(String val) {
    stream.privacy = val;
    notifyListeners();
  }

  ///STREAM LOCATION
  Future<bool> setStreamAudienceLocation(Map<String, dynamic> details) async {
    bool success = true;

    if (details == null || details.isEmpty) {
      return false;
    }

    //set nearest zipcodes
    stream.nearbyZipcodes = await _locationService.findNearestZipcodes(details['areaCode']);
    if (stream.nearbyZipcodes == null) {
      return false;
    }

    //set lat
    stream.lat = details['lat'];

    //set lon
    stream.lon = details['lon'];

    //set address
    stream.audienceLocation = details['streetAddress'];

    //set city
    stream.city = details['cityName'];

    //get province
    stream.province = details['province'];

    print(stream.toMap());
    notifyListeners();

    return success;
  }

  ///EVENT DATA & TIME
  selectDate({@required bool selectingStartDate}) async {
    //set selectable dates
    Map<String, dynamic> customData = selectingStartDate
        ? {'minSelectedDate': DateTime.now().subtract(Duration(days: 1)), 'selectedDate': selectedStartDate}
        : {'minSelectedDate': selectedStartDate, 'selectedDate': selectedEndDate ?? selectedStartDate};
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      title: selectingStartDate ? "Start Date" : "End Date",
      customData: customData,
      barrierDismissible: true,
      variant: BottomSheetType.calendar,
    );
    if (sheetResponse != null) {
      //format selected date
      DateTime selectedDate = sheetResponse.responseData;
      String formattedDate = dateFormatter.format(selectedDate);

      //set start date
      if (selectingStartDate) {
        selectedStartDate = selectedDate;
        stream.startDate = formattedDate;
        startDateTextController.text = formattedDate;
      }
      //set end date
      if (!selectingStartDate || selectedEndDate == null) {
        selectedEndDate = selectedDate;
        stream.endDate = formattedDate;
        endDateTextController.text = formattedDate;
      }
      notifyListeners();
    }
  }

  onSelectedTimeFromDropdown({@required bool selectedStartTime, @required String time}) {
    if (selectedStartTime) {
      stream.startTime = time;
    } else {
      stream.endTime = time;
    }
    notifyListeners();
  }

  onSelectedTimezoneFromDropdown(String val) {
    stream.timezone = val;
    notifyListeners();
  }

  ///STREAM TICKETING, FEES, AND DISCOUNTS
  //tickets
  toggleTicketForm({@required int ticketIndex}) {
    if (ticketIndex == null) {
      if (showTicketForm) {
        showTicketForm = false;
      } else {
        showTicketForm = true;
      }
    } else {
      showTicketForm = true;
      Map<String, dynamic> ticket = ticketDistro.tickets[ticketIndex];
      ticketNameTextController.text = ticket['ticketName'];
      ticketQuantityTextController.text = ticket['ticketQuantity'];
      ticketPriceTextController.text = ticket['ticketPrice'];
      ticketToEditIndex = ticketIndex;
    }
    notifyListeners();
  }

  addTicket() {
    if (ticketNameTextController.text.trim().isEmpty) {
      _dialogService.showDialog(
        title: 'Ticket Name Required',
        description: 'Please add a name for this ticket',
      );
      return;
    } else if (ticketQuantityTextController.text.trim().isEmpty) {
      _dialogService.showDialog(
        title: 'Ticket Quantity Required',
        description: 'Please set a quantity for this ticket',
      );
      return;
    }

    Map<String, dynamic> eventTicket = {
      "ticketName": ticketNameTextController.text.trim(),
      "ticketQuantity": ticketQuantityTextController.text.trim(),
      "ticketPrice": ticketPriceTextController.text.trim(),
    };

    ticketNameTextController.clear();
    ticketQuantityTextController.clear();
    ticketPriceTextController.text = "\$0.00";

    if (ticketToEditIndex != null) {
      ticketDistro.tickets[ticketToEditIndex] = eventTicket;
      ticketToEditIndex = null;
    } else {
      ticketDistro.tickets.add(eventTicket);
    }
    showTicketForm = false;
    notifyListeners();
  }

  deleteTicket() {
    ticketNameTextController.clear();
    ticketQuantityTextController.clear();
    ticketPriceTextController.text = "\$0.00";
    showTicketForm = false;
    if (ticketToEditIndex != null) {
      ticketDistro.tickets.removeAt(ticketToEditIndex);
      ticketToEditIndex = null;
    }
    notifyListeners();
  }

  //fees
  toggleFeeForm({@required int feeIndex}) {
    if (feeIndex == null) {
      if (showFeeForm) {
        showFeeForm = false;
      } else {
        showFeeForm = true;
      }
    } else {
      showFeeForm = true;
      Map<String, dynamic> fee = ticketDistro.fees[feeIndex];
      feeNameTextController.text = fee['feeName'];
      feePriceTextController.text = fee['feePrice'];
      feeToEditIndex = feeIndex;
    }
    notifyListeners();
  }

  addFee() {
    if (feeNameTextController.text.trim().isEmpty) {
      _dialogService.showDialog(
        title: 'Fee Name Required',
        description: 'Please add a name for this fee',
      );
      return;
    }

    Map<String, dynamic> eventFee = {
      "feeName": feeNameTextController.text.trim(),
      "feePrice": feePriceTextController.text.trim(),
    };

    feeNameTextController.clear();
    feePriceTextController.text = "\$0.00";

    if (feeToEditIndex != null) {
      ticketDistro.fees[feeToEditIndex] = eventFee;
      feeToEditIndex = null;
    } else {
      ticketDistro.fees.add(eventFee);
    }
    showFeeForm = false;
    notifyListeners();
  }

  deleteFee() {
    feeNameTextController.clear();
    feePriceTextController.text = "\$0.00";
    showFeeForm = false;
    if (feeToEditIndex != null) {
      ticketDistro.fees.removeAt(feeToEditIndex);
      feeToEditIndex = null;
    }
    notifyListeners();
  }

  //discounts
  toggleDiscountsForm({@required int discountIndex}) {
    if (discountIndex == null) {
      if (showDiscountCodeForm) {
        showDiscountCodeForm = false;
      } else {
        showDiscountCodeForm = true;
      }
    } else {
      showDiscountCodeForm = true;
      Map<String, dynamic> discount = ticketDistro.discountCodes[discountIndex];
      discountNameTextController.text = discount['discountName'];
      discountLimitTextController.text = discount['discountLimit'];
      discountValueTextController.text = discount['discountValue'];
      discountToEditIndex = discountIndex;
    }
    notifyListeners();
  }

  addDiscount() {
    if (discountNameTextController.text.trim().isEmpty) {
      _dialogService.showDialog(
        title: 'Discount Code Required',
        description: 'Please add a code for this discount',
      );
      return;
    } else if (discountLimitTextController.text.trim().isEmpty) {
      _dialogService.showDialog(
        title: 'Discount Limit Required',
        description: 'Please set a limit for the number of times this discount can be used',
      );
      return;
    }

    Map<String, dynamic> eventDiscount = {
      "discountName": discountNameTextController.text.trim(),
      "discountLimit": discountLimitTextController.text.trim(),
      "discountValue": discountValueTextController.text.trim(),
    };

    discountNameTextController.clear();
    discountLimitTextController.clear();
    discountValueTextController.text = "\$0.00";

    if (discountToEditIndex != null) {
      ticketDistro.discountCodes[discountToEditIndex] = eventDiscount;
      discountToEditIndex = null;
    } else {
      ticketDistro.discountCodes.add(eventDiscount);
    }
    showDiscountCodeForm = false;
    notifyListeners();
  }

  deleteDiscount() {
    discountNameTextController.clear();
    discountLimitTextController.clear();
    discountValueTextController.text = "\$0.00";
    showDiscountCodeForm = false;
    if (discountToEditIndex != null) {
      ticketDistro.discountCodes.removeAt(discountToEditIndex);
      discountToEditIndex = null;
    }
    notifyListeners();
  }

  ///ADDITIONAL STREAM INFO
  setSponsorshipStatus(bool val) {
    stream.openToSponsors = val;
    notifyListeners();
  }

  setFBUsername(String val) {
    stream.fbUsername = val.trim();
    notifyListeners();
  }

  setInstaUsername(String val) {
    stream.instaUsername = val.trim();
    notifyListeners();
  }

  setTwitterUsername(String val) {
    stream.twitterUsername = val.trim();
    notifyListeners();
  }

  setWebsite(String val) {
    stream.website = val.trim();
    notifyListeners();
  }

  ///FORM VALIDATION
  bool tagsAreValid() {
    if (stream.tags == null || stream.tags.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool titleIsValid() {
    return isValidString(stream.title);
  }

  bool descIsValid() {
    return isValidString(stream.description);
  }

  bool audienceLocationIsValid() {
    return isValidString(stream.audienceLocation);
  }

  bool startDateIsValid() {
    bool isValid = isValidString(stream.startDate);
    if (isValid) {
      String eventStartDateAndTime = stream.startDate + " " + stream.startTime;
      stream.startDateTimeInMilliseconds = dateTimeFormatter.parse(eventStartDateAndTime).millisecondsSinceEpoch;
      notifyListeners();
    }
    return isValid;
  }

  bool endDateIsValid() {
    bool isValid = isValidString(stream.endDate);
    if (isValid) {
      String eventEndDateAndTime = stream.endDate + " " + stream.endTime;
      stream.endDateTimeInMilliseconds = dateTimeFormatter.parse(eventEndDateAndTime).millisecondsSinceEpoch;
      notifyListeners();
      if (stream.endDateTimeInMilliseconds < stream.startDateTimeInMilliseconds) {
        isValid = false;
      }
    }
    return isValid;
  }

  bool fbUsernameIsValid() {
    return isValidUsername(stream.fbUsername);
  }

  bool instaUsernameIsValid() {
    return isValidUsername(stream.instaUsername);
  }

  bool twitterUsernameIsValid() {
    return isValidUsername(stream.twitterUsername);
  }

  bool websiteIsValid() {
    return isValidUrl(stream.website);
  }

  bool formIsValid() {
    bool isValid = false;
    if (imgToUpload == null && stream.imageURL == null) {
      _dialogService.showDialog(
        title: 'Stream Image Error',
        description: 'Your stream must have an image',
      );
    } else if (!tagsAreValid()) {
      _dialogService.showDialog(
        title: 'Tag Error',
        description: 'Your stream must contain at least 1 tag',
      );
    } else if (!titleIsValid()) {
      _dialogService.showDialog(
        title: 'Stream Title Required',
        description: 'The title for your stream cannot be empty',
      );
    } else if (!descIsValid()) {
      _dialogService.showDialog(
        title: 'Stream Description Required',
        description: 'The description for your stream cannot be empty',
      );
    } else if (!audienceLocationIsValid()) {
      _dialogService.showDialog(
        title: 'Stream Audiences Location Required',
        description: 'The target location for your stream cannot be empty',
      );
    } else if (!startDateIsValid()) {
      _dialogService.showDialog(
        title: 'Stream Start Date Required',
        description: 'The start date & time for your stream cannot be empty',
      );
    } else if (!endDateIsValid()) {
      _dialogService.showDialog(
        title: 'Stream End Date Error',
        description: "End date & time must be set after the start date & time",
      );
    } else if (stream.fbUsername != null && stream.fbUsername.isNotEmpty && !fbUsernameIsValid()) {
      _dialogService.showDialog(
        title: 'Facebook Username Error',
        description: "Facebook username must be valid",
      );
    } else if (stream.instaUsername != null && stream.instaUsername.isNotEmpty && !instaUsernameIsValid()) {
      _dialogService.showDialog(
        title: 'Instagram Username Error',
        description: "Instagram username must be valid",
      );
    } else if (stream.twitterUsername != null && stream.twitterUsername.isNotEmpty && !twitterUsernameIsValid()) {
      _dialogService.showDialog(
        title: 'Twitter Username Error',
        description: "Twitter username must be valid",
      );
    } else if (stream.website != null && stream.website.isNotEmpty && !websiteIsValid()) {
      _dialogService.showDialog(
        title: "Website URL Error",
        description: "Website URL must be valid",
      );
    } else {
      isValid = true;
    }
    return isValid;
  }

  Future<bool> submitStream() async {
    bool success = true;

    //upload img if exists
    if (imgToUpload != null) {
      String imageURL = await _firestoreStorageService.uploadImage(imgFile: imgToUpload, storageBucket: 'images', folderName: 'streams', fileName: stream.id);
      if (imageURL == null) {
        _dialogService.showDialog(
          title: "Website URL Error",
          description: "Website URL must be valid",
        );
        return false;
      }
      stream.imageURL = imageURL;
    }

    //set suggested uids for event
    stream.suggestedUIDs = stream.suggestedUIDs == null ? webblenBaseViewModel.user.followers : stream.suggestedUIDs;

    //upload stream data
    var uploadResult;
    if (isEditing) {
      uploadResult = await _liveStreamDataService.updateStream(stream: stream);
    } else {
      uploadResult = await _liveStreamDataService.createStream(stream: stream);
    }

    if (uploadResult is String) {
      _dialogService.showDialog(
        title: 'Stream Upload Error',
        description: 'There was an issue uploading your stream. Please try again.',
      );
      return false;
    }

    //cache username data
    await _sharedPreferences.setString('fbUsername', stream.fbUsername);
    await _sharedPreferences.setString('instaUsername', stream.instaUsername);
    await _sharedPreferences.setString('twitterUsername', stream.twitterUsername);
    await _sharedPreferences.setString('website', stream.website);

    return success;
  }

  submitForm() async {
    setBusy(true);
    //submit new stream
    bool submitted = await submitStream();
    if (submitted) {
      //show bottom sheet
      displayUploadSuccessBottomSheet();
    }
    setBusy(false);
  }

  showNewContentConfirmationBottomSheet({BuildContext context}) async {
    //FocusScope.of(context).unfocus();

    //exit function if form is invalid
    if (!formIsValid()) {
      setBusy(false);
      return;
    }

    //check if editing post
    if (isEditing) {
      submitForm();
      return;
    }

    //display event confirmation
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      title: "Schedule Stream?",
      description: stream.privacy == "Public" ? "Schedule this stream for everyone to see" : "Your stream ready to be scheduled and shared",
      mainButtonTitle: "Schedule Stream",
      secondaryButtonTitle: "Cancel",
      customData: {'fee': newStreamTaxRate, 'promo': promo},
      variant: BottomSheetType.newContentConfirmation,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;

      //disable text fields while fetching image
      textFieldEnabled = false;
      notifyListeners();

      //get image from camera or gallery
      if (res == "insufficient funds") {
        _dialogService.showDialog(
          title: 'Insufficient Funds',
          description: 'You do no have enough WBLN to schedule this stream',
        );
      } else if (res == "confirmed") {
        submitForm();
      }

      //wait a bit to re-enable text fields
      await Future.delayed(Duration(milliseconds: 500));
      textFieldEnabled = true;
      notifyListeners();
    }
  }

  displayUploadSuccessBottomSheet() async {
    //deposit and/or withdraw webblen & promo
    if (promo != null) {
      _userDataService.depositWebblen(uid: webblenBaseViewModel.uid, amount: promo);
    }
    _userDataService.withdrawWebblen(uid: webblenBaseViewModel.uid, amount: newStreamTaxRate);

    //display success
    var sheetResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.addContentSuccessful,
        takesInput: false,
        customData: stream,
        barrierDismissible: false,
        title: isEditing ? "Your Stream has been Updated" : "Your Stream has been Scheduled! 🎉");

    if (sheetResponse == null || sheetResponse.responseData == "done") {
      _navigationService.pushNamedAndRemoveUntil(Routes.WebblenBaseViewRoute);
    }
  }

  ///NAVIGATION
  navigateBack() async {
    DialogResponse response = await _dialogService.showDialog(
      title: isEditing ? "Cancel Editing Stream?" : "Cancel Creating Stream?",
      description: isEditing ? "Changes to this stream will not be saved" : "The details for this stream will not be saved",
      cancelTitle: "Cancel",
      cancelTitleColor: appDestructiveColor(),
      buttonTitle: isEditing ? "Discard Changes" : "Discard Stream",
      buttonTitleColor: appTextButtonColor(),
      barrierDismissible: true,
    );
    if (response != null && !response.confirmed) {
      _navigationService.back();
    }
  }

  navigateBackToWalletPage() async {
    DialogResponse response = await _dialogService.showDialog(
      title: "Create an Earnings Account?",
      description: isEditing ? "Changes to this stream will not be saved" : "The details for this stream will not be saved",
      cancelTitle: "Continue Editing",
      cancelTitleColor: appTextButtonColor(),
      buttonTitle: "Create Earnings Account",
      buttonTitleColor: appTextButtonColor(),
      barrierDismissible: true,
    );
    if (response != null && response.confirmed) {
      webblenBaseViewModel.navigateToHomeWithIndex(2);
    }
  }
}
