import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/constants/time.dart';
import 'package:webblen_web_app/enums/bottom_sheet_type.dart';
import 'package:webblen_web_app/extensions/custom_date_time_extensions.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/common/firestore_storage_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/services/reactive/file_uploader/reactive_file_uploader_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_connect_account_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';
import 'package:webblen_web_app/utils/webblen_image_picker.dart';

class CreateLiveStreamViewModel extends ReactiveViewModel {
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  PlatformDataService? _platformDataService = locator<PlatformDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  LocationService? _locationService = locator<LocationService>();
  FirestoreStorageService? _firestoreStorageService = locator<FirestoreStorageService>();
  LiveStreamDataService _liveStreamDataService = locator<LiveStreamDataService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  TicketDistroDataService? _ticketDistroDataService = locator<TicketDistroDataService>();
  StripeConnectAccountService? _stripeConnectAccountService = locator<StripeConnectAccountService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  ReactiveFileUploaderService _reactiveFileUploaderService = locator<ReactiveFileUploaderService>();

  ///STREAM DETAILS CONTROLLERS
  TextEditingController tagTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController startDateTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();
  TextEditingController instaUsernameTextController = TextEditingController();
  TextEditingController fbUsernameTextController = TextEditingController();
  TextEditingController twitterUsernameTextController = TextEditingController();
  TextEditingController twitchTextController = TextEditingController();
  TextEditingController youtubeTextController = TextEditingController();
  TextEditingController websiteTextController = TextEditingController();
  TextEditingController fbStreamKeyTextController = TextEditingController();
  TextEditingController twitchStreamKeyTextController = TextEditingController();
  TextEditingController youtubeStreamKeyTextController = TextEditingController();
  TextEditingController fbStreamURLTextController = TextEditingController();
  TextEditingController twitchStreamURLTextController = TextEditingController();
  TextEditingController youtubeStreamURLTextController = TextEditingController();

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
  bool? hasEarningsAccount;
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  ///FILE DATA
  bool get uploadingFile => _reactiveFileUploaderService.uploadingFile;
  double get uploadProgress => _reactiveFileUploaderService.uploadProgress;
  File get fileToUpload => _reactiveFileUploaderService.fileToUpload;
  Uint8List get fileToUploadByteMemory => _reactiveFileUploaderService.fileToUploadByteMemory;

  ///STREAM DATA
  String? id;
  bool isEditing = false;
  bool isDuplicate = false;

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
  DateTime? selectedEndDate;

  ///TICKETING
  WebblenTicketDistro? ticketDistro = WebblenTicketDistro(tickets: [], fees: [], discountCodes: []);
  GlobalKey ticketFormKey = GlobalKey<FormState>();
  GlobalKey feeFormKey = GlobalKey<FormState>();
  GlobalKey discountFormKey = GlobalKey<FormState>();

  bool showTicketForm = false;
  bool showFeeForm = false;
  bool showDiscountCodeForm = false;

  String? ticketName;
  String? ticketPrice;
  String? ticketQuantity;
  String? feeName;
  String? feeAmount;
  String? discountCodeName;
  String? discountCodeQuantity;
  String? discountCodePercentage;
  int? ticketToEditIndex;
  int? feeToEditIndex;
  int? discountToEditIndex;

  ///WEBBLEN CURRENCY
  double? newStreamTaxRate;
  double? promo;

