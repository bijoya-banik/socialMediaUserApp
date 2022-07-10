import 'package:buddyscripts/models/auth/user_model.dart';

class CommentModel {
  CommentModel({
    this.id,
    this.feedId,
    this.userId,
    this.parrentId,
    this.commentTxt,
    this.replyCount = 0,
    this.likeCount = 0,
    this.createdAt,
    this.updatedAt,
    this.replies,
    this.user,
    this.commentlike,
    this.totalLikes,
  });

  int? id;
  int? feedId;
  int? userId;
  dynamic parrentId;
  String? commentTxt;
  int replyCount;
  int likeCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? replies;
  User? user;
  CommentLike? commentlike;
  List<CommentLike>? totalLikes;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        feedId: json["feed_id"],
        userId: json["user_id"],
        parrentId: json["parrent_id"],
        commentTxt: json["comment_txt"],
        replyCount: json["reply_count"] ?? 0,
        likeCount: json["like_count"] ?? 0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        replies: json["replies"] == null ? [] : List<dynamic>.from(json["replies"].map((x) => x)),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        commentlike: json["commentlike"] == null ? null : CommentLike.fromJson(json["commentlike"]),
        totalLikes: List<CommentLike>.from((json["totalLikes"] ?? []).map((x) => CommentLike.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "feed_id": feedId,
        "user_id": userId,
        "parrent_id": parrentId,
        "comment_txt": commentTxt,
        "reply_count": replyCount,
        "like_count": likeCount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "replies": replies == null ? [] : List<dynamic>.from(replies ?? [].map((x) => x)),
        "user": user?.toJson(),
        "commentlike": commentlike?.toJson(),
        "totalLikes": List<dynamic>.from((totalLikes ?? []).map((x) => x.toJson())),
      };
}

class CommentLike {
  CommentLike({
    this.id,
    this.commentId,
    this.reactionType,
    this.userId,
    this.totalLikes = 0,
  });

  int? id;
  int? commentId;
  String? reactionType;
  int? userId;
  int totalLikes;

  factory CommentLike.fromJson(Map<String, dynamic> json) => CommentLike(
        id: json["id"],
        commentId: json["comment_id"],
        reactionType: json["reaction_type"],
        userId: json["user_id"],
        totalLikes: json["total_likes"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment_id": commentId,
        "reaction_type": reactionType,
        "user_id": userId,
        "total_likes": totalLikes,
      };
}
