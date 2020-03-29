class WebblenUser {
  String messageToken;
  String username;
  String uid;
  String profilePicURL;
  List savedEvents;
  List tags;
  List friends;
  List blockedUsers;
  double webblen;
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
    this.profilePicURL,
    this.savedEvents,
    this.tags,
    this.friends,
    this.blockedUsers,
    this.webblen,
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
          profilePicURL: data['profilePicURL'],
          savedEvents: data['savedEvents'],
          tags: data['tags'],
          friends: data['friends'],
          blockedUsers: data['blockedUsers'],
          webblen: data['webblen'],
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
        'profilePicURL': this.profilePicURL,
        'savedEvents': this.savedEvents,
        'tags': this.tags,
        'friends': this.friends,
        'blockedUsers': this.blockedUsers,
        'webblen': this.webblen,
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
