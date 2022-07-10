class PagesModel {
  PagesModel({
    this.meta,
    this.data,
  });

  PagesModelMeta? meta;
  List<PageDatum>? data;

  factory PagesModel.fromJson(Map<String, dynamic> json) => PagesModel(
        meta: PagesModelMeta.fromJson(json["meta"]),
        data: List<PageDatum>.from(
            json["data"].map((x) => PageDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": List<dynamic>.from(data??[].map((x) => x.toJson())),
      };
}

class PageDatum {
  PageDatum({
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
  String? website;
  String? phone;
  String? email;
  String? country;
  String? city;
  String? address;
  int? totalPageLikes;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<PageFollower>? pageFollowers;
  PageDatumMeta? meta;

  factory PageDatum.fromJson(Map<String, dynamic> json) => PageDatum(
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
        totalPageLikes:
            json["total_page_likes"] < 0 ? 0 : json["total_page_likes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pageFollowers: json["pageFollowers"] == null
            ? null
            : List<PageFollower>.from(
                json["pageFollowers"].map((x) => PageFollower.fromJson(x))),
        meta: PageDatumMeta.fromJson(json["meta"]),
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
        "total_page_likes": totalPageLikes! < 0 ? 0 : totalPageLikes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pageFollowers": pageFollowers == null
            ? null
            : List<dynamic>.from(pageFollowers??[].map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class PageDatumMeta {
  PageDatumMeta();

  factory PageDatumMeta.fromJson(Map<String, dynamic> json) => PageDatumMeta();

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

class PagesModelMeta {
  PagesModelMeta({
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
  dynamic currentPage;
  int? lastPage;
  int? firstPage;
  String? firstPageUrl;
  String? lastPageUrl;
  dynamic nextPageUrl;
  dynamic previousPageUrl;

  factory PagesModelMeta.fromJson(Map<String, dynamic> json) => PagesModelMeta(
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
