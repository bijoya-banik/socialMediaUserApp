
class GroupPendingMemberModel {
    GroupPendingMemberModel({
        this.id,
        this.groupId,
        this.userId,
        this.adminId,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    int? id;
    int? groupId;
    int? userId;
    int? adminId;
    DateTime? createdAt;
    DateTime? updatedAt;
    User? user;

    factory GroupPendingMemberModel.fromJson(Map<String, dynamic> json) => GroupPendingMemberModel(
        id: json["id"],
        groupId: json["group_id"],
        userId: json["user_id"],
        adminId: json["admin_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "user_id": userId,
        "admin_id": adminId,
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
        this.profilePic,
        this.username,
        this.meta,
    });

    int? id;
    String? firstName;
    String? lastName;
    String? profilePic;
    String? username;
    Meta? meta;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePic: json["profile_pic"],
        username: json["username"],
        meta: Meta.fromJson(json["meta"]),
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

class Meta {
    Meta();

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    );

    Map<String, dynamic> toJson() => {
    };
}
