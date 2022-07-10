class EventsModel {
  EventsModel({
    this.meta,
    this.data,
  });

  EventsModelMeta? meta;
  List<EventDatum>? data;

  factory EventsModel.fromJson(Map<String, dynamic> json) => EventsModel(
        meta: EventsModelMeta.fromJson(json["meta"]),
        data: List<EventDatum>.from(json["data"].map((x) => EventDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": List<dynamic>.from(data??[].map((x) => x.toJson())),
      };
}

class EventDatum {
  EventDatum({
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
    this.meta,
  });

  int? id;
  String? eventName;
  String? slug;
  String? cover;
  String? about;
  int? isPublished;
  dynamic country;
  dynamic city;
  String? address;
  DateTime? startTime;
  DateTime? endTime;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Going>? going;
  EventDatumMeta? meta;

  factory EventDatum.fromJson(Map<String, dynamic> json) => EventDatum(
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
        going: json["going"] == null ? [] : List<Going>.from(json["going"].map((x) => Going.fromJson(x))),
        meta: EventDatumMeta.fromJson(json["meta"]),
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
        "going": going == null ? [] : List<dynamic>.from(going??[].map((x) => x.toJson())),
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

class EventDatumMeta {
  EventDatumMeta();

  factory EventDatumMeta.fromJson(Map<String, dynamic> json) => EventDatumMeta();

  Map<String, dynamic> toJson() => {};
}

class EventsModelMeta {
  EventsModelMeta({
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

  factory EventsModelMeta.fromJson(Map<String, dynamic> json) => EventsModelMeta(
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
