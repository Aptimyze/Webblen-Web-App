class CommunityPermissions {
  bool eventsRequireApproval;
  bool postsRequireApproval;

  CommunityPermissions({this.eventsRequireApproval, this.postsRequireApproval});

  CommunityPermissions.fromMap(Map<String, dynamic> data)
      : this(
          eventsRequireApproval: data['eventsRequireApproval'],
          postsRequireApproval: data['postsRequireApproval'],
        );

  Map<String, dynamic> toMap() => {
        'eventsRequireApproval': this.eventsRequireApproval,
        'postsRequireApproval': this.postsRequireApproval,
      };
}
