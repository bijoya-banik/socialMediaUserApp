
class FriendModel {
    FriendModel({
        this.meta,
        this.data,
    });

    FriendModelMeta? meta;
    List<Datum>? data;

    factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
        meta: FriendModelMeta.fromJson(json["meta"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": List<dynamic>.from(data??[].map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.isOnline,
        this.firstName,
        this.lastName,
        this.profilePic,
        this.cover,
        this.username,
        this.meta,
    });

    int? id;
    String? isOnline;
    String? firstName;
    String? lastName;
    String? profilePic;
    String? cover;
    String? username;
    DatumMeta? meta;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        isOnline: json["is_online"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePic: json["profile_pic"],
        cover: json["cover"],
        username: json["username"],
        meta: DatumMeta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "is_online": isOnline,
        "first_name": firstName,
        "last_name": lastName,
        "profile_pic": profilePic,
        "cover": cover,
        "username": username,
        "meta": meta?.toJson(),
    };
}

class DatumMeta {
    DatumMeta();

    factory DatumMeta.fromJson(Map<String, dynamic> json) => DatumMeta(
    );

    Map<String, dynamic> toJson() => {
    };
}

class FriendModelMeta {
    FriendModelMeta({
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

    factory FriendModelMeta.fromJson(Map<String, dynamic> json) => FriendModelMeta(
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
