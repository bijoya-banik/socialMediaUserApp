// To parse this JSON data, do
//
//     final pagePhotosModel = pagePhotosModelFromJson(jsonString);

import 'dart:convert';

PagePhotosModel pagePhotosModelFromJson(String str) => PagePhotosModel.fromJson(json.decode(str));

String pagePhotosModelToJson(PagePhotosModel data) => json.encode(data.toJson());

class PagePhotosModel {
  PagePhotosModel({
    this.basicOverView,
    this.photos,
  });

  BasicOverView? basicOverView;
  List<Photo>? photos;

  factory PagePhotosModel.fromJson(Map<String, dynamic> json) => PagePhotosModel(
        basicOverView: BasicOverView.fromJson(json["basicOverView"]),
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "basicOverView": basicOverView?.toJson(),
        "photos": List<dynamic>.from(photos??[].map((x) => x.toJson())),
      };
}

class BasicOverView {
  BasicOverView({
    this.id,
    this.userId,
    this.pageName,
    this.pageTitle,
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
  String? pageTitle;
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
  List<PageFollower>? pageFollowers;
  Meta? meta;
  bool? isFollow;

  factory BasicOverView.fromJson(Map<String, dynamic> json) => BasicOverView(
        id: json["id"],
        userId: json["user_id"],
        pageName: json["page_name"],
        pageTitle: json["page_title"],
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
        pageFollowers: List<PageFollower>.from(json["pageFollowers"].map((x) => PageFollower.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
        isFollow: json["isFollow"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "page_name": pageName,
        "page_title": pageTitle,
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
        "pageFollowers": List<dynamic>.from(pageFollowers??[].map((x) => x.toJson())),
        "meta": meta?.toJson(),
        "isFollow": isFollow,
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}

class PageFollower {
  PageFollower({
    this.id,
    this.userId,
    this.pageId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? pageId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PageFollower.fromJson(Map<String, dynamic> json) => PageFollower(
        id: json["id"],
        userId: json["user_id"],
        pageId: json["page_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "page_id": pageId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Photo {
  Photo({
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

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
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
