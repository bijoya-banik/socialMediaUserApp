
class MemberSearchForCreateGroupChatModel {
    MemberSearchForCreateGroupChatModel({
        this.id,
        this.username,
        this.firstName,
        this.lastName,
        this.email,
        this.userType,
        this.adminStatus,
        this.memberExpiredAt,
        this.profilePic,
        this.cover,
        this.password,
        this.appToken,
        this.gender,
        this.isOnline,
        this.darkMode,
        this.ignoredSugegssion,
        this.status,
        this.isBanned,
        this.msgCount,
        this.friendCount,
        this.birthDate,
        this.about,
        this.phone,
        this.website,
        this.workplace,
        this.nickName,
        this.currentCity,
        this.homeTown,
        this.country,
        this.workData,
        this.skillData,
        this.educationData,
        this.defaultFeed,
        this.facebookHandle,
        this.createdAt,
        this.updatedAt,
        this.friend,
        this.isfriend,
        this.meta,
    });

    int? id;
    String? username;
    String? firstName;
    String? lastName;
    String? email;
    int? userType;
    String? adminStatus;
    DateTime? memberExpiredAt;
    String? profilePic;
    String? cover;
    String? password;
    dynamic appToken;
    String? gender;
    String? isOnline;
    int? darkMode;
    int? ignoredSugegssion;
    String? status;
    String? isBanned;
    int? msgCount;
    int? friendCount;
    DateTime? birthDate;
    dynamic about;
    dynamic phone;
    dynamic website;
    dynamic workplace;
    dynamic nickName;
    String? currentCity;
    dynamic homeTown;
    String? country;
    String? workData;
    dynamic skillData;
    dynamic educationData;
    String? defaultFeed;
    String? facebookHandle;
    DateTime? createdAt;
    DateTime? updatedAt;
    Friend? friend;
    List<Friend>? isfriend;
    Meta? meta;

    factory MemberSearchForCreateGroupChatModel.fromJson(Map<String, dynamic> json) => MemberSearchForCreateGroupChatModel(
        id: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        userType: json["userType"],
        adminStatus: json["admin_status"],
        memberExpiredAt: json["member_expired_at"] == null ? null : DateTime.parse(json["member_expired_at"]),
        profilePic: json["profile_pic"],
        cover: json["cover"],
        password: json["password"],
        appToken: json["appToken"],
        gender: json["gender"],
        isOnline: json["is_online"],
        darkMode: json["dark_mode"],
        ignoredSugegssion: json["ignored_sugegssion"],
        status:json["status"],
        isBanned:json["is_banned"],
        msgCount: json["msg_count"],
        friendCount: json["friend_count"],
        birthDate: json["birth_date"] == null ? null : DateTime.parse(json["birth_date"]),
        about: json["about"],
        phone: json["phone"],
        website: json["website"],
        workplace: json["workplace"],
        nickName: json["nick_name"],
        currentCity: json["current_city"],
        homeTown: json["home_town"],
        country: json["country"],
        workData: json["work_data"],
        skillData: json["skill_data"],
        educationData: json["education_data"],
        defaultFeed:json["default_feed"],
        facebookHandle: json["facebookHandle"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        friend: json["friend"] == null ? null : Friend.fromJson(json["friend"]),
        isfriend: List<Friend>.from(json["isfriend"].map((x) => Friend.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "userType": userType,
        "admin_status":  adminStatus,
        "member_expired_at": memberExpiredAt?.toIso8601String(),
        "profile_pic": profilePic,
        "cover": cover,
        "password": password,
        "appToken": appToken,
        "gender":gender,
        "is_online":isOnline,
        "dark_mode": darkMode,
        "ignored_sugegssion": ignoredSugegssion,
        "status":status,
        "is_banned":isBanned,
        "msg_count": msgCount,
        "friend_count": friendCount,
        "birth_date":birthDate?.toIso8601String(),
        "about": about,
        "phone": phone,
        "website": website,
        "workplace": workplace,
        "nick_name": nickName,
        "current_city": currentCity,
        "home_town": homeTown,
        "country": country,
        "work_data":  workData,
        "skill_data": skillData,
        "education_data": educationData,
        "default_feed": defaultFeed,
        "facebookHandle":  facebookHandle,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "friend": friend?.toJson(),
        "isfriend": List<dynamic>.from(isfriend??[].map((x) => x.toJson())),
        "meta": meta?.toJson(),
    };
}


class Friend {
    Friend({
        this.id,
        this.userId,
        this.friendId,
        this.status,
    });

    int? id;
    int? userId;
    int? friendId;
    String? status;

    factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json["id"],
        userId: json["user_id"],
        friendId: json["friend_id"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "friend_id": friendId,
        "status": status,
    };
}



class Meta {
    Meta({
        this.lastActive,
    });

    int? lastActive;

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        lastActive: json["last_active"],
    );

    Map<String, dynamic> toJson() => {
        "last_active": lastActive,
    };
}





