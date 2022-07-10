class EventVideosModel {
  EventVideosModel({
    this.isGoing,
    this.basicOverView,
    this.videos,
  });

  IsGoing? isGoing;
  BasicOverView? basicOverView;
  List<Video>? videos;

  factory EventVideosModel.fromJson(Map<String, dynamic> json) => EventVideosModel(
        isGoing:json["isGoing"]==null?null: IsGoing.fromJson(json["isGoing"]),
        basicOverView: BasicOverView.fromJson(json["basicOverView"]),
        videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isGoing":isGoing?? isGoing?.toJson(),
        "basicOverView": basicOverView?.toJson(),
        "videos": List<dynamic>.from(videos??[].map((x) => x.toJson())),
      };
}

class BasicOverView {
  BasicOverView({
    this.id,
    this.eventName,
    this.slug,
    this.cover,
    this.about,
    this.isPublished,
    this.country,
    this.city,
    this.address,
    this.startTime,
    this.endTime,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.going,
    this.interested,
    this.meta,
  });

  int? id;
  String? eventName;
  String? slug;
  String? cover;
  String? about;
  int? isPublished;
  String? country;
  String? city;
  String? address;
  DateTime? startTime;
  DateTime? endTime;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Going>? going;
  List<dynamic>? interested;
  Meta? meta;

  factory BasicOverView.fromJson(Map<String, dynamic> json) => BasicOverView(
        id: json["id"],
        eventName: json["event_name"],
        slug: json["slug"],
        cover: json["cover"],
        about: json["about"],
        isPublished: json["is_published"],
        country: json["country"],
        city: json["city"],
        address: json["address"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        going: List<Going>.from(json["going"].map((x) => Going.fromJson(x))),
        interested: List<dynamic>.from(json["interested"].map((x) => x)),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_name": eventName,
        "slug": slug,
        "cover": cover,
        "about": about,
        "is_published": isPublished,
        "country": country,
        "city": city,
        "address": address,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "going": List<dynamic>.from(going??[].map((x) => x.toJson())),
        "interested": List<dynamic>.from(interested??[].map((x) => x)),
        "meta": meta?.toJson(),
      };
}

class Going {
  Going({
    this.id,
    this.eventId,
  });

  int? id;
  int? eventId;

  factory Going.fromJson(Map<String, dynamic> json) => Going(
        id: json["id"],
        eventId: json["event_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}

class IsGoing {
  IsGoing({
    this.id,
    this.userId,
    this.fromUserId,
    this.eventId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.fromUser,
  });

  int? id;
  int? userId;
  dynamic fromUserId;
  int? eventId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic fromUser;

  factory IsGoing.fromJson(Map<String, dynamic> json) => IsGoing(
        id: json["id"],
        userId: json["user_id"],
        fromUserId: json["from_user_id"],
        eventId: json["event_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        fromUser: json["from_user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "from_user_id": fromUserId,
        "event_id": eventId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "from_user": fromUser,
      };
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
