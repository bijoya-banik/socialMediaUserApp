
import 'dart:convert';

List<ConversationSearchResultModel> conversationSearchResultModelFromJson(String str) => List<ConversationSearchResultModel>.from(json.decode(str).map((x) => ConversationSearchResultModel.fromJson(x)));

String conversationSearchResultModelToJson(List<ConversationSearchResultModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConversationSearchResultModel {
  ConversationSearchResultModel({
    this.id,
    this.isOnline,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.username,
    this.meta,
  });

  int? id;
  String? isOnline;
  String? firstName;
  String? lastName;
  String? profilePic;
  String? username;
  Meta? meta;

  factory ConversationSearchResultModel.fromJson(Map<String, dynamic> json) => ConversationSearchResultModel(
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

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
  );

  Map<String, dynamic> toJson() => {
  };
}
