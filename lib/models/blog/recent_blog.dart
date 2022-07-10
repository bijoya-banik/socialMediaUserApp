class RecentModel {
    RecentModel({
        this.meta,
        this.data,
    });

    RecentModelMeta? meta;
    List<Datum>? data;

    factory RecentModel.fromJson(Map<String, dynamic> json) => RecentModel(
        meta: RecentModelMeta.fromJson(json["meta"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": List<dynamic>.from(data??[].map((x) => x.toJson())),
    };

  static void addAll(List<Datum> data) {}
}

class Datum {
    Datum({
        this.id,
        this.userId,
        this.orderId,
        this.activityText,
        this.activityType,
        this.privacy,
        this.views,
        this.data,
        this.createdAt,
        this.updatedAt,
        this.feedUser,
        this.shortDescription,
    });

    int? id;
    int? userId;
    int? orderId;
    String? activityText;
    String? activityType;
    String? privacy;
    int? views;
    Data? data;
    DateTime? createdAt;
    DateTime? updatedAt;
    FeedUser? feedUser;
    String? shortDescription;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        activityText: json["activity_text"],
        activityType: json["activity_type"],
        privacy:json["privacy"],
        views: json["views"],
        data: Data.fromJson(json["data"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        feedUser: FeedUser.fromJson(json["feedUser"]),
        shortDescription: json["shortDescription"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "order_id": orderId,
        "activity_text": activityText,
        "activity_type": activityType,
        "privacy":privacy,
        "views": views,
        "data": data?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "feedUser": feedUser?.toJson(),
        "shortDescription": shortDescription,
    };
}

class Data {
    Data({
        this.comments,
        this.json,
        this.html,
        this.cover,
        this.meta,
    });

    List<dynamic>? comments;
    Json? json;
    String? html;
    String? cover;
    DataMeta? meta;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        comments: List<dynamic>.from(json["comments"].map((x) => x)),
        json: Json.fromJson(json["json"]),
        html: json["html"],
        cover: json["cover"],
        meta: DataMeta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "comments": List<dynamic>.from(comments??[].map((x) => x)),
        "json": json?.toJson(),
        "html": html,
        "cover": cover,
        "meta": meta?.toJson(),
    };
}

class Json {
    Json({
        this.type,
        this.content,
    });

    String? type;
    List<JsonContent>? content;

    factory Json.fromJson(Map<String, dynamic> json) => Json(
        type: json["type"],
        content: List<JsonContent>.from(json["content"].map((x) => JsonContent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type":type,
        "content": List<dynamic>.from(content??[].map((x) => x.toJson())),
    };
}

class JsonContent {
    JsonContent({
        this.type,
        this.content,
    });

    String? type;
    List<ContentContent>? content;

    factory JsonContent.fromJson(Map<String, dynamic> json) => JsonContent(
        type: json["type"],
        content: json["content"] == null ? null : List<ContentContent>.from(json["content"].map((x) => ContentContent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "content": content == null ? null : List<dynamic>.from(content??[].map((x) => x.toJson())),
    };
}

class ContentContent {
    ContentContent({
        this.type,
        this.marks,
        this.text,
    });

    String? type;
    List<Mark>? marks;
    String? text;

    factory ContentContent.fromJson(Map<String, dynamic> json) => ContentContent(
        type: json["type"],
        marks: json["marks"] == null ? null : List<Mark>.from(json["marks"].map((x) => Mark.fromJson(x))),
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "marks": marks == null ? null : List<dynamic>.from(marks??[].map((x) => x.toJson())),
        "text": text,
    };
}

class Mark {
    Mark({
        this.type,
    });

    String? type;

    factory Mark.fromJson(Map<String, dynamic> json) => Mark(
        type:json["type"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
    };
}







class DataMeta {
    DataMeta();

    factory DataMeta.fromJson(Map<String, dynamic> json) => DataMeta(
    );

    Map<String, dynamic> toJson() => {
    };
}

class FeedUser {
    FeedUser({
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
    DataMeta? meta;

    factory FeedUser.fromJson(Map<String, dynamic> json) => FeedUser(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        profilePic: json["profile_pic"],
        meta: DataMeta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username":username,
        "profile_pic": profilePic,
        "meta": meta?.toJson(),
    };
}





class RecentModelMeta {
    RecentModelMeta({
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
    String? nextPageUrl;
    dynamic previousPageUrl;

    factory RecentModelMeta.fromJson(Map<String, dynamic> json) => RecentModelMeta(
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