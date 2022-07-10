// To parse this JSON data, do
//
//     final inviteMemberModel = inviteMemberModelFromJson(jsonString);

import 'dart:convert';

InviteMemberModel inviteMemberModelFromJson(String str) => InviteMemberModel.fromJson(json.decode(str));

String inviteMemberModelToJson(InviteMemberModel data) => json.encode(data.toJson());

class InviteMemberModel {
  InviteMemberModel({
    this.isGoing,
    this.basicOverView,
    this.allFriends,
    this.allInvitedMembers,
  });

  dynamic isGoing;
  BasicOverView? basicOverView;
  List<AllFriend>? allFriends;
  List<AllInvitedMember>? allInvitedMembers;

  factory InviteMemberModel.fromJson(Map<String, dynamic> json) => InviteMemberModel(
    isGoing: json["isGoing"],
    basicOverView: BasicOverView.fromJson(json["basicOverView"]),
    allFriends: List<AllFriend>.from(json["allFriends"].map((x) => AllFriend.fromJson(x))),
    allInvitedMembers: List<AllInvitedMember>.from(json["allInvitedMembers"].map((x) => AllInvitedMember.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isGoing": isGoing,
    "basicOverView": basicOverView?.toJson(),
    "allFriends": List<dynamic>.from(allFriends??[].map((x) => x.toJson())),
    "allInvitedMembers": List<dynamic>.from(allInvitedMembers??[].map((x) => x.toJson())),
  };
}

class AllFriend {
  AllFriend({
    this.id,
    this.userId,
    this.friendId,
    this.status,
    this.friend,
  });

  int? id;
  int? userId;
  int? friendId;
  String? status;
  Friend? friend;

  factory AllFriend.fromJson(Map<String, dynamic> json) => AllFriend(
    id: json["id"],
    userId: json["user_id"],
    friendId: json["friend_id"],
    status: json["status"],
    friend: Friend.fromJson(json["friend"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "friend_id": friendId,
    "status": status,
    "friend": friend?.toJson(),
  };
}

class Friend {
  Friend({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.username,
    this.meta,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? profilePic;
  String? username;
  Meta? meta;

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePic: json["profile_pic"],
    username: json["username"],
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "profile_pic": profilePic,
    "username": username,
    "meta": meta?.toJson(),
  };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
  );

  Map<String, dynamic> toJson() => {
  };
}

class AllInvitedMember {
  AllInvitedMember({
    this.id,
    this.userId,
    this.fromUserId,
    this.eventId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.friend,
  });

  int? id;
  int? userId;
  dynamic fromUserId;
  int? eventId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Friend? friend;

  factory AllInvitedMember.fromJson(Map<String, dynamic> json) => AllInvitedMember(
    id: json["id"],
    userId: json["user_id"],
    fromUserId: json["from_user_id"],
    eventId: json["event_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    friend: Friend.fromJson(json["friend"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "from_user_id": fromUserId,
    "event_id": eventId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "friend": friend?.toJson(),
  };
}

class BasicOverView {
  BasicOverView({
    this.id,
    this.eventName,
    this.slug,
    this.cover,
    this.about,
    this.isPublished,
    this.country,
    this.city,
    this.address,
    this.startTime,
    this.endTime,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.going,
    this.interested,
    this.meta,
  });

  int? id;
  String? eventName;
  String? slug;
  String? cover;
  String? about;
  int? isPublished;
  dynamic country;
  dynamic city;
  String? address;
  DateTime? startTime;
  DateTime? endTime;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Going>? going;
  List<dynamic>? interested;
  Meta? meta;

  factory BasicOverView.fromJson(Map<String, dynamic> json) => BasicOverView(
    id: json["id"],
    eventName: json["event_name"],
    slug: json["slug"],
    cover: json["cover"],
    about: json["about"],
    isPublished: json["is_published"],
    country: json["country"],
    city: json["city"],
    address: json["address"],
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    going: List<Going>.from(json["going"].map((x) => Going.fromJson(x))),
    interested: List<dynamic>.from(json["interested"].map((x) => x)),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_name": eventName,
    "slug": slug,
    "cover": cover,
    "about": about,
    "is_published": isPublished,
    "country": country,
    "city": city,
    "address": address,
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime?.toIso8601String(),
    "user_id": userId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "going": List<dynamic>.from(going??[].map((x) => x.toJson())),
    "interested": List<dynamic>.from(interested??[].map((x) => x)),
    "meta": meta?.toJson(),
  };
}

class Going {
  Going({
    this.id,
    this.eventId,
  });

  int? id;
  int? eventId;

  factory Going.fromJson(Map<String, dynamic> json) => Going(
    id: json["id"],
    eventId: json["event_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_id": eventId,
  };
}
