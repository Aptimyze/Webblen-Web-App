class Community {
  String id;
  String chatID;
  String name;
  String desc;
  String imageURL;
  List admin;
  List pendingMemberIDs;
  List memberIDs;
  List cities;
  List locales;
  List approvedEventIDs;
  List pendingEventIDs;
  List approvedPostIDs;
  List pendingPostIDs;
  List tags;
  String privacy;
  Map<String, dynamic> permissions;
  bool reported;
  int activityCount;
  int lastTimeOfActivityInMilliseconds;
  String category;

  Community({
    this.id,
    this.chatID,
    this.name,
    this.desc,
    this.imageURL,
    this.admin,
    this.pendingMemberIDs,
    this.memberIDs,
    this.cities,
    this.locales,
    this.approvedEventIDs,
    this.pendingEventIDs,
    this.approvedPostIDs,
    this.pendingPostIDs,
    this.tags,
    this.privacy,
    this.permissions,
    this.reported,
    this.activityCount,
    this.lastTimeOfActivityInMilliseconds,
    this.category,
  });

  Community.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          chatID: data['chatID'],
          name: data['name'],
          desc: data['desc'],
          imageURL: data['imageURL'],
          admin: data['admin'],
          pendingMemberIDs: data['pendingMemberIDs'],
          memberIDs: data['memberIDs'],
          cities: data['cities'],
          locales: data['locales'],
          approvedEventIDs: data['approvedEventIDs'],
          pendingEventIDs: data['pendingEventIDs'],
          approvedPostIDs: data['approvedPostIDs'],
          pendingPostIDs: data['pendingPostIDs'],
          tags: data['tags'],
          privacy: data['privacy'],
          permissions: data['permissions'],
          reported: data['reported'],
          activityCount: data['activityCount'],
          lastTimeOfActivityInMilliseconds: data['lastTimeOfActivityInMilliseconds'],
          category: data['category'],
        );

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'chatID': this.chatID,
        'name': this.name,
        'desc': this.desc,
        'imageURL': this.imageURL,
        'admin': this.admin,
        'pendingMemberIDs': this.pendingMemberIDs,
        'memberIDs': this.memberIDs,
        'cities': this.cities,
        'locales': this.locales,
        'approvedEventIDs': this.approvedEventIDs,
        'pendingEventIDs': this.pendingEventIDs,
        'approvedPostIDs': this.approvedPostIDs,
        'pendingPostIDs': this.pendingPostIDs,
        'tags': this.tags,
        'privacy': this.privacy,
        'permissions': this.permissions,
        'reported': this.reported,
        'activityCount': this.activityCount,
        'lastTimeOfActivityInMilliseconds': this.lastTimeOfActivityInMilliseconds,
        'category': this.category,
      };
}
