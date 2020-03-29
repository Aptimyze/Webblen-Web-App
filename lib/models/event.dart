class Event {
  String id;
  String authorID;
  String chatID;
  String ticketDistroID;
  bool flashEvent;
  String name;
  String desc;
  String imageURL;
  String venueName;
  String streetAddress;
  String city;
  String state;
  String zipPostalCode;
  String countryRegion;
  List sharedComs;
  List tags;
  String category;
  int clicks;
  String website;
  double checkInRadius;
  int estimatedTurnout;
  int actualTurnout;
  List attendees;
  double eventPayout;
  String recurrence;
  int startDateTimeInMilliseconds;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  String timezone;
  String privacy;
  bool reported;

  Event({
    this.id,
    this.authorID,
    this.chatID,
    this.ticketDistroID,
    this.flashEvent,
    this.name,
    this.desc,
    this.imageURL,
    this.city,
    this.streetAddress,
    this.state,
    this.zipPostalCode,
    this.countryRegion,
    this.sharedComs,
    this.tags,
    this.category,
    this.clicks,
    this.website,
    this.checkInRadius,
    this.estimatedTurnout,
    this.actualTurnout,
    this.attendees,
    this.eventPayout,
    this.recurrence,
    this.startDateTimeInMilliseconds,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.timezone,
    this.privacy,
    this.reported,
  });

  Event.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          authorID: data['authorID'],
          chatID: data['chatID'],
          ticketDistroID: data['ticketDistroID'],
          flashEvent: data['flashEvent'],
          name: data['name'],
          desc: data['desc'],
          imageURL: data['imageURL'],
          city: data['city'],
          streetAddress: data['streetAddress'],
          state: data['state'],
          zipPostalCode: data['zipPostalCode'],
          countryRegion: data['countryRegion'],
          sharedComs: data['sharedComs'],
          tags: data['tags'],
          category: data['category'],
          clicks: data['clicks'],
          website: data['website'],
          checkInRadius: data['checkInRadius'],
          estimatedTurnout: data['estimatedTurnout'],
          actualTurnout: data['actualTurnout'],
          attendees: data['attendees'],
          eventPayout: data['eventPayout'],
          recurrence: data['recurrence'],
          startDateTimeInMilliseconds: data['startDateTimeInMilliseconds'],
          startDate: data['startDate'],
          startTime: data['startTime'],
          endDate: data['endDate'],
          endTime: data['endTime'],
          timezone: data['timezone'],
          privacy: data['privacy'],
          reported: data['reported'],
        );

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'authorID': this.authorID,
        'chatID': this.chatID,
        'ticketDistroID': this.ticketDistroID,
        'flashEvent': this.flashEvent,
        'name': this.name,
        'desc': this.desc,
        'imageURL': this.imageURL,
        'city': this.city,
        'streetAddress': this.streetAddress,
        'state': this.state,
        'zipPostalCode': this.zipPostalCode,
        'countryRegion': this.countryRegion,
        'sharedComs': this.sharedComs,
        'tags': this.tags,
        'category': this.category,
        'clicks': this.clicks,
        'website': this.website,
        'checkInRadius': this.checkInRadius,
        'estimatedTurnout': this.estimatedTurnout,
        'actualTurnout': this.actualTurnout,
        'attendees': this.attendees,
        'eventPayout': this.eventPayout,
        'recurrence': this.recurrence,
        'startDateTimeInMilliseconds': this.startDateTimeInMilliseconds,
        'startDate': this.startDate,
        'startTime': this.startTime,
        'endDate': this.endDate,
        'endTime': this.endTime,
        'timezone': this.timezone,
        'privacy': this.privacy,
        'reported': this.reported,
      };
}
