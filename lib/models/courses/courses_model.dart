import 'dart:convert';

CoursesModel coursesModelFromJson(String str) => CoursesModel.fromJson(json.decode(str));

String coursesModelToJson(CoursesModel data) => json.encode(data.toJson());

class CoursesModel {
  CoursesModel({
    this.courses,
    this.webnairs,
    this.nrcCourses,
    this.preLicensing,
  });

  List<Course>? courses;
  List<Course>? webnairs;
  List<NrcCourse>? nrcCourses;
  List<NrcCourse>? preLicensing;

  factory CoursesModel.fromJson(Map<String, dynamic> json) => CoursesModel(
        courses: List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
        webnairs: json["webinars"] == null ? null : List<Course>.from(json["webinars"].map((x) => Course.fromJson(x))),
        nrcCourses: List<NrcCourse>.from(json["nrc_courses"].map((x) => NrcCourse.fromJson(x))),
        preLicensing: List<NrcCourse>.from(json["pre_licensing"].map((x) => NrcCourse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "courses": List<dynamic>.from(courses??[].map((x) => x.toJson())),
        "webinars": List<dynamic>.from(webnairs??[].map((x) => x.toJson())),
        "nrc_courses": List<dynamic>.from(nrcCourses??[].map((x) => x.toJson())),
        "pre_licensing": List<dynamic>.from(preLicensing??[].map((x) => x.toJson())),
      };
}

class Course {
  Course({
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
  CourseMeta? meta;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
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
        meta: CourseMeta.fromJson(json["meta"]),
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
        "start_date_time": startDateTime,
        "end_date_time": endDateTime,
        "data": data?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
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
  });

  Cover? cover;
  List<dynamic>? contents;
  String? courseHours;
  String? coursePrice;
  int? totalContents;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cover: Cover.fromJson(json["cover"]),
        contents: List<dynamic>.from(json["contents"].map((x) => x)),
        courseHours: json["course_hours"],
        coursePrice: json["course_price"].toString(),
        totalContents: json["totalContents"],
      );

  Map<String, dynamic> toJson() => {
        "cover": cover?.toJson(),
        "contents": List<dynamic>.from(contents??[].map((x) => x)),
        "course_hours": courseHours,
        "course_price": coursePrice,
        "totalContents": totalContents,
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

class CourseMeta {
  CourseMeta({
    this.isPublished,
    this.subscribersCount,
  });

  String? isPublished;
  int? subscribersCount;

  factory CourseMeta.fromJson(Map<String, dynamic> json) => CourseMeta(
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

class NrcCourse {
  NrcCourse({
    this.id,
    this.title,
    this.description,
    this.cover,
    this.link,
    this.orderId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  String? description;
  String? cover;
  String? link;
  int? orderId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NrcCourse.fromJson(Map<String, dynamic> json) => NrcCourse(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        cover: json["cover"],
        link: json["link"],
        orderId: json["order_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "cover": cover,
        "link": link,
        "order_id": orderId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
