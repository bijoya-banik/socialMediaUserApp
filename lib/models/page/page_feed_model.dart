import 'package:buddyscripts/models/feed/feed_model.dart';

class PageFeedModel {
  PageFeedModel({
    this.basicOverView,
    this.feedData,
  });

  BasicOverView? basicOverView;
  List<FeedModel>? feedData;

  factory PageFeedModel.fromJson(Map<String, dynamic> json) => PageFeedModel(
        basicOverView: BasicOverView.fromJson(json["basicOverView"]),
        feedData: List<FeedModel>.from(
            json["feedData"].map((x) => FeedModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "basicOverView": basicOverView?.toJson(),
        "feedData": List<FeedModel>.from(feedData??[].map((x) => x.toJson())),
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
  dynamic country;
  dynamic city;
  dynamic address;
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
        totalPageLikes:
            json["total_page_likes"] < 0 ? 0 : json["total_page_likes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pageFollowers: json["pageFollowers"] == null
            ? []
            : List<PageFollower>.from(
                json["pageFollowers"].map((x) => PageFollower.fromJson(x))),
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
        "total_page_likes": totalPageLikes! < 0 ? 0 : totalPageLikes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pageFollowers": pageFollowers == null
            ? []
            : List<dynamic>.from(pageFollowers??[].map((x) => x.toJson())),
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
