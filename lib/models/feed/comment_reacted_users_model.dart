class CommentReactedUsersModel {
  CommentReactedUsersModel({
    this.id,
    this.commentId,
    this.reactionType,
    this.userId,
    this.user,
  });

  int? id;
  int? commentId;
  String? reactionType;
  int? userId;
  User? user;

  factory CommentReactedUsersModel.fromJson(Map<String, dynamic> json) => CommentReactedUsersModel(
        id: json["id"],
        commentId: json["comment_id"],
        reactionType: json["reaction_type"],
        userId: json["user_id"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment_id": commentId,
        "reaction_type": reactionType,
        "user_id": userId,
        "user": user == null ? user : user!.toJson(),
      };
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
  dynamic friend;
  Meta? meta;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        profilePic: json["profile_pic"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        friend: json["friend"],
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "profile_pic": profilePic,
        "first_name": firstName,
        "last_name": lastName,
        "friend": friend,
        "meta": meta == null ? meta : meta!.toJson(),
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}
