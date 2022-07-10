class PeopleModel {
  PeopleModel({
    this.id,
    this.userId,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.profilePic,
    this.cover,
    this.password,
    this.appToken,
    this.gender,
    this.isOnline,
    this.status,
    this.isBanned,
    this.msgCount,
    this.friendCount,
    this.birthDate,
    this.about,
    this.phone,
    this.website,
    this.nickName,
    this.currentCity,
    this.homeTown,
    this.country,
    this.workData,
    this.skillData,
    this.educationData,
    this.defaultFeed,
    this.createdAt,
    this.updatedAt,
    this.friend,
    this.meta,
  });

  int? id;
  int? userId;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  int? userType;
  String? profilePic;
  String? cover;
  String? password;
  String? appToken;
  String? gender;
  String? isOnline;
  String? status;
  String? isBanned;
  int? msgCount;
  int? friendCount;
  DateTime? birthDate;
  String? about;
  String? phone;
  String? website;
  String? nickName;
  String? currentCity;
  String? homeTown;
  String? country;
  String? workData;
  dynamic skillData;
  dynamic educationData;
  String? defaultFeed;
  DateTime? createdAt;
  DateTime? updatedAt;
  Friend? friend;
  Meta? meta;

  factory PeopleModel.fromJson(Map<String, dynamic> json) => PeopleModel(
        id: json["id"],
        userId: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        userType: json["userType"],
        profilePic: json["profile_pic"],
        cover: json["cover"],
        password: json["password"],
        appToken: json["appToken"],
        gender: json["gender"],
        isOnline: json["is_online"],
        status: json["status"],
        isBanned:json["is_banned"],
        msgCount: json["msg_count"],
        friendCount: json["friend_count"],
        birthDate: json["birth_date"] == null ? null : DateTime.parse(json["birth_date"]),
        about:  json["about"],
        phone:  json["phone"],
        website: json["website"],
        nickName: json["nick_name"],
        currentCity: json["current_city"],
        homeTown: json["home_town"],
        country:  json["country"],
        workData: json["work_data"],
        skillData: json["skill_data"],
        educationData: json["education_data"],
        defaultFeed: json["default_feed"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        friend: json["friend"] == null ? null : Friend.fromJson(json["friend"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": id,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "userType": userType,
        "profile_pic": profilePic,
        "cover": cover,
        "password": password,
        "appToken": appToken,
        "gender": gender,
        "is_online": isOnline,
        "status": status,
        "is_banned":isBanned,
        "msg_count": msgCount,
        "friend_count": friendCount,
        "birth_date": birthDate?.toIso8601String(),
        "about":  about,
        "phone": phone,
        "website":  website,
        "nick_name": nickName,
        "current_city": currentCity,
        "home_town": homeTown,
        "country": country,
        "work_data":workData,
        "skill_data": skillData,
        "education_data": educationData,
        "default_feed":defaultFeed,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "friend": friend?.toJson(),
        "meta": meta?.toJson(),
      };
}

// enum DefaultFeed { WORLD }

// final defaultFeedValues = EnumValues({"world": DefaultFeed.WORLD});

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
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}

// enum Gender { MALE, FEMALE }

// final genderValues = EnumValues({"Female": Gender.FEMALE, "Male": Gender.MALE});

// enum IsBanned { NO, UNVERIFIED }

// final isBannedValues = EnumValues({"no": IsBanned.NO, "unverified": IsBanned.UNVERIFIED});

// enum IsOnline { OFFLINE, ONLINE }

// final isOnlineValues = EnumValues({"offline": IsOnline.OFFLINE, "online": IsOnline.ONLINE});



// enum Status { ACTIVE }

// final statusValues = EnumValues({"active": Status.ACTIVE});

// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
//}
