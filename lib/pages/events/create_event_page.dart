import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';
import 'package:webblen_web_app/constants/strings.dart';
import 'package:webblen_web_app/constants/timezones.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/event.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/text_field_container.dart';
import 'package:webblen_web_app/widgets/common/navigation/footer.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  String currentUID;
  bool isLoading = true;
  TextEditingController controller = TextEditingController();
  GlobalKey formKey = GlobalKey<FormState>();
  //Event Details
  String eventTitle;
  String eventDesc;
  //Location Details
  bool isDigitalEvent = false;
  String venueName;
  double lat;
  double lon;
  String eventAddress;
  String address1;
  String address2;
  String city;
  String province = "AL";
  String zipPostalCode;
  String digitalEventLink;
  //Date & Time Details
  DateTime selectedDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
  );

  DateFormat dateFormatter = DateFormat('MMM dd, yyyy');
  DateFormat timeFormatter = DateFormat('h:mm a');
  int startDateTimeInMilliseconds;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String timezone = "CDT";
  // Event Image
  File eventImgFile;
  Uint8List eventImgByteMemory;

  //Ticketing
  TicketDistro ticketDistro = TicketDistro(tickets: [], fees: [], discountCodes: [], usedTicketIDs: [], validTicketIDs: []);
  GlobalKey ticketFormKey = GlobalKey<FormState>();
  GlobalKey feeFormKey = GlobalKey<FormState>();
  GlobalKey discountFormKey = GlobalKey<FormState>();
  MoneyMaskedTextController moneyMaskedTextController = MoneyMaskedTextController(
    leftSymbol: "\$",
    precision: 2,
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
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

  //Additional Info & Social Links
  String privacy = 'public';
  List<String> privacyOptions = ['public', 'private'];
  String eventType = 'Select Event Type';
  String eventCategory = 'Select Event Category';
  String fbUsername;
  String twitterUsername;
  String instaUsername;
  String websiteURL;

  //Other
  GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: Strings.googleAPIKEY,
    baseUrl: Strings.proxyMapsURL,
  );

  openGoogleAutoComplete() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Strings.googleAPIKEY,
      onError: (res) {
        print(res.errorMessage);
      },
      proxyBaseUrl: Strings.proxyMapsURL,
      mode: Mode.overlay,
      language: "en",
      components: [
        Component(
          Component.country,
          "us",
        ),
      ],
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    eventAddress = detail.result.formattedAddress;
    zipPostalCode = detail.result.addressComponents[7].longName;
    city = detail.result.addressComponents[3].longName;
    print(city);
    province = detail.result.addressComponents[5].shortName;
    print(province);
    lat = detail.result.geometry.location.lat;
    lon = detail.result.geometry.location.lng;
    setState(() {});
  }

  Widget sectionHeader(String sectionNumber, String header) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black26,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [CustomColors.webblenRed, CustomColors.webblenPink],
              ),
            ),
            child: Center(
              child: CustomText(
                context: context,
                text: sectionNumber,
                textColor: Colors.white,
                textAlign: TextAlign.left,
                fontSize: 24.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 8.0),
          CustomText(
            context: context,
            text: header,
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
          ),
        ],
      ),
    );
  }

  Widget fieldHeader(String header, bool isRequired) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: <Widget>[
          CustomText(
            context: context,
            text: header,
            textColor: Colors.black,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          isRequired
              ? CustomText(
                  context: context,
                  text: " *",
                  textColor: Colors.red,
                  textAlign: TextAlign.left,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                )
              : Container(),
        ],
      ),
    );
  }

  Widget eventTitleField() {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: eventTitle,
        cursorColor: Colors.black,
        validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
        onChanged: (value) {
          setState(() {
            eventTitle = value.trim();
          });
        },
        onSaved: (value) => eventTitle = value.trim(),
        inputFormatters: [
          LengthLimitingTextInputFormatter(75),
        ],
        decoration: InputDecoration(
          hintText: "Name of the Event",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget isDigitalEventCheckBox() {
    return Row(
      children: <Widget>[
        CustomText(
          context: context,
          text: "This is a Digital/Online Event",
          textColor: Colors.black,
          textAlign: TextAlign.left,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        Checkbox(
          activeColor: CustomColors.webblenRed,
          value: isDigitalEvent,
          onChanged: (val) {
            isDigitalEvent = val;
            setState(() {});
          },
        ).showCursorOnHover,
      ],
    );
  }

  Widget eventVenueNameField() {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: venueName,
        cursorColor: Colors.black,
        onChanged: (value) {
          setState(() {
            venueName = value.trim();
          });
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(75),
        ],
        decoration: InputDecoration(
          hintText: "Venue Name",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget eventLocationField(SizingInformation screenzSize) {
    return GestureDetector(
      onTap: () => openGoogleAutoComplete(),
      child: TextFieldContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 10.0),
              child: CustomText(
                context: context,
                text: eventAddress == null || eventAddress.isEmpty ? "Search for Address" : eventAddress,
                textColor: eventAddress == null || eventAddress.isEmpty ? Colors.black54 : Colors.black,
                textAlign: TextAlign.left,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ).showCursorOnHover;
  }

  Widget eventDigitalLinkField() {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: digitalEventLink,
        cursorColor: Colors.black,
        onChanged: (value) {
          setState(() {
            digitalEventLink = value.trim();
          });
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(75),
        ],
        decoration: InputDecoration(
          hintText: "Event Link",
          border: InputBorder.none,
        ),
      ),
    );
  }

  openCalendar(bool isStartDate) {
    Alert(
      context: context,
      title: isStartDate ? "Start Date" : "End Date",
      content: Container(
        child: CalendarCarousel(
          isScrollable: false,
          width: 300,
          height: 320,
          headerTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          iconColor: Colors.black,
          weekdayTextStyle: TextStyle(color: Colors.black),
          weekendTextStyle: TextStyle(color: CustomColors.webblenRed),
          minSelectedDate: isStartDate ? DateTime.now() : selectedStartDate,
          onDayPressed: (DateTime date, List<Event> events) {
            if (isStartDate) {
              selectedStartDate = date;
              startDate = dateFormatter.format(date);
              if (selectedStartDate.isAfter(selectedEndDate)) {
                selectedEndDate = date;
                endDate = dateFormatter.format(date);
              }
            } else {
              selectedEndDate = date;
              endDate = dateFormatter.format(date);
            }
            setState(() {});
            Navigator.of(context).pop();
          },
        ),
      ),
      buttons: [
        DialogButton(
          color: CustomColors.textFieldGray,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () => Navigator.pop(context),
          width: 150,
        ),
      ],
    ).show();
  }

  Widget eventTimeFields(SizingInformation screenSize) {
    return screenSize.isDesktop
        ? Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  fieldHeader("Starts", true),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => openCalendar(true),
                        child: TextFieldContainer(
                          width: 200,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16.0, right: 8.0, bottom: 16.0),
                            child: CustomText(
                              context: context,
                              text: startDate,
                              textColor: Colors.black,
                              textAlign: TextAlign.left,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ).showCursorOnHover,
                      SizedBox(width: 16.0),
                      TextFieldContainer(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          child: DropdownButton(
                              isDense: true,
                              underline: Container(),
                              value: startTime,
                              items: Strings.timeList.map((String val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  startTime = val;
                                });
                              }).showCursorOnHover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 65.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  fieldHeader("Ends", true),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => openCalendar(false),
                        child: TextFieldContainer(
                          width: 200,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16.0, right: 8.0, bottom: 16.0),
                            child: CustomText(
                              context: context,
                              text: endDate,
                              textColor: Colors.black,
                              textAlign: TextAlign.left,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ).showCursorOnHover,
                      SizedBox(width: 16.0),
                      TextFieldContainer(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          child: DropdownButton(
                              isDense: true,
                              underline: Container(),
                              value: endTime,
                              items: startDate == endDate
                                  ? Strings().timeListFromSelectedTime(startTime).map((String val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    }).toList()
                                  : Strings.timeList.map((String val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  endTime = val;
                                });
                              }).showCursorOnHover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              fieldHeader("Starts", true),
              Row(
                mainAxisAlignment: screenSize.isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => openCalendar(true),
                    child: TextFieldContainer(
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0, right: 8.0, bottom: 16.0),
                        child: CustomText(
                          context: context,
                          text: startDate,
                          textColor: Colors.black,
                          textAlign: TextAlign.left,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ).showCursorOnHover,
                  SizedBox(width: 16.0),
                  TextFieldContainer(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: DropdownButton(
                          isDense: true,
                          underline: Container(),
                          value: startTime,
                          items: Strings.timeList.map((String val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              startTime = val;
                            });
                          }).showCursorOnHover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              fieldHeader("Ends", true),
              Row(
                mainAxisAlignment: screenSize.isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => openCalendar(false),
                    child: TextFieldContainer(
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0, right: 8.0, bottom: 16.0),
                        child: CustomText(
                          context: context,
                          text: endDate,
                          textColor: Colors.black,
                          textAlign: TextAlign.left,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ).showCursorOnHover,
                  SizedBox(width: 16.0),
                  TextFieldContainer(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: DropdownButton(
                            isDense: true,
                            underline: Container(),
                            value: endTime,
                            items: startDate == endDate
                                ? Strings().timeListFromSelectedTime(startTime).map((String val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val),
                                    );
                                  }).toList()
                                : Strings.timeList.map((String val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val),
                                    );
                                  }).toList(),
                            onChanged: (val) {
                              setState(() {
                                endTime = val;
                              });
                            }).showCursorOnHover),
                  ),
                ],
              ),
            ],
          );
  }

  Widget eventTimezoneField() {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            fieldHeader("Timezone", true),
            Row(
              children: <Widget>[
                TextFieldContainer(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: DropdownButton(
                        underline: Container(),
                        value: timezone,
                        items: Timezones.timezones.map((Map<String, dynamic> timezone) {
                          return DropdownMenuItem<String>(
                            value: timezone['abbr'],
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(
                                    context: context,
                                    text: "${timezone['value']}: ${timezone['abbr']}",
                                    textColor: Colors.black,
                                    textAlign: TextAlign.left,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  CustomText(
                                    context: context,
                                    text: timezone['text'],
                                    textColor: Colors.black,
                                    textAlign: TextAlign.left,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          print(val);
                          setState(() {
                            timezone = val;
                          });
                        }).showCursorOnHover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget eventImgButton() {
    return eventImgByteMemory == null
        ? Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => uploadImage(),
                child: Container(
                  height: 250,
                  width: 250,
                  color: CustomColors.textFieldGray,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        size: 40.0,
                        color: Colors.black26,
                      ),
                      CustomText(
                        context: context,
                        text: "1:1",
                        textColor: Colors.black26,
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ).showCursorOnHover,
            ],
          )
        : Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => uploadImage(),
                child: Container(
                  height: 250,
                  width: 250,
                  child: Image.memory(eventImgByteMemory),
                ),
              ).showCursorOnHover
            ],
          );
  }

  uploadImage() async {
    File file;
    FileReader fileReader = FileReader();
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      file = uploadInput.files.first;
      fileReader.readAsDataUrl(file);
      fileReader.onLoadEnd.listen((event) {
        //print(file.size);
        if (file.size > 5000000) {
          CustomAlerts().showErrorAlert(context, "File Size Error", "File Size Cannot Exceed 5MB");
        } else if (file.type == "image/jpg" || file.type == "image/jpeg" || file.type == "image/png") {
          String base64FileString = fileReader.result.toString().split(',')[1];
          //COMPRESS FILE HERE
          setState(() {
            eventImgFile = file;
            eventImgByteMemory = base64Decode(base64FileString);
          });
        } else {
          CustomAlerts().showErrorAlert(context, "Image Upload Error", "Please Upload a Valid Image");
        }
      });
    });
  }

  Widget eventDescriptionField() {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: eventDesc,
        cursorColor: Colors.black,
        validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
        maxLines: null,
        onChanged: (value) {
          setState(() {
            eventDesc = value.trim();
          });
        },
        decoration: InputDecoration(
          hintText: "Be sure to include important information and details to make it easier for people to find this event",
          border: InputBorder.none,
        ),
      ),
    );
  }

  //EVENT TICKETING
  Widget ticketingFormHeader(String formType, SizingInformation screenSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: CustomColors.textFieldGray,
        border: Border.all(
          width: 1.0,
          color: Colors.black26,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: screenSize.isMobile ? 150 : screenSize.isTablet ? 200 : 300,
            child: CustomText(
              context: context,
              text: formType == "ticket" ? "Ticket Name" : formType == "fee" ? "Fee Name" : "Discount Code Name",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: screenSize.isDesktop ? 16.0 : 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          formType == "ticket" || formType == "discountCode"
              ? Container(
                  width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                  child: CustomText(
                    context: context,
                    text: formType == "ticket" ? "Qty Available" : "Limit",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Container(
                  width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                  child: CustomText(
                    context: context,
                    text: "Amount",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          formType == "ticket" || formType == "discountCode"
              ? Container(
                  width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                  child: CustomText(
                    context: context,
                    text: formType == "ticket" ? "Price" : "Percent Off",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: formType == "ticket" ? screenSize.isDesktop ? 16.0 : 12.0 : screenSize.isDesktop ? 14.0 : 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Container(width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100),
          Container(
            width: screenSize.isDesktop ? 70 : 40,
          ),
        ],
      ),
    );
  }

  Widget ticketListBuilder(SizingInformation screenSize) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ticketDistro.tickets.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: screenSize.isMobile ? 150 : screenSize.isTablet ? 200 : 300,
                    child: CustomText(
                      context: context,
                      text: ticketDistro.tickets[index]["ticketName"],
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                    child: CustomText(
                      context: context,
                      text: ticketDistro.tickets[index]["ticketQuantity"],
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                    child: CustomText(
                      context: context,
                      text: ticketDistro.tickets[index]["ticketPrice"],
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  showTicketForm
                      ? Container(width: screenSize.isMobile ? 40 : screenSize.isTablet ? 60 : 70)
                      : Container(
                          width: screenSize.isDesktop ? 70 : 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => editAction('ticket', index),
                                child: Icon(FontAwesomeIcons.edit, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                              ).showCursorOnHover,
                              GestureDetector(
                                onTap: () => deleteAction('ticket', index),
                                child: Icon(FontAwesomeIcons.trash, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                              ).showCursorOnHover,
                            ],
                          ),
                        ),
                ],
              ),
            );
          }),
    );
  }

  Widget feeListBuilder(SizingInformation screenSize) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ticketDistro.fees.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: screenSize.isMobile ? 150 : screenSize.isTablet ? 200 : 300,
                    child: CustomText(
                      context: context,
                      text: ticketDistro.fees[index]["feeName"],
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                    child: CustomText(
                      context: context,
                      text: ticketDistro.fees[index]["feeAmount"],
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                  ),
                  showTicketForm
                      ? Container(width: screenSize.isDesktop ? 70 : 40)
                      : Container(
                          width: screenSize.isDesktop ? 70 : 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => editAction('fee', index),
                                child: Icon(FontAwesomeIcons.edit, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                              ).showCursorOnHover,
                              GestureDetector(
                                onTap: () => deleteAction('fee', index),
                                child: Icon(FontAwesomeIcons.trash, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                              ).showCursorOnHover,
                            ],
                          ),
                        ),
                ],
              ),
            );
          }),
    );
  }

  Widget discountListBuilder(SizingInformation screenSize) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ticketDistro.discountCodes.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: screenSize.isMobile ? 150 : screenSize.isTablet ? 200 : 300,
                    child: CustomText(
                      context: context,
                      text: ticketDistro.discountCodes[index]["discountCodeName"],
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                    child: CustomText(
                      context: context,
                      text: ticketDistro.discountCodes[index]["discountCodeQuantity"],
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
                    child: CustomText(
                      context: context,
                      text: ticketDistro.discountCodes[index]["discountCodePercentage"],
                      textColor: Colors.black,
                      textAlign: TextAlign.left,
                      fontSize: screenSize.isDesktop ? 16.0 : 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  showTicketForm
                      ? Container(width: screenSize.isMobile ? 40 : screenSize.isTablet ? 60 : 70)
                      : Container(
                          width: screenSize.isDesktop ? 70 : 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => editAction('discountCode', index),
                                child: Icon(FontAwesomeIcons.edit, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                              ).showCursorOnHover,
                              GestureDetector(
                                onTap: () => deleteAction('discountCode', index),
                                child: Icon(FontAwesomeIcons.trash, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                              ).showCursorOnHover,
                            ],
                          ),
                        ),
                ],
              ),
            );
          }),
    );
  }

  Widget ticketForm(SizingInformation screenSize) {
    return Form(
      key: ticketFormKey,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFieldContainer(
              width: screenSize.isMobile ? 150 : screenSize.isTablet ? 200 : 300,
              child: TextFormField(
                initialValue: ticketName,
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => ticketName = value.trim(),
                decoration: InputDecoration(
                  hintText: "General Admission, VIP, etc.",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
              width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
              child: TextFormField(
                initialValue: ticketQuantity,
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => ticketQuantity = value.trim(),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "100",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
              width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
              child: TextFormField(
                controller: moneyMaskedTextController,
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => ticketPrice = value.trim(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              width: screenSize.isDesktop ? 70 : 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => validateTicketForm(),
                    child: Icon(FontAwesomeIcons.plus, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                  ).showCursorOnHover,
                  GestureDetector(
                    onTap: () => changeFormStatus("ticketForm"),
                    child: Icon(FontAwesomeIcons.trash, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                  ).showCursorOnHover,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget feeForm(SizingInformation screenSize) {
    return Form(
      key: feeFormKey,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFieldContainer(
              width: screenSize.isMobile ? 150 : screenSize.isTablet ? 200 : 300,
              child: TextFormField(
                initialValue: feeName,
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => feeName = value.trim(),
                decoration: InputDecoration(
                  hintText: "Venue Fee",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
              width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
              child: TextFormField(
                controller: moneyMaskedTextController,
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => feeAmount = value.trim(),
                decoration: InputDecoration(
                  hintText: "\$9.99",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100),
            Container(
              width: screenSize.isDesktop ? 70 : 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => validateFeeForm(),
                    child: Icon(FontAwesomeIcons.plus, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                  ).showCursorOnHover,
                  GestureDetector(
                    onTap: () => changeFormStatus("feeForm"),
                    child: Icon(FontAwesomeIcons.trash, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                  ).showCursorOnHover,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget discountCodeForm(SizingInformation screenSize) {
    return Form(
      key: discountFormKey,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFieldContainer(
              width: screenSize.isMobile ? 150 : screenSize.isTablet ? 200 : 300,
              child: TextFormField(
                initialValue: discountCodeName,
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => discountCodeName = value.trim(),
                decoration: InputDecoration(
                  hintText: "Discount Code",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
              width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
              child: TextFormField(
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => discountCodeQuantity = value.trim(),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "100",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
              width: screenSize.isMobile ? 60 : screenSize.isTablet ? 75 : 100,
              child: TextFormField(
                initialValue: discountCodePercentage,
                cursorColor: Colors.black,
                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                onSaved: (value) => discountCodePercentage = value.trim(),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "100",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              width: screenSize.isDesktop ? 70 : 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => validateDiscountCodeForm(),
                    child: Icon(FontAwesomeIcons.plus, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                  ).showCursorOnHover,
                  GestureDetector(
                    onTap: () => changeFormStatus("discountCodeForm"),
                    child: Icon(FontAwesomeIcons.trash, size: screenSize.isDesktop ? 18.0 : 14.0, color: Colors.black),
                  ).showCursorOnHover,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  editAction(String object, int objectIndex) {
    if (object == "ticket") {
      ticketName = ticketDistro.tickets[objectIndex]['ticketName'];
      ticketQuantity = ticketDistro.tickets[objectIndex]['ticketQuantity'];
      ticketPrice = ticketDistro.tickets[objectIndex]['ticketPrice'];
      ticketDistro.discountCodes.removeAt(objectIndex);
      changeFormStatus("ticketForm");
    } else if (object == "fee") {
      feeName = ticketDistro.fees[objectIndex]['feeName'];
      feeAmount = ticketDistro.fees[objectIndex]['feeAmount'];
      ticketDistro.fees.removeAt(objectIndex);
      changeFormStatus("feeForm");
    } else {
      discountCodeName = ticketDistro.discountCodes[objectIndex]['discountCodeName'];
      discountCodeQuantity = ticketDistro.discountCodes[objectIndex]['discountCodeQuantity'];
      discountCodePercentage = ticketDistro.discountCodes[objectIndex]['discountCodePercentage'];
      ticketDistro.discountCodes.removeAt(objectIndex);
      changeFormStatus("discountCodeForm");
    }
  }

  deleteAction(String object, int objectIndex) {
    if (object == "ticket") {
      ticketDistro.tickets.removeAt(objectIndex);
    } else if (object == "fee") {
      ticketDistro.fees.removeAt(objectIndex);
    } else {
      ticketDistro.discountCodes.removeAt(objectIndex);
    }
    setState(() {});
  }

  Widget ticketActions(SizingInformation screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Row(
        mainAxisAlignment: screenSize.isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: <Widget>[
          CustomColorIconButton(
            iconData: FontAwesomeIcons.plusCircle,
            iconSize: screenSize.isDesktop ? 16.0 : 12.0,
            text: "Add Ticket",
            textColor: Colors.black,
            textSize: screenSize.isDesktop ? 16.0 : 14.0,
            backgroundColor: Colors.white,
            height: 35.0,
            width: screenSize.isDesktop ? 200 : 140,
            onPressed: () => changeFormStatus("ticketForm"),
          ).showCursorOnHover,
          SizedBox(width: 8.0),
          ticketDistro.tickets.length > 0
              ? CustomColorIconButton(
                  iconData: FontAwesomeIcons.dollarSign,
                  iconSize: screenSize.isDesktop ? 16.0 : 12.0,
                  text: "Add Fee",
                  textColor: Colors.black,
                  textSize: screenSize.isDesktop ? 16.0 : 14.0,
                  backgroundColor: Colors.white,
                  height: 35.0,
                  width: screenSize.isDesktop ? 200 : 140,
                  onPressed: () => changeFormStatus("feeForm"),
                ).showCursorOnHover
              : Container(),
          SizedBox(width: 8.0),
          ticketDistro.tickets.length > 0
              ? CustomColorIconButton(
                  iconData: FontAwesomeIcons.percent,
                  iconSize: screenSize.isDesktop ? 16.0 : 12.0,
                  text: "Add Discount Code",
                  textColor: Colors.black,
                  textSize: screenSize.isDesktop ? 16.0 : screenSize.isTablet ? 12.0 : 10.0,
                  backgroundColor: Colors.white,
                  height: 35.0,
                  width: screenSize.isDesktop ? 200 : 140,
                  onPressed: () => changeFormStatus("discountCodeForm"),
                ).showCursorOnHover
              : Container(),
        ],
      ),
    );
  }

  changeFormStatus(String form) {
    if (form == "ticketForm") {
      if (showTicketForm) {
        showTicketForm = false;
      } else {
        showTicketForm = true;
      }
    } else if (form == "feeForm") {
      if (showFeeForm) {
        showFeeForm = false;
      } else {
        showFeeForm = true;
      }
    } else {
      if (showDiscountCodeForm) {
        showDiscountCodeForm = false;
      } else {
        showDiscountCodeForm = true;
      }
    }
    setState(() {});
  }

  void validateTicketForm() {
    FormState ticketFormState = ticketFormKey.currentState;
    bool formIsValid = ticketFormState.validate();
    if (formIsValid) {
      ticketFormState.save();
      Map<String, dynamic> eventTicket = {
        "ticketName": ticketName,
        "ticketPrice": ticketPrice,
        "ticketQuantity": ticketQuantity,
      };
      ticketDistro.tickets.add(eventTicket);
      ticketName = null;
      ticketPrice = null;
      ticketQuantity = null;
      changeFormStatus("ticketForm");
      setState(() {});
    }
  }

  void validateFeeForm() {
    FormState feeFormState = feeFormKey.currentState;
    bool formIsValid = feeFormState.validate();
    if (formIsValid) {
      feeFormState.save();
      Map<String, dynamic> eventFee = {
        "feeName": feeName,
        "feeAmount": feeAmount,
      };
      ticketDistro.fees.add(eventFee);
      feeName = null;
      feeAmount = null;
      changeFormStatus("feeForm");
      setState(() {});
    }
  }

  void validateDiscountCodeForm() {
    FormState feeFormState = discountFormKey.currentState;
    bool formIsValid = feeFormState.validate();
    if (formIsValid) {
      feeFormState.save();
      Map<String, dynamic> discountCode = {
        "discountCodeName": discountCodeName,
        "discountCodeQuantity": discountCodeQuantity,
        "discountCodePercentage": discountCodePercentage,
      };
      ticketDistro.discountCodes.add(discountCode);
      discountCodeName = null;
      discountCodeQuantity = null;
      discountCodePercentage = null;
      changeFormStatus("discountCodeForm");
      setState(() {});
    }
  }

  //ADDITIONAL INFO & SOCIAL LINKS
  Widget eventPrivacyDropdown(SizingInformation screenSize) {
    return Row(
      children: <Widget>[
        TextFieldContainer(
          height: 45,
          width: 300,
          child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: DropdownButton(
                  isExpanded: true,
                  underline: Container(),
                  value: privacy,
                  items: privacyOptions.map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      privacy = val;
                    });
                  }).showCursorOnHover),
        ),
      ],
    );
  }

  Widget eventCategoryDropDown(SizingInformation screenSize) {
    return Row(
      children: <Widget>[
        TextFieldContainer(
          height: 45,
          width: 300,
          child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: DropdownButton(
                  isExpanded: true,
                  underline: Container(),
                  value: eventCategory,
                  items: Strings.eventCategories.map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      eventCategory = val;
                    });
                  }).showCursorOnHover),
        ),
      ],
    );
  }

  Widget eventTypeDropDown(SizingInformation screenSize) {
    return Row(
      children: <Widget>[
        TextFieldContainer(
          height: 45,
          width: 300,
          child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: DropdownButton(
                  isExpanded: true,
                  underline: Container(),
                  value: eventType,
                  items: Strings.eventTypes.map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      eventType = val;
                    });
                  }).showCursorOnHover),
        ),
      ],
    );
  }

  Widget fbSocialHeader() {
    return Row(
      children: <Widget>[
        Icon(FontAwesomeIcons.facebook, size: 16.0, color: Colors.black),
        SizedBox(width: 4.0),
        CustomText(
          context: context,
          text: "facebook.com/",
          textColor: Colors.black,
          textAlign: TextAlign.left,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget fbUsernameField() {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: fbUsername,
        cursorColor: Colors.black,
        onSaved: (value) {
          setState(() {
            fbUsername = value.trim();
          });
        },
        decoration: InputDecoration(
          hintText: "FB Profile/Page Username",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget instaSocialHeader() {
    return Row(
      children: <Widget>[
        Icon(FontAwesomeIcons.instagram, size: 16.0, color: Colors.black),
        SizedBox(width: 4.0),
        CustomText(
          context: context,
          text: "instagram.com/",
          textColor: Colors.black,
          textAlign: TextAlign.left,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget instaUsernameField() {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: instaUsername,
        cursorColor: Colors.black,
        onSaved: (value) {
          setState(() {
            instaUsername = value.trim();
          });
        },
        decoration: InputDecoration(
          hintText: "Insta Username",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget twitterSocialHeader() {
    return Row(
      children: <Widget>[
        Icon(FontAwesomeIcons.twitter, size: 16.0, color: Colors.black),
        SizedBox(width: 4.0),
        CustomText(
          context: context,
          text: "twitter.com/",
          textColor: Colors.black,
          textAlign: TextAlign.left,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget twitterUsernameField() {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: twitterUsername,
        cursorColor: Colors.black,
        onSaved: (value) {
          setState(() {
            twitterUsername = value.trim();
          });
        },
        decoration: InputDecoration(
          hintText: "Twitter Username",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget websiteHeader() {
    return Row(
      children: <Widget>[
        Icon(FontAwesomeIcons.link, size: 16.0, color: Colors.black),
        SizedBox(width: 4.0),
        CustomText(
          context: context,
          text: "Website URL",
          textColor: Colors.black,
          textAlign: TextAlign.left,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget websiteField() {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: websiteURL,
        cursorColor: Colors.black,
        onSaved: (value) {
          setState(() {
            websiteURL = value.trim();
          });
        },
        decoration: InputDecoration(
          hintText: "Website URL",
          border: InputBorder.none,
        ),
      ),
    );
  }

  //CREATE EVENT
//  bool setEventAddress() {
//    bool addressIsValid = true;
//    if (enterAddressManually) {
//      if (address1 == null ||
//          address1.isEmpty ||
//          city == null ||
//          city.isEmpty ||
//          state == null ||
//          state.isEmpty ||
//          zipPostalCode == null ||
//          zipPostalCode.isEmpty) {
//        addressIsValid = false;
//      } else {
//        eventAddress = address2 == null || address2.isEmpty ? "$address1, $city, $state $zipPostalCode" : "$address1 $address2 , $city, $state $zipPostalCode";
//        print(eventAddress);
//      }
//    } else {
//      addressIsValid = false;
//      print('CORS ERROR');
//    }
//    return addressIsValid;
//  }

  createEvent() async {
    DateTime startDateTime = DateTime(
      selectedStartDate.year,
      selectedStartDate.day,
      timeFormatter.parse(startTime).hour,
      timeFormatter.parse(startTime).minute,
    );
    WebblenEvent newEvent = WebblenEvent(
      id: "",
      authorID: currentUID,
      chatID: null,
      hasTickets: ticketDistro.tickets.isNotEmpty ? true : false,
      flashEvent: false,
      title: eventTitle,
      desc: eventDesc,
      imageURL: null,
      isDigitalEvent: isDigitalEvent,
      digitalEventLink: digitalEventLink,
      venueName: venueName,
      streetAddress: eventAddress,
      city: city,
      province: province,
      nearbyZipcodes: [],
      lat: lat,
      lon: lon,
      sharedComs: [],
      tags: [],
      type: eventType,
      category: eventCategory,
      clicks: 0,
      website: websiteURL,
      fbUsername: fbUsername,
      twitterUsername: twitterUsername,
      instaUsername: instaUsername,
      checkInRadius: 25,
      estimatedTurnout: 0,
      actualTurnout: 0,
      attendees: [],
      eventPayout: 0.0001,
      recurrence: 'none',
      startDateTimeInMilliseconds: startDateTime.millisecondsSinceEpoch,
      startDate: startDate,
      startTime: startTime,
      endDate: endDate,
      endTime: endTime,
      timezone: timezone,
      privacy: privacy,
      reported: false,
    );
    EventDataService().uploadEvent(newEvent, zipPostalCode, eventImgFile, ticketDistro).then((error) {
      if (error == null) {
        newEvent.navigateToEvent(newEvent.id);
      } else {
        print(error);
      }
    });
    //print(newEvent);
  }

  submitEvent() {
    FormState formState = formKey.currentState;
    formState.save();
    //bool addressIsValid = setEventAddress();
    if (eventTitle == null || eventTitle.isEmpty) {
      CustomAlerts().showErrorAlert(context, "Event Title Missing", "Please Give this Event a Title");
    } else if (!isDigitalEvent && (eventAddress == null || eventAddress.isEmpty)) {
      CustomAlerts().showErrorAlert(context, "Event Address Error", "Please Set the Location of this Event");
    } else if (isDigitalEvent && (digitalEventLink == null || digitalEventLink.isEmpty)) {
      CustomAlerts().showErrorAlert(context, "Event URL Link Error", "Please Provide the Link to this Event");
    } else if (eventImgByteMemory == null) {
      CustomAlerts().showErrorAlert(context, "Event Image Missing", "Please Set the Image for this Event");
    } else if (eventDesc == null || eventDesc.isEmpty) {
      CustomAlerts().showErrorAlert(context, "Event Description Missing", "Please Set the Description for this Event");
    } else if (eventCategory == 'Select Event Category') {
      CustomAlerts().showErrorAlert(context, "Event Category Missing", "Please Set the Category for this Event");
    } else if (eventType == "Select Event Type") {
      CustomAlerts().showErrorAlert(context, "Event Type Missing", "Please Select What Type of Event This Is.");
    } else {
      createEvent();
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuthenticationService().getCurrentUserID().then((res) {
      if (res != null) {
        currentUID = res;
      }
      startDate = dateFormatter.format(selectedDateTime);
      endDate = dateFormatter.format(selectedDateTime);
      startTime = timeFormatter.format(selectedDateTime.add(Duration(hours: 1)));
      endTime = selectedDateTime.hour == 23
          ? "11:30 PM"
          : timeFormatter.format(selectedDateTime.add(Duration(
              hours:
                  selectedDateTime.hour <= 19 ? 4 : selectedDateTime.hour == 20 ? 3 : selectedDateTime.hour == 21 ? 2 : selectedDateTime.hour == 22 ? 1 : 0)));
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (buildContext, screenSize) => Container(
        child: Container(
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                isLoading
                    ? Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                        ),
                        child: Column(
                          children: <Widget>[
                            CustomLinearProgress(progressBarColor: CustomColors.webblenRed),
                          ],
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: screenSize.isDesktop ? 100 : screenSize.isTablet ? 50.0 : 24.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomText(
                                  context: context,
                                  text: eventTitle == null || eventTitle.isEmpty ? "New Event" : eventTitle,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.left,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w700,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                                  child: CustomColorButton(
                                    text: "Create Event",
                                    textColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    height: 35.0,
                                    width: 150,
                                    onPressed: () => submitEvent(),
                                  ).showCursorOnHover,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            sectionHeader("1", "Event Details"),
                            //EVENT TITLE
                            fieldHeader("Event Title", true),
                            eventTitleField(),
                            SizedBox(height: 32.0),
                            //EVENT LOCATION
                            isDigitalEvent ? fieldHeader("Event URL Link", true) : fieldHeader("Location", true),
                            isDigitalEvent ? eventDigitalLinkField() : eventLocationField(screenSize),
                            isDigitalEvent ? Container() : SizedBox(height: 16.0),
                            isDigitalEvent ? Container() : fieldHeader("Venue Name/Details (Optional)", false),
                            isDigitalEvent ? Container() : eventVenueNameField(),
                            isDigitalEventCheckBox(),
                            SizedBox(height: 32.0),
                            //EVENT DATE & TIME
                            eventTimeFields(screenSize),
                            SizedBox(height: 16.0),
                            eventTimezoneField(),
                            SizedBox(height: 32.0),
                            //EVENT IMAGE
                            fieldHeader("Event Image", true),
                            SizedBox(height: 8.0),
                            eventImgButton(),
                            SizedBox(height: 8.0),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 300,
                                  child: CustomText(
                                    context: context,
                                    text: "We recommend using at least a 1080x1080px (1:1 ratio) image that's no larger than 5MB.",
                                    textColor: Colors.black,
                                    textAlign: TextAlign.left,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 32.0),
                            //EVENT DESCRIPTION
                            fieldHeader("Event Description", true),
                            eventDescriptionField(),
                            SizedBox(height: 32.0),
                            sectionHeader("2", "Ticketing"),
                            SizedBox(height: 16.0),
                            //Tickets
                            showTicketForm || ticketDistro.tickets.length > 0 ? fieldHeader("Tickets", false) : Container(),
                            showTicketForm || ticketDistro.tickets.length > 0 ? ticketingFormHeader("ticket", screenSize) : Container(),
                            ticketDistro.tickets.length > 0 ? ticketListBuilder(screenSize) : Container(),
                            showTicketForm ? ticketForm(screenSize) : Container(),
                            //Fees
                            showFeeForm || ticketDistro.fees.length > 0 ? fieldHeader("Fees", false) : Container(),
                            showFeeForm || ticketDistro.fees.length > 0 ? ticketingFormHeader("fee", screenSize) : Container(),
                            ticketDistro.fees.length > 0 ? feeListBuilder(screenSize) : Container(),
                            showFeeForm ? feeForm(screenSize) : Container(),
                            //Discount Codes
                            showDiscountCodeForm || ticketDistro.discountCodes.length > 0 ? fieldHeader("Discount Codes", false) : Container(),
                            showDiscountCodeForm || ticketDistro.discountCodes.length > 0 ? ticketingFormHeader("discountCode", screenSize) : Container(),
                            ticketDistro.discountCodes.length > 0 ? discountListBuilder(screenSize) : Container(),
                            showDiscountCodeForm ? discountCodeForm(screenSize) : Container(),
                            SizedBox(height: 16.0),
                            showTicketForm || showFeeForm || showDiscountCodeForm ? Container() : ticketActions(screenSize),
                            SizedBox(height: 40.0),
                            sectionHeader("3", "Additional Info"),
                            SizedBox(height: 16.0),
                            fieldHeader("Event Privacy", true),
                            eventPrivacyDropdown(screenSize),
                            SizedBox(height: 16.0),
                            fieldHeader("Event Category", true),
                            eventCategoryDropDown(screenSize),
                            SizedBox(height: 16.0),
                            fieldHeader("Event Type", true),
                            eventTypeDropDown(screenSize),
                            SizedBox(height: 32.0),
                            fieldHeader("Social Links (Optional)", false),
                            SizedBox(height: 8.0),
                            fbSocialHeader(),
                            SizedBox(height: 3.0),
                            fbUsernameField(),
                            SizedBox(height: 8.0),
                            instaSocialHeader(),
                            SizedBox(height: 3.0),
                            instaUsernameField(),
                            SizedBox(height: 8.0),
                            twitterSocialHeader(),
                            SizedBox(height: 3.0),
                            twitterUsernameField(),
                            SizedBox(height: 8.0),
                            websiteHeader(),
                            SizedBox(height: 3.0),
                            websiteField(),
                            SizedBox(height: 32.0),
                            Row(
                              mainAxisAlignment: screenSize.isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                                  child: CustomColorButton(
                                    text: "Create Event",
                                    textColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    height: 35.0,
                                    width: 150,
                                    onPressed: () => submitEvent(),
                                  ).showCursorOnHover,
                                ),
                              ],
                            ),
                            SizedBox(height: 64.0),
                          ],
                        ),
                      ),
                Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
