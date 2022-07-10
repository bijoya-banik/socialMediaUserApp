
class FriendRequestsModel {
    FriendRequestsModel({
        this.meta,
        this.data,
    });

    FriendRequestsModelMeta? meta;
    List<Datum>? data;

    factory FriendRequestsModel.fromJson(Map<String, dynamic> json) => FriendRequestsModel(
        meta: FriendRequestsModelMeta.fromJson(json["meta"]),
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
        this.userId,
        this.friendId,
        this.status,
        this.friend,
    });

    int? id;
    int? userId;
    int? friendId;
    String? status;
    Friend? friend;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        friendId: json["friend_id"],
        status: json["status"],
        friend: Friend.fromJson(json["friend"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "friend_id": friendId,
        "status": status,
        "friend": friend?.toJson(),
    };
}

class Friend {
    Friend({
        this.id,
        this.firstName,
        this.lastName,
        this.profilePic,
        this.username,
        this.meta,
    });

    int? id;
    String? firstName;
    String? lastName;
    String? profilePic;
    String? username;
    FriendMeta? meta;

    factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePic: json["profile_pic"],
        username: json["username"],
        meta: FriendMeta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "profile_pic": profilePic,
        "username": username,
        "meta": meta?.toJson(),
    };
}

class FriendMeta {
    FriendMeta();

    factory FriendMeta.fromJson(Map<String, dynamic> json) => FriendMeta(
    );

    Map<String, dynamic> toJson() => {
    };
}

class FriendRequestsModelMeta {
    FriendRequestsModelMeta({
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

    factory FriendRequestsModelMeta.fromJson(Map<String, dynamic> json) => FriendRequestsModelMeta(
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
