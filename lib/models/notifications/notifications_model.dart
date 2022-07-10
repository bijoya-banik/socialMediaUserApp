// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  NotificationsModel({
    this.meta,
    this.data,
  });

  NotificationsModelMeta? meta;
  List<Notifications>? data;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    meta: NotificationsModelMeta.fromJson(json["meta"]),
    data: List<Notifications>.from(json["data"].map((x) => Notifications.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "data": List<dynamic>.from(data??[].map((x) => x.toJson())),
  };
}

class Notifications {
  Notifications({
    this.id,
    this.userId,
    this.fromId,
    this.feedId,
    this.commentId,
    this.otherCount,
    this.notiType,
    this.seen,
    this.counter,
    this.notiMeta,
    this.createdAt,
    this.updatedAt,
    this.fromUser,
  });

  int? id;
  int? userId;
  int? fromId;
  int? feedId;
  int? commentId;
  int? otherCount;
  String? notiType;
  int? seen;
  int? counter;
  NotiMeta? notiMeta;
  DateTime? createdAt;
  DateTime? updatedAt;
  FromUser? fromUser;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    id: json["id"],
    userId: json["user_id"],
    fromId: json["from_id"],
    feedId: json["feed_id"],
    commentId: json["comment_id"],
    otherCount: json["other_count"],
    notiType: json["noti_type"],
    seen: json["seen"],
    counter: json["counter"],
    notiMeta: NotiMeta.fromJson(json["noti_meta"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    fromUser: FromUser.fromJson(json["from_user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "from_id": fromId,
    "feed_id": feedId,
    "comment_id": commentId,
    "other_count": otherCount,
    "noti_type": notiType,
    "seen": seen,
    "counter": counter,
    "noti_meta": notiMeta?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "from_user": fromUser?.toJson(),
  };
}

class FromUser {
  FromUser({
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
  FromUserMeta? meta;

  factory FromUser.fromJson(Map<String, dynamic> json) => FromUser(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePic: json["profile_pic"],
    username: json["username"],
    meta: FromUserMeta.fromJson(json["meta"]),
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

class FromUserMeta {
  FromUserMeta();

  factory FromUserMeta.fromJson(Map<String, dynamic> json) => FromUserMeta(
  );

  Map<String, dynamic> toJson() => {
  };
}

class NotiMeta {
  NotiMeta({
    this.id,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.actionText,
    this.commentText,
    this.slug,
    this.username,
  });

  int? id;
  String? profilePic;
  String? firstName;
  String? lastName;
  String? actionText;
  String? commentText;
  String? slug;
  String? username;

  factory NotiMeta.fromJson(Map<String, dynamic> json) => NotiMeta(
    id: json["id"],
    profilePic: json["profile_pic"],
    firstName: json["first_name"] ,
    lastName: json["last_name"],
    actionText: json["action_text"],
    commentText: json["comment_text"],
    slug: json["slug"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "profile_pic": profilePic,
    "first_name": firstName,
    "last_name": lastName,
    "action_text": actionText,
    "comment_text": commentText,
    "slug": slug,
    "username": username,
  };
}

class NotificationsModelMeta {
  NotificationsModelMeta({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  int? firstPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? nextPageUrl;
  dynamic previousPageUrl;

  factory NotificationsModelMeta.fromJson(Map<String, dynamic> json) => NotificationsModelMeta(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    firstPage: json["first_page"],
    firstPageUrl: json["first_page_url"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    previousPageUrl: json["previous_page_url"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "first_page": firstPage,
    "first_page_url": firstPageUrl,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "previous_page_url": previousPageUrl,
  };
}
