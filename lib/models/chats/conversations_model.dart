import 'dart:convert';

List<ConversationsModel> conversationsModelFromJson(String str) =>
    List<ConversationsModel>.from(json.decode(str).map((x) => ConversationsModel.fromJson(x)));

String conversationsModelToJson(List<ConversationsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConversationsModel {
  ConversationsModel(
      {this.id,
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
      this.lastmsg,
      this.memberName,
      this.buddy,
      this.isGroupMember,
      this.groupMembers,
      this.meta});

  int? id;
  int? userId;
  int? buddyId;
  String? inboxKey;
  int? isGroup;
  dynamic groupName;
  dynamic groupLogo;
  int? isSeen;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  Lastmsg? lastmsg;
  String? memberName;
  Buddy? buddy;
  GroupMember? isGroupMember;
  List<GroupMember>? groupMembers;
  GroupChatAllMemberModelMeta? meta;

  factory ConversationsModel.fromJson(Map<String, dynamic> json) => ConversationsModel(
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
        lastmsg: json["lastmsg"] == null ? null : Lastmsg.fromJson(json["lastmsg"]),
        memberName: json["member_names"],
        buddy: json["buddy"] == null ? null : Buddy.fromJson(json["buddy"]),
        isGroupMember: json["is_group_member"] == null ? null : GroupMember.fromJson(json["is_group_member"]),
        groupMembers:json["group_members"]==null?null: List<GroupMember>.from(json["group_members"].map((x) => GroupMember.fromJson(x))),
        meta: GroupChatAllMemberModelMeta.fromJson(json["meta"]),
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
        "lastmsg": lastmsg?.toJson(),
        "member_names": memberName,
        "buddy": buddy?.toJson(),
        "is_group_member": isGroupMember?.toJson(),
        "group_members": List<dynamic>.from(groupMembers ?? [].map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class Buddy {
  Buddy({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
    this.meta,
    this.isOnline,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePic;
  String? isOnline;
  Meta? meta;

  factory Buddy.fromJson(Map<String, dynamic> json) => Buddy(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        profilePic: json["profile_pic"],
        isOnline: json["is_online"],
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "profile_pic": profilePic,
        "is_online": isOnline,
        "meta": meta?.toJson(),
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}

class Lastmsg {
  Lastmsg({this.id, this.userId, this.inboxKey, this.msg, this.files, this.isDeleted, this.createdAt, this.updatedAt, this.user});

  int? id;
  int? userId;
  String? inboxKey;
  String? msg;
  dynamic files;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  Buddy? user;

  factory Lastmsg.fromJson(Map<String, dynamic> json) => Lastmsg(
        id: json["id"],
        userId: json["user_id"],
        inboxKey: json["inbox_key"],
        msg: json["msg"],
        files: json["files"],
        isDeleted: json["is_deleted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: Buddy.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "inbox_key": inboxKey,
        "msg": msg,
        "files": files,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class GroupMember {
  GroupMember({
    this.id,
    this.inboxId,
    this.userId,
    this.ignoreMsg,
    this.muteNoti,
    this.isLeft,
    this.isSeen,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  int? inboxId;
  int? userId;
  int? ignoreMsg;
  int? muteNoti;
  int? isLeft;
  int? isSeen;
  String? role;
  DateTime? createdAt;
  DateTime? updatedAt;
  Buddy? user;

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
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
        user: json["user"] == null ? null : Buddy.fromJson(json["user"]),
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
        "user": user?.toJson(),
      };
}

class GroupChatAllMemberModelMeta {
  GroupChatAllMemberModelMeta({
    this.totalMembers,
  });

  int? totalMembers;

  factory GroupChatAllMemberModelMeta.fromJson(Map<String, dynamic> json) => GroupChatAllMemberModelMeta(
        totalMembers: json["totalMembers"],
      );

  Map<String, dynamic> toJson() => {
        "totalMembers": totalMembers,
      };
}
