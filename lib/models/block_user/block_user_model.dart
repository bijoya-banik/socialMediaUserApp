class BlockUserModel {
    BlockUserModel({
        this.meta,
        this.data,
    });

    BlockUserModelMeta? meta;
    List<Datum>? data;

    factory BlockUserModel.fromJson(Map<String, dynamic> json) => BlockUserModel(
        meta: BlockUserModelMeta.fromJson(json["meta"]),
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
        this.username,
        this.firstName,
        this.lastName,
        this.profilePic,
        this.meta,
    });

    int? id;
    String? username;
    String? firstName;
    String? lastName;
    String? profilePic;
    DatumMeta? meta;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePic: json["profile_pic"],
        meta: DatumMeta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "profile_pic": profilePic,
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

class BlockUserModelMeta {
    BlockUserModelMeta({
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

    factory BlockUserModelMeta.fromJson(Map<String, dynamic> json) => BlockUserModelMeta(
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
