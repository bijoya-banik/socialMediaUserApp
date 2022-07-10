class PollOptionVotersModel {
  PollOptionVotersModel({
    this.id,
    this.pollId,
    this.optionId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  int? pollId;
  int? optionId;
  int? userId;
  dynamic createdAt;
  dynamic updatedAt;
  User? user;

  factory PollOptionVotersModel.fromJson(Map<String, dynamic> json) => PollOptionVotersModel(
        id: json["id"],
        pollId: json["poll_id"],
        optionId: json["option_id"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poll_id": pollId,
        "option_id": optionId,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user == null ? user : user!.toJson(),
      };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
    this.meta,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePic;
  Meta? meta;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        profilePic: json["profile_pic"],
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "profile_pic": profilePic,
        "meta": meta == null ? meta : meta!.toJson(),
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}
