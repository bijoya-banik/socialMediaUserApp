class ConversationGroupPeopleSearchModel {
  ConversationGroupPeopleSearchModel({
    this.group,
    this.people,
  });

  List<Group>? group;
  List<Person>? people;

  factory ConversationGroupPeopleSearchModel.fromJson(Map<String, dynamic> json) => ConversationGroupPeopleSearchModel(
        group: List<Group>.from(json["group"].map((x) => Group.fromJson(x))),
        people: List<Person>.from(json["people"].map((x) => Person.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "group": List<dynamic>.from(group ?? [].map((x) => x.toJson())),
        "people": List<dynamic>.from(people ?? [].map((x) => x.toJson())),
      };
}

class Group {
  Group({
    this.id,
    this.userId,
    this.buddyId,
    this.inboxKey,
    this.isGroup,
    this.groupName,
    this.groupLogo,
    this.isSeen,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.memberNames,
    this.isGroupMember,
    this.groupMembers,
    this.meta,
  });

  int? id;
  int? userId;
  dynamic buddyId;
  String? inboxKey;
  int? isGroup;
  String? groupName;
  String? groupLogo;
  int? isSeen;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? memberNames;
  IsGroupMember? isGroupMember;
  List<dynamic>? groupMembers;
  Meta? meta;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        userId: json["user_id"],
        buddyId: json["buddy_id"],
        inboxKey: json["inbox_key"],
        isGroup: json["is_group"],
        groupName: json["group_name"],
        groupLogo: json["group_logo"],
        isSeen: json["is_seen"],
        isDeleted: json["is_deleted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        memberNames: json["member_names"],
        isGroupMember: IsGroupMember.fromJson(json["is_group_member"]),
        groupMembers: List<dynamic>.from(json["group_members"].map((x) => x)),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "buddy_id": buddyId,
        "inbox_key": inboxKey,
        "is_group": isGroup,
        "group_name": groupName,
        "group_logo": groupLogo,
        "is_seen": isSeen,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "member_names": memberNames,
        "is_group_member": isGroupMember?.toJson(),
        "group_members": List<dynamic>.from(groupMembers ?? [].map((x) => x)),
        "meta": meta?.toJson(),
      };
}

class IsGroupMember {
  IsGroupMember({
    this.id,
    this.inboxId,
    this.userId,
    this.ignoreMsg,
    this.muteNoti,
    this.isLeft,
    this.isSeen,
    this.role,
    this.isGroup,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? inboxId;
  int? userId;
  int? ignoreMsg;
  int? muteNoti;
  int? isLeft;
  int? isSeen;
  String? role;
  int? isGroup;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory IsGroupMember.fromJson(Map<String, dynamic> json) => IsGroupMember(
        id: json["id"],
        inboxId: json["inbox_id"],
        userId: json["user_id"],
        ignoreMsg: json["ignore_msg"],
        muteNoti: json["mute_noti"],
        isLeft: json["is_left"],
        isSeen: json["is_seen"],
        role: json["role"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inbox_id": inboxId,
        "user_id": userId,
        "ignore_msg": ignoreMsg,
        "mute_noti": muteNoti,
        "is_left": isLeft,
        "is_seen": isSeen,
        "role": role,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}

class Person {
  Person({
    this.id,
    this.isOnline,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.username,
    this. isGroup=0,
    this.isGroupMember,
    this.meta,
  });

  int? id;
  String? isOnline;
  String? firstName;
  String? lastName;
  String? profilePic;
  String? username;
  int? isGroup;
  IsGroupMember? isGroupMember;
  Meta? meta;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["id"],
        isOnline: json["is_online"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePic: json["profile_pic"],
        username: json["username"],
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_online": isOnline,
        "first_name": firstName,
        "last_name": lastName,
        "profile_pic": profilePic,
        "username": username,
        "meta": meta?.toJson(),
      };
}