  ///REACTIVE SERVICES
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService, _reactiveFileUploaderService];

  ///INITIALIZE
  initialize({String? streamID}) async {
    setBusy(true);

    //generate new stream
    stream = WebblenLiveStream().generateNewWebblenLiveStream(hostID: user.id!, suggestedUIDs: user.followers == null ? [] : user.followers!);

    //check if user has earnings account
    hasEarningsAccount = await _stripeConnectAccountService!.isStripeConnectAccountSetup(user.id);

    //set timezone
    stream.timezone = getCurrentTimezone();
    stream.startTime = timeFormatter.format(DateTime.now().add(Duration(hours: 1)).roundDown(delta: Duration(minutes: 30)));
    stream.endTime = timeFormatter.format(DateTime.now().add(Duration(hours: 2)).roundDown(delta: Duration(minutes: 30)));
    notifyListeners();

    //set previously used social accounts
    setPreviousSocialData();

    id = streamID;

    //check for promos & if editing/duplicating existing stream
    if (streamID!.contains("duplicate_")) {
      String id = streamID.replaceAll("duplicate_", "");
      stream = await _liveStreamDataService.getStreamByID(id);
      if (stream.isValid()) {
        stream.id = getRandomString(32);
        setPreviousStreamData();
        stream.attendees = {};
        stream.savedBy = [];
        isDuplicate = true;
      }
    } else if (id != "new") {
      WebblenLiveStream existingStream = await _liveStreamDataService.getStreamForEditingByID(id);
      if (existingStream.isValid()) {
        stream = existingStream;
        setPreviousStreamData();
        isEditing = true;
      }
    }

    //get webblen rates
    newStreamTaxRate = await _platformDataService!.getNewStreamTaxRate();
    if (newStreamTaxRate == null) {
      newStreamTaxRate = 0.05;
    }

    //complete initialization
    initialized = true;

    notifyListeners();
    setBusy(false);
  }

  ///SHARE PREF
  setPreviousSocialData() async {
    fbUsernameTextController.text = await _userDataService.getCurrentFbUsername(user.id!);
    instaUsernameTextController.text = await _userDataService.getCurrentInstaUsername(user.id!);
    twitterUsernameTextController.text = await _userDataService.getCurrentTwitterUsername(user.id!);
    websiteTextController.text = await _userDataService.getCurrentUserWebsite(user.id!);
    twitchTextController.text = await _userDataService.getCurrentTwitchUsername(user.id!);
    youtubeTextController.text = await _userDataService.getCurrentYoutube(user.id!);
    fbStreamKeyTextController.text = await _userDataService.getCurrentUserFBStreamKey(user.id!);
    twitchStreamKeyTextController.text = await _userDataService.getCurrentUserTwitchStreamKey(user.id!);
    youtubeStreamKeyTextController.text = await _userDataService.getCurrentUserYoutubeStreamKey(user.id!);
    fbStreamURLTextController.text = await _userDataService.getCurrentUserFBStreamURL(user.id!);
    twitchStreamURLTextController.text = await _userDataService.getCurrentUserTwitchStreamURL(user.id!);
    youtubeStreamURLTextController.text = await _userDataService.getCurrentUserYoutubeStreamURL(user.id!);
  }

  setPreviousStreamData() {
    titleTextController.text = stream.title!;
    descTextController.text = stream.description!;
    startDateTextController.text = stream.startDate!;
    endDateTextController.text = stream.endDate!;
    fbUsernameTextController.text = stream.fbUsername == null ? "" : stream.fbUsername!;
    instaUsernameTextController.text = stream.instaUsername == null ? "" : stream.instaUsername!;
    twitterUsernameTextController.text = stream.twitterUsername == null ? "" : stream.twitterUsername!;
    websiteTextController.text = stream.website == null ? "" : stream.website!;
    twitchTextController.text = stream.twitchUsername == null ? "" : stream.twitchUsername!;
    youtubeTextController.text = stream.youtube == null ? "" : stream.youtube!;
    fbStreamKeyTextController.text = stream.fbStreamKey == null ? "" : stream.fbStreamKey!;
    twitchStreamKeyTextController.text = stream.twitchStreamKey == null ? "" : stream.twitchStreamKey!;
    youtubeStreamKeyTextController.text = stream.youtubeStreamKey == null ? "" : stream.youtubeStreamKey!;
    fbStreamURLTextController.text = stream.fbStreamURL == null ? "" : stream.fbStreamURL!;
    twitchStreamURLTextController.text = stream.twitchStreamURL == null ? "" : stream.twitchStreamURL!;
    youtubeStreamURLTextController.text = stream.youtubeStreamURL == null ? "" : stream.youtubeStreamURL!;
    selectedStartDate = dateFormatter.parse(stream.startDate!);
    selectedEndDate = dateFormatter.parse(stream.endDate!);
  }

  ///STREAM IMAGE
  selectImage() async {
    WebblenImagePicker().retrieveImageFromLibrary();
  }

  ///STREAM TAGS
  addTag(String tag) {
    List tags = stream.tags == null ? [] : stream.tags!.toList(growable: true);

    //check if tag already listed
    if (!tags.contains(tag)) {
      //check if tag limit has been reached
      if (tags.length == 3) {
        _customDialogService.showErrorDialog(description: "You can only add up to 3 tags for your stream");
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
    List tags = stream.tags == null ? [] : stream.tags!.toList(growable: true);
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

    if (details.isEmpty) {
      return false;
    }

    //set nearest zipcodes
    stream.nearbyZipcodes = await _locationService!.findNearestZipcodes(details['areaCode']);
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
  selectDate({required bool selectingStartDate}) async {
    //set selectable dates
    Map<String, dynamic> customData = selectingStartDate
        ? {'minSelectedDate': DateTime.now().subtract(Duration(days: 1)), 'selectedDate': selectedStartDate}
        : {'minSelectedDate': selectedStartDate, 'selectedDate': selectedEndDate ?? selectedStartDate};
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
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

  onSelectedTimeFromDropdown({required bool selectedStartTime, required String time}) {
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
  toggleTicketForm({required int? ticketIndex}) {
    if (ticketIndex == null) {
      if (showTicketForm) {
        showTicketForm = false;
      } else {
        showTicketForm = true;
      }
    } else {
      showTicketForm = true;
      Map<String, dynamic> ticket = ticketDistro!.tickets![ticketIndex];
      ticketNameTextController.text = ticket['ticketName'];
      ticketQuantityTextController.text = ticket['ticketQuantity'];
      ticketPriceTextController.text = ticket['ticketPrice'];
      ticketToEditIndex = ticketIndex;
    }
    notifyListeners();
  }

  addTicket() {
    if (ticketNameTextController.text.trim().isEmpty) {
      _customDialogService.showErrorDialog(
        description: 'Please add a name for this ticket',
      );
      return;
    } else if (ticketQuantityTextController.text.trim().isEmpty) {
      _customDialogService.showErrorDialog(
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
      ticketDistro!.tickets![ticketToEditIndex!] = eventTicket;
      ticketToEditIndex = null;
    } else {
      ticketDistro!.tickets!.add(eventTicket);
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
      ticketDistro!.tickets!.removeAt(ticketToEditIndex!);
      ticketToEditIndex = null;
    }
    notifyListeners();
  }

  //fees
  toggleFeeForm({required int? feeIndex}) {
    if (feeIndex == null) {
      if (showFeeForm) {
        showFeeForm = false;
      } else {
        showFeeForm = true;
      }
    } else {
      showFeeForm = true;
      Map<String, dynamic> fee = ticketDistro!.fees![feeIndex];
      feeNameTextController.text = fee['feeName'];
      feePriceTextController.text = fee['feePrice'];
      feeToEditIndex = feeIndex;
    }
    notifyListeners();
  }

  addFee() {
    if (feeNameTextController.text.trim().isEmpty) {
      _customDialogService.showErrorDialog(
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
      ticketDistro!.fees![feeToEditIndex!] = eventFee;
      feeToEditIndex = null;
    } else {
      ticketDistro!.fees!.add(eventFee);
    }
    showFeeForm = false;
    notifyListeners();
  }

  deleteFee() {
    feeNameTextController.clear();
    feePriceTextController.text = "\$0.00";
    showFeeForm = false;
    if (feeToEditIndex != null) {
      ticketDistro!.fees!.removeAt(feeToEditIndex!);
      feeToEditIndex = null;
    }
    notifyListeners();
  }

  //discounts
  toggleDiscountsForm({required int? discountIndex}) {
    if (discountIndex == null) {
      if (showDiscountCodeForm) {
        showDiscountCodeForm = false;
      } else {
        showDiscountCodeForm = true;
      }
    } else {
      showDiscountCodeForm = true;
      Map<String, dynamic> discount = ticketDistro!.discountCodes![discountIndex];
      discountNameTextController.text = discount['discountName'];
      discountLimitTextController.text = discount['discountLimit'];
      discountValueTextController.text = discount['discountValue'];
      discountToEditIndex = discountIndex;
    }
    notifyListeners();
  }

  addDiscount() {
    if (discountNameTextController.text.trim().isEmpty) {
      _customDialogService.showErrorDialog(
        description: 'Please add a code for this discount',
      );
      return;
    } else if (discountLimitTextController.text.trim().isEmpty) {
      _customDialogService.showErrorDialog(
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
      ticketDistro!.discountCodes![discountToEditIndex!] = eventDiscount;
      discountToEditIndex = null;
    } else {
      ticketDistro!.discountCodes!.add(eventDiscount);
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
      ticketDistro!.discountCodes!.removeAt(discountToEditIndex!);
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

  setTwitchUsername(String val) {
    stream.twitchUsername = val.trim();
    notifyListeners();
  }

  setYoutube(String val) {
    stream.youtube = val.trim();
    notifyListeners();
  }

  setWebsite(String val) {
    stream.website = val.trim();
    notifyListeners();
  }

  setYoutubeStreamURL(String val) {
    stream.youtubeStreamURL = val.trim();
    notifyListeners();
  }

  setYoutubeStreamKey(String val) {
    stream.youtubeStreamKey = val.trim();
    notifyListeners();
  }

  setTwitchStreamURL(String val) {
    stream.twitchStreamURL = val.trim();
    notifyListeners();
  }

  setTwitchStreamKey(String val) {
    stream.twitchStreamKey = val.trim();
    notifyListeners();
  }

  setFBStreamURL(String val) {
    stream.fbStreamURL = val.trim();
    notifyListeners();
  }

  setFBStreamKey(String val) {
    stream.fbStreamKey = val.trim();
    notifyListeners();
  }

  ///FORM VALIDATION
  bool tagsAreValid() {
    if (stream.tags == null || stream.tags!.isEmpty) {
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
      String eventStartDateAndTime = stream.startDate! + " " + stream.startTime!;
      stream.startDateTimeInMilliseconds = dateTimeFormatter.parse(eventStartDateAndTime).millisecondsSinceEpoch;
      notifyListeners();
    }
    return isValid;
  }

  bool endDateIsValid() {
    bool isValid = isValidString(stream.endDate);
    if (isValid) {
      String eventEndDateAndTime = stream.endDate! + " " + stream.endTime!;
      stream.endDateTimeInMilliseconds = dateTimeFormatter.parse(eventEndDateAndTime).millisecondsSinceEpoch;
      notifyListeners();
      if (stream.endDateTimeInMilliseconds! < stream.startDateTimeInMilliseconds!) {
        isValid = false;
      }
    }
    return isValid;
  }

  bool fbUsernameIsValid() {
    return isValidUsername(stream.fbUsername!);
  }

  bool instaUsernameIsValid() {
    return isValidUsername(stream.instaUsername!);
  }

  bool twitterUsernameIsValid() {
    return isValidUsername(stream.twitterUsername!);
  }

  bool websiteIsValid() {
    return isValidUrl(stream.website!);
  }

  bool formIsValid() {
    bool isValid = false;
    if (fileToUploadByteMemory.isEmpty && stream.imageURL == null) {
      _customDialogService.showErrorDialog(
        description: 'Your stream must have an image',
      );
    } else if (!tagsAreValid()) {
      _customDialogService.showErrorDialog(
        description: 'Your stream must contain at least 1 tag',
      );
    } else if (!titleIsValid()) {
      _customDialogService.showErrorDialog(
        description: 'The title for your stream cannot be empty',
      );
    } else if (!descIsValid()) {
      _customDialogService.showErrorDialog(
        description: 'The description for your stream cannot be empty',
      );
    } else if (!audienceLocationIsValid()) {
      _customDialogService.showErrorDialog(
        description: 'The target location for your stream cannot be empty',
      );
    } else if (!startDateIsValid()) {
      _customDialogService.showErrorDialog(
        description: 'The start date & time for your stream cannot be empty',
      );
    } else if (!endDateIsValid()) {
      _customDialogService.showErrorDialog(
        description: "End date & time must be set after the start date & time",
      );
    } else if (stream.fbUsername != null && stream.fbUsername!.isNotEmpty && !fbUsernameIsValid()) {
      _customDialogService.showErrorDialog(
        description: "Facebook username must be valid",
      );
    } else if (stream.instaUsername != null && stream.instaUsername!.isNotEmpty && !instaUsernameIsValid()) {
      _customDialogService.showErrorDialog(
        description: "Instagram username must be valid",
      );
    } else if (stream.twitterUsername != null && stream.twitterUsername!.isNotEmpty && !twitterUsernameIsValid()) {
      _customDialogService.showErrorDialog(
        description: "Twitter username must be valid",
      );
    } else if (stream.website != null && stream.website!.isNotEmpty && !websiteIsValid()) {
      _customDialogService.showErrorDialog(
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
    if (fileToUploadByteMemory.isNotEmpty) {
      String imageURL =
          await _firestoreStorageService!.uploadImage(imgFile: fileToUpload, storageBucket: 'images', folderName: 'streams', fileName: stream.id!);
      if (imageURL.isEmpty) {
        _customDialogService.showErrorDialog(
          description: "There was an issue uploading your stream. Please try again.",
        );
        return false;
      }
      stream.imageURL = imageURL;
    }

    //set suggested uids for event
    stream.suggestedUIDs = stream.suggestedUIDs == null ? user.followers : stream.suggestedUIDs;

    //upload stream data
    var uploadResult;
    if (isEditing) {
      uploadResult = await _liveStreamDataService.updateStream(stream: stream);
    } else {
      uploadResult = await _liveStreamDataService.createStream(stream: stream);
    }

    if (uploadResult is String) {
      _customDialogService.showErrorDialog(
        description: 'There was an issue uploading your stream. Please try again.',
      );
      return false;
    }

    //cache username data
    await saveSocialData();

    return success;
  }

  saveSocialData() async {
    if (isValidString(stream.fbUsername)) {
      await _userDataService.updateFbUsername(id: stream.hostID!, val: stream.fbUsername!);
    }
    if (isValidString(stream.instaUsername)) {
      await _userDataService.updateInstaUsername(id: stream.hostID!, val: stream.instaUsername!);
    }
    if (isValidString(stream.twitterUsername)) {
      await _userDataService.updateTwitterUsername(id: stream.hostID!, val: stream.twitterUsername!);
    }
    if (isValidString(stream.twitchUsername)) {
      await _userDataService.updateTwitchUsername(id: stream.hostID!, val: stream.twitchUsername!);
    }
    if (isValidString(stream.youtube)) {
      await _userDataService.updateYoutube(id: stream.hostID!, val: stream.youtube!);
    }
    if (isValidString(stream.youtubeStreamURL)) {
      await _userDataService.updateYoutubeStreamURL(id: stream.hostID!, val: stream.youtubeStreamURL!);
    }
    if (isValidString(stream.youtubeStreamKey)) {
      await _userDataService.updateYoutubeStreamKey(id: stream.hostID!, val: stream.youtubeStreamKey!);
    }
    if (isValidString(stream.twitchStreamURL)) {
      await _userDataService.updateTwitchStreamURL(id: stream.hostID!, val: stream.twitchStreamURL!);
    }
    if (isValidString(stream.twitchStreamKey)) {
      await _userDataService.updateTwitchStreamKey(id: stream.hostID!, val: stream.twitchStreamKey!);
    }
    if (isValidString(stream.fbStreamURL)) {
      await _userDataService.updateFBStreamURL(id: stream.hostID!, val: stream.fbStreamURL!);
    }
    if (isValidString(stream.fbStreamKey)) {
      await _userDataService.updateFBStreamKey(id: stream.hostID!, val: stream.fbStreamKey!);
    }
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

  showNewContentConfirmationBottomSheet({BuildContext? context}) async {
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
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
      barrierDismissible: true,
      title: "Schedule Stream?",
      description: stream.privacy == "Public" ? "Schedule this stream for everyone to see" : "Your stream ready to be scheduled and shared",
      mainButtonTitle: "Schedule Stream",
      secondaryButtonTitle: "Cancel",
      customData: {'fee': newStreamTaxRate, 'promo': promo},
      variant: BottomSheetType.newContentConfirmation,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;

      //disable text fields while fetching image
      textFieldEnabled = false;
      notifyListeners();

      //get image from camera or gallery
      if (res == "insufficient funds") {
        _customDialogService.showErrorDialog(
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
      _userDataService.depositWebblen(uid: user.id, amount: promo!);
    }
    _userDataService.withdrawWebblen(uid: user.id, amount: newStreamTaxRate!);

    //display success
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
        variant: BottomSheetType.addContentSuccessful,
        takesInput: false,
        customData: stream,
        barrierDismissible: false,
        title: isEditing ? "Your Stream has been Updated" : "Your Stream has been Scheduled! 🎉");

    if (sheetResponse == null || sheetResponse.responseData == "done") {
      _reactiveFileUploaderService.clearUploaderData();
      _navigationService!.pushNamedAndRemoveUntil(Routes.WebblenBaseViewRoute);
    }
  }

  ///NAVIGATION
  navigateBack() async {
    _customDialogService.showCancelContentDialog(isEditing: isEditing, contentType: "Stream");
  }

  navigateBackToWalletPage() async {
    bool navigateToWallet = await _customDialogService.showNavigateToEarningsAccountDialog(isEditing: isEditing, contentType: "Stream");
    if (navigateToWallet) {
      webblenBaseViewModel.navigateToHomeWithIndex(2);
    }
  }
}
