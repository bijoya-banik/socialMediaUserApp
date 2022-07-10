class GroupsModel {
  GroupsModel({
    this.meta,
    this.data,
  });

  GroupsModelMeta? meta;
  List<GroupDatum>? data;

  factory GroupsModel.fromJson(Map<String, dynamic> json) => GroupsModel(
        meta: GroupsModelMeta.fromJson(json["meta"]),
        data: List<GroupDatum>.from(json["data"].map((x) => GroupDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": List<dynamic>.from(data??[].map((x) => x.toJson())),
      };
}

class GroupDatum {
  GroupDatum({
    this.id,
    this.groupName,
    this.slug,
    this.profilePic,
    this.cover,
    this.about,
    this.country,
    this.city,
    this.address,
    this.groupPrivacy,
    this.totalMembers,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
    this.meta,
  });

  int? id;
  String? groupName;
  String? slug;
  String? profilePic;
  String? cover;
  String? about;
  dynamic country;
  dynamic city;
  dynamic address;
  String? groupPrivacy;
  int? totalMembers;
  String? categoryName;
  DateTime? createdAt;
  DateTime? updatedAt;
  GroupDatumMeta? meta;

  factory GroupDatum.fromJson(Map<dynamic, dynamic> json) => GroupDatum(
        id: json["id"],
        groupName: json["group_name"],
        slug: json["slug"],
        profilePic: json["profile_pic"],
        cover: json["cover"],
        about: json["about"],
        country: json["country"],
        city: json["city"],
        address: json["address"],
        groupPrivacy: json["group_privacy"],
        totalMembers: json["total_members"],
        categoryName: json["category_name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        meta: json["meta"] == null ? null : GroupDatumMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "slug": slug,
        "profile_pic": profilePic,
        "cover": cover,
        "about": about,
        "country": country,
        "city": city,
        "address": address,
        "group_privacy": groupPrivacy,
        "total_members": totalMembers,
        "category_name": categoryName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "meta": meta?.toJson(),
      };
}

class GroupDatumMeta {
  GroupDatumMeta();

  factory GroupDatumMeta.fromJson(Map<String, dynamic> json) => GroupDatumMeta();

  Map<String, dynamic> toJson() => {};
}

class GroupsModelMeta {
  GroupsModelMeta({
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
  dynamic nextPageUrl;
  dynamic previousPageUrl;

  factory GroupsModelMeta.fromJson(Map<String, dynamic> json) => GroupsModelMeta(
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
