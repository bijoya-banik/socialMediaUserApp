class FeedReactedUsersModel {
  FeedReactedUsersModel({
    this.id,
    this.userId,
    this.feedId,
    this.reactionType,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.meta,
  });

  int? id;
  int? userId;
  int? feedId;
  String? reactionType;
  dynamic createdAt;
  dynamic updatedAt;
  User? user;
  Meta? meta;

  factory FeedReactedUsersModel.fromJson(Map<String, dynamic> json) => FeedReactedUsersModel(
        id: json["id"],
        userId: json["user_id"],
        feedId: json["feed_id"],
        reactionType: json["reaction_type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "feed_id": feedId,
        "reaction_type": reactionType,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user == null ? user : user!.toJson(),
        "meta": meta == null ? meta : meta!.toJson(),
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}

class User {
  User({
    this.id,
    this.username,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.friend,
    this.meta,
  });

  int? id;
  String? username;
  String? profilePic;
  String? firstName;
  String? lastName;
  Friend? friend;
  Meta? meta;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        profilePic: json["profile_pic"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        friend: json["friend"] == null ? null : Friend.fromJson(json["friend"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "profile_pic": profilePic,
        "first_name": firstName,
        "last_name": lastName,
        "friend": friend == null ? null : friend!.toJson(),
        "meta": meta == null ? meta : meta!.toJson(),
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
