
class GroupInviteMemberModel {
    GroupInviteMemberModel({
        this.id,
        this.isOnline,
        this.firstName,
        this.lastName,
        this.profilePic,
        this.username,
        this.status,
        this.meta,
    });

    int? id;
    String? isOnline;
    String? firstName;
    String? lastName;
    String? profilePic;
    String? username;
    String? status;
    Meta? meta;

    factory GroupInviteMemberModel.fromJson(Map<String, dynamic> json) => GroupInviteMemberModel(
        id: json["id"],
        isOnline: json["is_online"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePic: json["profile_pic"],
        username: json["username"],
        status: json["status"],
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "is_online": isOnline,
        "first_name": firstName,
        "last_name": lastName,
        "profile_pic": profilePic,
        "username": username,
        "status": status,
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
