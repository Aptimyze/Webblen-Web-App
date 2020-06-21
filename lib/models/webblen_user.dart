class WebblenUser {
  String messageToken;
  String username;
  String uid;
  String profile_pic;
  List savedEvents;
  List tags;
  List friends;
  List blockedUsers;
  double eventPoints;
  double ap;
  int apLvl;
  int eventsToLvlUp;
  int lastCheckInTimeInMilliseconds;
  int lastNotifInMilliseconds;
  int lastPayoutTimeInMilliseconds;
  bool canMakeAds;
  bool isAdmin;

  WebblenUser({
    this.messageToken,
    this.username,
    this.uid,
    this.profile_pic,
    this.savedEvents,
    this.tags,
    this.friends,
    this.blockedUsers,
    this.eventPoints,
    this.ap,
    this.apLvl,
    this.eventsToLvlUp,
    this.lastCheckInTimeInMilliseconds,
    this.lastNotifInMilliseconds,
    this.lastPayoutTimeInMilliseconds,
    this.canMakeAds,
    this.isAdmin,
  });

  WebblenUser.fromMap(Map<String, dynamic> data)
      : this(
          messageToken: data['messageToken'],
          username: data['username'],
          uid: data['uid'],
          profile_pic: data['profile_pic'],
          savedEvents: data['savedEvents'],
          tags: data['tags'],
          friends: data['friends'],
          blockedUsers: data['blockedUsers'],
          eventPoints: data['eventPoints'],
          ap: data['ap'],
          apLvl: data['apLvl'],
          eventsToLvlUp: data['eventsToLvlUp'],
          lastCheckInTimeInMilliseconds: data['lastCheckInTimeInMilliseconds'],
          lastNotifInMilliseconds: data['lastNotifInMilliseconds'],
          lastPayoutTimeInMilliseconds: data['lastPayoutTimeInMilliseconds'],
          canMakeAds: data['canMakeAds'],
          isAdmin: data['isAdmin'],
        );

  Map<String, dynamic> toMap() => {
        'messageToken': this.messageToken,
        'username': this.username,
        'uid': this.uid,
        'profile_pic': this.profile_pic,
        'savedEvents': this.savedEvents,
        'tags': this.tags,
        'friends': this.friends,
        'blockedUsers': this.blockedUsers,
        'eventPoints': this.eventPoints,
        'ap': this.ap,
        'apLvl': this.apLvl,
        'eventsToLvlUp': this.eventsToLvlUp,
        'lastCheckInTimeInMilliseconds': this.lastCheckInTimeInMilliseconds,
        'lastNotifInMilliseconds': this.lastNotifInMilliseconds,
        'lastPayoutTimeInMilliseconds': this.lastPayoutTimeInMilliseconds,
        'canMakeAds': this.canMakeAds,
        'isAdmin': this.isAdmin,
      };
}
