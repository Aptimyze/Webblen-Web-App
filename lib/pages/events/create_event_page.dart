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
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/text_field_container.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/layout/centered_view.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  GlobalKey formKey = GlobalKey<FormState>();
  //Event Details
  String eventTitle;
  String eventDesc;
  //Location Details
  bool enterAddressManually = false;
  String eventAddress;
  String venueName;
  String address1;
  String address2;
  String city;
  String state;
  String zipPostalCode;
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
  // Event Image
  File eventImgFile;
  Uint8List eventImgByteMemory;

  //Ticketing
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
  List<Map<String, dynamic>> eventTickets = [];
  String ticketName;
  String ticketPrice;
  String ticketQuantity;
  List<Map<String, dynamic>> eventFees = [];
  String feeName;
  String feeAmount;
  List<Map<String, dynamic>> discountCodes = [];
  String discountCodeName;
  String discountCodeQuantity;
  String discountCodePercentage;

  //Additional Info & Social Links
  String eventType = 'Select Event Type';
  String eventCategory = 'Select Event Category';
  String fbProfileName;
  String twitterProfileName;

  //Other
  GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: Strings.googleAPIKEY,
  );

  openGoogleAutoComplete() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Strings.googleAPIKEY,
      onError: (res) {
        print(res.errorMessage);
      },
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
    setState(() {
      eventAddress = detail.result.formattedAddress;
    });
  }

  changeEnterAddressManuallyStatus() {
    if (enterAddressManually) {
      enterAddressManually = false;
    } else {
      enterAddressManually = true;
    }
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

  Widget eventLocationField(SizingInformation screenzSize) {
    return enterAddressManually
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFieldContainer(
                  child: TextFormField(
                    cursorColor: Colors.black,
                    validator: (value) => value.isEmpty && enterAddressManually ? 'Field Cannot be Empty' : null,
                    onSaved: (value) => address1 = value.trim(),
                    decoration: InputDecoration(
                      hintText: "Address",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFieldContainer(
                  child: TextFormField(
                    cursorColor: Colors.black,
                    onSaved: (value) => address2 = value.trim(),
                    decoration: InputDecoration(
                      hintText: "Address 2",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: screenzSize.isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                  children: <Widget>[
                    TextFieldContainer(
                      width: 200,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        validator: (value) => value.isEmpty && enterAddressManually ? 'Field Cannot be Empty' : null,
                        onSaved: (value) => city = value.trim(),
                        decoration: InputDecoration(
                          hintText: "City",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    TextFieldContainer(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: DropdownButton(
                            isDense: true,
                            underline: Container(),
                            value: state == null ? Strings.statesList[0] : state,
                            items: Strings.statesList.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                state = val;
                              });
                            }).showCursorOnHover,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    TextFieldContainer(
                      width: screenzSize.isDesktop ? 200 : 150,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        validator: (value) => value.isEmpty && enterAddressManually ? 'Field Cannot be Empty' : null,
                        onSaved: (value) => zipPostalCode = value.trim(),
                        decoration: InputDecoration(
                          hintText: "Zip/Postal",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: () => openGoogleAutoComplete(),
            child: TextFieldContainer(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: CustomText(
                  context: context,
                  text: eventAddress == null ? "Search for Address" : eventAddress,
                  textColor: eventAddress == null ? Colors.black54 : Colors.black,
                  textAlign: TextAlign.left,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ).showCursorOnHover;
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
        cursorColor: Colors.black,
        validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
        maxLines: null,
        onSaved: (value) => eventDesc = value.trim(),
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
          itemCount: eventTickets.length,
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
                      text: eventTickets[index]["ticketName"],
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
                      text: eventTickets[index]["ticketQuantity"],
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
                      text: eventTickets[index]["ticketPrice"],
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
          itemCount: eventFees.length,
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
                      text: eventFees[index]["feeName"],
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
                      text: eventFees[index]["feeAmount"],
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
          itemCount: discountCodes.length,
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
                      text: discountCodes[index]["discountCodeName"],
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
                      text: discountCodes[index]["discountCodeQuantity"],
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
                      text: discountCodes[index]["discountCodePercentage"],
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
                onSaved: (value) => discountCodePercentage = value.trim(),
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
                initialValue: discountCodeQuantity,
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
      ticketName = eventTickets[objectIndex]['ticketName'];
      ticketQuantity = eventTickets[objectIndex]['ticketQuantity'];
      ticketPrice = eventTickets[objectIndex]['ticketPrice'];
      eventTickets.removeAt(objectIndex);
      changeFormStatus("ticketForm");
    } else if (object == "fee") {
      feeName = eventFees[objectIndex]['feeName'];
      feeAmount = eventFees[objectIndex]['feeAmount'];
      eventFees.removeAt(objectIndex);
      changeFormStatus("feeForm");
    } else {
      discountCodeName = discountCodes[objectIndex]['discountCodeName'];
      discountCodeQuantity = discountCodes[objectIndex]['discountCodeQuantity'];
      discountCodePercentage = discountCodes[objectIndex]['discountCodePercentage'];
      discountCodes.removeAt(objectIndex);
      changeFormStatus("discountCodeForm");
    }
  }

  deleteAction(String object, int objectIndex) {
    if (object == "ticket") {
      eventTickets.removeAt(objectIndex);
    } else if (object == "fee") {
      eventFees.removeAt(objectIndex);
    } else {
      discountCodes.removeAt(objectIndex);
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
          eventTickets.length > 0
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
          eventTickets.length > 0
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
      eventTickets.add(eventTicket);
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
      eventFees.add(eventFee);
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
      discountCodes.add(discountCode);
      discountCodeName = null;
      discountCodeQuantity = null;
      discountCodePercentage = null;
      changeFormStatus("discountCodeForm");
      setState(() {});
    }
  }

  //ADDITIONAL INFO & SOCIAL LINKS
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
        cursorColor: Colors.black,
        onSaved: (value) => fbProfileName = value.trim(),
        decoration: InputDecoration(
          hintText: "FB Profile/Page Username",
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
        cursorColor: Colors.black,
        onSaved: (value) => twitterProfileName = value.trim(),
        decoration: InputDecoration(
          hintText: "Twitter Username",
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startDate = dateFormatter.format(selectedDateTime);
    print(selectedDateTime.hour);
    endDate = dateFormatter.format(selectedDateTime);
    startTime = timeFormatter.format(selectedDateTime.add(Duration(hours: 1)));

    endTime = selectedDateTime.hour == 23
        ? "11:30 PM"
        : timeFormatter.format(selectedDateTime.add(Duration(
            hours: selectedDateTime.hour <= 19 ? 4 : selectedDateTime.hour == 20 ? 3 : selectedDateTime.hour == 21 ? 2 : selectedDateTime.hour == 22 ? 1 : 0)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CenteredView(
      addVerticalPadding: false,
      child: ResponsiveBuilder(
        builder: (buildContext, screenSize) => Container(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.isDesktop ? 100 : screenSize.isTablet ? 50.0 : 0),
            child: Form(
              key: null,
              child: ListView(
                shrinkWrap: true,
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
                          text: "Save Event",
                          textColor: Colors.black,
                          backgroundColor: Colors.white,
                          height: 35.0,
                          width: 150,
                          onPressed: null,
                        ).showCursorOnHover,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  sectionHeader("1", "Event Details"),
                  //EVENT TITLE
                  fieldHeader("Event Title", true),
                  eventTitleField(),
                  SizedBox(height: 16.0),
                  //EVENT LOCATION
                  fieldHeader("Location", true),
                  eventLocationField(screenSize),
                  SizedBox(height: 4.0),
                  enterAddressManually
                      ? GestureDetector(
                          onTap: () => changeEnterAddressManuallyStatus(),
                          child: CustomText(
                            context: context,
                            text: "Search for Address Automatically",
                            textColor: Colors.blueAccent,
                            textAlign: TextAlign.left,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          )).showCursorOnHover
                      : GestureDetector(
                          onTap: () => changeEnterAddressManuallyStatus(),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 4.0),
                            child: CustomText(
                              context: context,
                              text: "Enter Address Manually",
                              textColor: Colors.blueAccent,
                              textAlign: TextAlign.left,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ).showCursorOnHover,
                  SizedBox(height: 32.0),
                  //EVENT DATE & TIME
                  eventTimeFields(screenSize),
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
                  showTicketForm || eventTickets.length > 0 ? fieldHeader("Tickets", false) : Container(),
                  showTicketForm || eventTickets.length > 0 ? ticketingFormHeader("ticket", screenSize) : Container(),
                  eventTickets.length > 0 ? ticketListBuilder(screenSize) : Container(),
                  showTicketForm ? ticketForm(screenSize) : Container(),
                  //Fees
                  showFeeForm || eventFees.length > 0 ? fieldHeader("Fees", false) : Container(),
                  showFeeForm || eventFees.length > 0 ? ticketingFormHeader("fee", screenSize) : Container(),
                  eventFees.length > 0 ? feeListBuilder(screenSize) : Container(),
                  showFeeForm ? feeForm(screenSize) : Container(),
                  //Discount Codes
                  showDiscountCodeForm || discountCodes.length > 0 ? fieldHeader("Discount Codes", false) : Container(),
                  showDiscountCodeForm || discountCodes.length > 0 ? ticketingFormHeader("discountCode", screenSize) : Container(),
                  discountCodes.length > 0 ? discountListBuilder(screenSize) : Container(),
                  showDiscountCodeForm ? discountCodeForm(screenSize) : Container(),
                  SizedBox(height: 16.0),
                  showTicketForm || showFeeForm || showDiscountCodeForm ? Container() : ticketActions(screenSize),
                  SizedBox(height: 40.0),
                  sectionHeader("3", "Additional Info"),
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
                  twitterSocialHeader(),
                  SizedBox(height: 3.0),
                  twitterUsernameField(),
                  SizedBox(height: 64.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
