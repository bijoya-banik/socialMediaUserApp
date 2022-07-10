// To parse this JSON data, do
//
//     final pageVideosModel = pageVideosModelFromJson(jsonString);

import 'dart:convert';

PageVideosModel pageVideosModelFromJson(String str) => PageVideosModel.fromJson(json.decode(str));

String pageVideosModelToJson(PageVideosModel data) => json.encode(data.toJson());

class PageVideosModel {
  PageVideosModel({
    this.basicOverView,
    this.videos,
  });

  BasicOverView? basicOverView;
  List<Video>? videos;

  factory PageVideosModel.fromJson(Map<String, dynamic> json) => PageVideosModel(
        basicOverView: BasicOverView.fromJson(json["basicOverView"]),
        videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "basicOverView": basicOverView?.toJson(),
        "videos": List<dynamic>.from(videos??[].map((x) => x.toJson())),
      };
}

class BasicOverView {
  BasicOverView({
    this.id,
    this.userId,
    this.pageName,
    this.slug,
    this.categoryName,
    this.profilePic,
    this.cover,
    this.about,
    this.isPublished,
    this.website,
    this.phone,
    this.email,
    this.country,
    this.city,
    this.address,
    this.totalPageLikes,
    this.createdAt,
    this.updatedAt,
    this.pageFollowers,
    this.meta,
    this.isFollow,
  });

  int? id;
  int? userId;
  String? pageName;
  String? slug;
  String? categoryName;
  String? profilePic;
  String? cover;
  String? about;
  int? isPublished;
  dynamic website;
  dynamic phone;
  dynamic email;
  String? country;
  String? city;
  String? address;
  int? totalPageLikes;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? pageFollowers;
  Meta? meta;
  bool? isFollow;

  factory BasicOverView.fromJson(Map<String, dynamic> json) => BasicOverView(
        id: json["id"],
        userId: json["user_id"],
        pageName: json["page_name"],
        slug: json["slug"],
        categoryName: json["category_name"],
        profilePic: json["profile_pic"],
        cover: json["cover"],
        about: json["about"],
        isPublished: json["is_published"],
        website: json["website"],
        phone: json["phone"],
        email: json["email"],
        country: json["country"],
        city: json["city"],
        address: json["address"],
        totalPageLikes: json["total_page_likes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pageFollowers: List<dynamic>.from(json["pageFollowers"].map((x) => x)),
        meta: Meta.fromJson(json["meta"]),
        isFollow: json["isFollow"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "page_name": pageName,
        "slug": slug,
        "category_name": categoryName,
        "profile_pic": profilePic,
        "cover": cover,
        "about": about,
        "is_published": isPublished,
        "website": website,
        "phone": phone,
        "email": email,
        "country": country,
        "city": city,
        "address": address,
        "total_page_likes": totalPageLikes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pageFollowers": List<dynamic>.from(pageFollowers??[].map((x) => x)),
        "meta": meta?.toJson(),
        "isFollow": isFollow,
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}

class Video {
  Video({
    this.fileLoc,
    this.originalName,
    this.extname,
    this.size,
    this.type,
    this.hashName,
    this.id,
  });

  String? fileLoc;
  String? originalName;
  String? extname;
  int? size;
  String? type;
  String? hashName;
  int? id;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        fileLoc: json["fileLoc"],
        originalName: json["originalName"],
        extname: json["extname"],
        size: json["size"],
        type: json["type"],
        hashName: json["hashName"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "fileLoc": fileLoc,
        "originalName": originalName,
        "extname": extname,
        "size": size,
        "type": type,
        "hashName": hashName,
        "id": id,
      };
}
