class UserModel {
  UserModel({
    this.user,
    this.notiCount,
    this.msgCount,
  });

  User? user;
  NotiCount? notiCount;
  MsgCount? msgCount;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
        notiCount: NotiCount.fromJson(json["notiCount"]),
        msgCount: MsgCount.fromJson(json["msgCount"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "notiCount": notiCount?.toJson(),
        "msgCount": msgCount?.toJson(),
      };
}

class MsgCount {
  MsgCount({
    this.totalUnseen = 0,
  });

  int totalUnseen;

  factory MsgCount.fromJson(Map<String, dynamic> json) => MsgCount(
        totalUnseen: json["totalUnseen"],
      );

  Map<String, dynamic> toJson() => {
        "totalUnseen": totalUnseen,
      };
}

class NotiCount {
  NotiCount({
    this.totalNoti,
  });

  int? totalNoti;

  factory NotiCount.fromJson(Map<String, dynamic> json) => NotiCount(
        totalNoti: json["totalNoti"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "totalNoti": totalNoti ?? 0,
      };
}

class User {
  User({this.id, this.firstName, this.lastName, this.username, this.email, this.profilePic, this.friendCount, this.defaultFeed="world"});

  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? profilePic;
  int? friendCount;
  String? defaultFeed;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        profilePic: json["profile_pic"],
        friendCount: json["friend_count"],
        defaultFeed: json["default_feed"]??"world",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "profile_pic": profilePic,
        "friend_count": friendCount,
        "default_feed": defaultFeed??"world",
      };
}
