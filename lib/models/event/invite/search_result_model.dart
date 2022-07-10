
import 'dart:convert';

List<InviteMemberSearchResultModel> inviteMemberSearchResultModelFromJson(String str) => List<InviteMemberSearchResultModel>.from(json.decode(str).map((x) => InviteMemberSearchResultModel.fromJson(x)));

String inviteMemberSearchResultModelToJson(List<InviteMemberSearchResultModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InviteMemberSearchResultModel {
  InviteMemberSearchResultModel({
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

  factory InviteMemberSearchResultModel.fromJson(Map<String, dynamic> json) => InviteMemberSearchResultModel(
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
