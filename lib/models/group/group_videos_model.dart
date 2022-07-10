class GroupVideosModel {
  GroupVideosModel({
    this.basicOverView,
    this.videos,
  });

  BasicOverView? basicOverView;
  List<Video>? videos;

  factory GroupVideosModel.fromJson(Map<String, dynamic> json) => GroupVideosModel(
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
    this.isMember,
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
  IsMember? isMember;
  Meta? meta;

  factory BasicOverView.fromJson(Map<String, dynamic> json) => BasicOverView(
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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isMember: IsMember.fromJson(json["is_member"]),
        meta: Meta.fromJson(json["meta"]),
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
        "is_member": isMember?.toJson(),
        "meta": meta?.toJson(),
      };
}

class IsMember {
  IsMember({
    this.id,
    this.userId,
    this.groupId,
    this.isAdmin,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? groupId;
  String? isAdmin;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory IsMember.fromJson(Map<String, dynamic> json) => IsMember(
        id: json["id"],
        userId: json["user_id"],
        groupId: json["group_id"],
        isAdmin: json["is_admin"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "group_id": groupId,
        "is_admin": isAdmin,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
