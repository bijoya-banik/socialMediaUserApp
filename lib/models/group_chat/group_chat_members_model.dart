
class GroupChatMemberModel {
    GroupChatMemberModel({
        this.id,
        this.inboxId,
        this.userId,
        this.ignoreMsg,
        this.muteNoti,
        this.isLeft,
        this.isSeen,
        this.role,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    int? id;
    int? inboxId;
    int? userId;
    int? ignoreMsg;
    int? muteNoti;
    int? isLeft;
    int? isSeen;
    String? role;
    DateTime? createdAt;
    DateTime? updatedAt;
    User? user;

    factory GroupChatMemberModel.fromJson(Map<String, dynamic> json) => GroupChatMemberModel(
        id: json["id"],
        inboxId: json["inbox_id"],
        userId: json["user_id"],
        ignoreMsg: json["ignore_msg"],
        muteNoti: json["mute_noti"],
        isLeft: json["is_left"],
        isSeen: json["is_seen"],
        role: json["role"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "inbox_id": inboxId,
        "user_id": userId,
        "ignore_msg": ignoreMsg,
        "mute_noti": muteNoti,
        "is_left": isLeft,
        "is_seen": isSeen,
        "role": role,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
    };
}

class User {
    User({
        this.id,
        this.firstName,
        this.lastName,
        this.username,
        this.profilePic,
        this.isOnline,
        this.meta,
    });

    int? id;
    String? firstName;
    String? lastName;
    String? username;
    String? profilePic;
    String? isOnline;
    Meta? meta;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        profilePic: json["profile_pic"],
        isOnline: json["is_online"],
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "profile_pic": profilePic,
        "is_online": isOnline,
        "meta": meta?.toJson(),
    };
}

class Meta {
    Meta();

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    );

    Map<String, dynamic> toJson() => {
    };
}
