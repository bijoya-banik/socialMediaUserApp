class PageAboutModel {
  PageAboutModel({
    this.basicOverView,
  });

  BasicOverView? basicOverView;

  factory PageAboutModel.fromJson(Map<String, dynamic> json) => PageAboutModel(
        basicOverView: BasicOverView.fromJson(json["basicOverView"]),
      );

  Map<String, dynamic> toJson() => {
        "basicOverView": basicOverView?.toJson(),
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
        country: json["country"]??"",
        city: json["city"]??"",
        address: json["address"]??"",
        totalPageLikes: json["total_page_likes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pageFollowers: json["pageFollowers"]==null?[]:List<dynamic>.from(json["pageFollowers"].map((x) => x)),
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
        "pageFollowers":pageFollowers==null?[]: List<dynamic>.from(pageFollowers??[].map((x) => x)),
        "meta": meta?.toJson(),
        "isFollow": isFollow,
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}
