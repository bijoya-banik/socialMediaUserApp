class ProfileOverviewModel {
  ProfileOverviewModel({
    this.basicOverView,
  });

  ProfileOverView? basicOverView;

  factory ProfileOverviewModel.fromJson(Map<String, dynamic> json) =>
      ProfileOverviewModel(
        basicOverView: ProfileOverView.fromJson(json["basicOverView"]),
      );

  Map<String, dynamic> toJson() => {
        "basicOverView": basicOverView?.toJson(),
      };
}

class ProfileOverView {
  ProfileOverView({
    this.id,
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
    this.createdAt,
    this.updatedAt,
    this.friend,
    this.meta,
  });

  int? id;
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
  int? msgCount;
  int? friendCount;
  dynamic birthDate;
  dynamic about;
  dynamic phone;
  dynamic website;
  dynamic workplace;
  dynamic nickName;
  String? currentCity;
  String? homeTown;
  String? country;
  List<WorkDatum>? workData;
  List<dynamic>? skillData;
  List<dynamic>? educationData;
  DateTime? createdAt;
  DateTime? updatedAt;
  Friend? friend;
  Meta? meta;

  factory ProfileOverView.fromJson(Map<String, dynamic> json) =>
      ProfileOverView(
        id: json["id"],
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
        msgCount: json["msg_count"],
        friendCount: json["friend_count"],
        birthDate: json["birth_date"],
        about: json["about"],
        phone: json["phone"],
        website: json["website"],
        workplace: json["workplace"],
        nickName: json["nick_name"],
        currentCity: json["current_city"],
        homeTown: json["home_town"],
        country: json["country"],
        workData: json["work_data"] == null
            ? []
            : List<WorkDatum>.from(
                json["work_data"].map((x) => WorkDatum.fromJson(x))),
        skillData: json["skill_data"] == null
            ? []
            : List<dynamic>.from(json["skill_data"].map((x) => x)),
        educationData: json["education_data"] == null
            ? []
            : List<dynamic>.from(json["education_data"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        friend: json["friend"] == null ? null : Friend.fromJson(json["friend"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "msg_count": msgCount,
        "friend_count": friendCount,
        "birth_date": birthDate,
        "about": about,
        "phone": phone,
        "website": website,
        "workplace": workplace,
        "nick_name": nickName,
        "current_city": currentCity,
        "home_town": homeTown,
        "country": country,
        "work_data":  List<dynamic>.from(workData??[].map((x) => x.toJson())),
        "skill_data":  List<dynamic>.from(skillData??[].map((x) => x)),
        "education_data":List<dynamic>.from(educationData??[].map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "friend": friend?.toJson(),
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
    this.isBanned,
  });

  String? isBanned;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        isBanned: json["is_banned"],
      );

  Map<String, dynamic> toJson() => {
        "is_banned": isBanned,
      };
}

class WorkDatum {
  WorkDatum({
    this.comapnyName,
    this.position,
    this.startingDate,
    this.endingDate,
    this.isCurrentlyWorking,
  });

  String? comapnyName;
  String? position;
  dynamic startingDate;
  dynamic endingDate;
  bool? isCurrentlyWorking;

  factory WorkDatum.fromJson(Map<String, dynamic> json) => WorkDatum(
        comapnyName: json["comapny_name"],
        position: json["position"],
        startingDate: json["starting_date"],
        endingDate: json["ending_date"],
        isCurrentlyWorking: json["is_currently_working"],
      );

  Map<String, dynamic> toJson() => {
        "comapny_name": comapnyName,
        "position": position,
        "starting_date": startingDate,
        "ending_date": endingDate,
        "is_currently_working": isCurrentlyWorking,
      };
}
