// To parse this JSON data, do
//
//     final courseModel = courseModelFromJson(jsonString);

import 'dart:convert';

CourseModel courseModelFromJson(String str) => CourseModel.fromJson(json.decode(str));

String courseModelToJson(CourseModel data) => json.encode(data.toJson());

class CourseModel {
  CourseModel({
    this.id,
    this.userId,
    this.orderId,
    this.activityText,
    this.description,
    this.activityType,
    this.privacy,
    this.views,
    this.startDateTime,
    this.endDateTime,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.isSubscriber,
    this.meta,
  });

  int? id;
  int? userId;
  int? orderId;
  String? activityText;
  String? description;
  String? activityType;
  String? privacy;
  int? views;
  DateTime? startDateTime;
  dynamic endDateTime;
  Data? data;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  IsSubscriber? isSubscriber;
  CourseModelMeta? meta;

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json["id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        activityText: json["activity_text"],
        description: json["description"],
        activityType: json["activity_type"],
        privacy: json["privacy"],
        views: json["views"],
        startDateTime: json["start_date_time"] == null ? null : DateTime.parse(json["start_date_time"]),
        endDateTime: json["end_date_time"],
        data: Data.fromJson(json["data"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
        isSubscriber: json["isSubscriber"] == null ? null : IsSubscriber.fromJson(json["isSubscriber"]),
        meta: CourseModelMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "order_id": orderId,
        "activity_text": activityText,
        "description": description,
        "activity_type": activityType,
        "privacy": privacy,
        "views": views,
        "start_date_time": "${startDateTime?.year.toString().padLeft(4, '0')}-${startDateTime?.month.toString().padLeft(2, '0')}-${startDateTime?.day.toString().padLeft(2, '0')}",
        "end_date_time": endDateTime,
        "data": data?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "isSubscriber": isSubscriber?.toJson(),
        "meta": meta?.toJson(),
      };
}

class Data {
  Data({
    this.cover,
    this.contents,
    this.courseHours,
    this.coursePrice,
    this.totalContents,
    this.isSubscription,
  });

  Cover? cover;
  List<Content>? contents;
  String? courseHours;
  String? coursePrice;
  int? totalContents;
  bool? isSubscription;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cover: Cover.fromJson(json["cover"]),
        contents: List<Content>.from(json["contents"].map((x) => Content.fromJson(x))),
        courseHours: json["course_hours"],
        coursePrice: json["course_price"].toString(),
        totalContents: json["totalContents"],
        isSubscription: json["isSubscription"],
      );

  Map<String, dynamic> toJson() => {
        "cover": cover?.toJson(),
        "contents": List<dynamic>.from(contents??[].map((x) => x.toJson())),
        "course_hours": courseHours,
        "course_price": coursePrice,
        "totalContents": totalContents,
        "isSubscription": isSubscription,
      };
}

class Content {
  Content({
    this.source,
    this.hours,
    this.title,
    this.extType,
    this.isIframe,
  });

  String? source;
  String? hours;
  String? title;
  String? extType;
  bool? isIframe;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        source: json["source"],
        hours: json["hours"],
        title: json["title"],
        extType: json["extType"],
        isIframe: json["isIframe"],
      );

  Map<String, dynamic> toJson() => {
        "source": source,
        "hours": hours,
        "title": title,
        "extType": extType,
        "isIframe": isIframe,
      };
}

class Cover {
  Cover({
    this.source,
    this.extType,
  });

  String? source;
  String? extType;

  factory Cover.fromJson(Map<String, dynamic> json) => Cover(
        source: json["source"],
        extType: json["extType"],
      );

  Map<String, dynamic> toJson() => {
        "source": source,
        "extType": extType,
      };
}

class IsSubscriber {
  IsSubscriber({
    this.id,
    this.courseId,
    this.userId,
    this.coupon,
    this.isActive,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? courseId;
  int? userId;
  dynamic coupon;
  int? isActive;
  DateTime? expiredAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory IsSubscriber.fromJson(Map<String, dynamic> json) => IsSubscriber(
        id: json["id"],
        courseId: json["course_id"],
        userId: json["user_id"],
        coupon: json["coupon"],
        isActive: json["is_active"],
        expiredAt: DateTime.parse(json["expired_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "user_id": userId,
        "coupon": coupon,
        "is_active": isActive,
        "expired_at": expiredAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class CourseModelMeta {
  CourseModelMeta({
    this.isPublished,
    this.subscribersCount
  });

  String? isPublished;
  int? subscribersCount;

  factory CourseModelMeta.fromJson(Map<String, dynamic> json) => CourseModelMeta(
        isPublished: json["isPublished"],
        subscribersCount: json["subscribers_count"],
      );

  Map<String, dynamic> toJson() => {
        "isPublished": isPublished,
        "subscribers_count": subscribersCount,
      };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
    this.meta,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePic;
  UserMeta? meta;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        profilePic: json["profile_pic"],
        meta: UserMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "profile_pic": profilePic,
        "meta": meta?.toJson(),
      };
}

class UserMeta {
  UserMeta();

  factory UserMeta.fromJson(Map<String, dynamic> json) => UserMeta();

  Map<String, dynamic> toJson() => {};
}
