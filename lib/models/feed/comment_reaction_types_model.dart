class CommentReactionTypesModel {
  CommentReactionTypesModel({
    this.id,
    this.userId,
    this.commentId,
    this.reactionType,
    this.totalLikes,
  });

  int? id;
  int? userId;
  int? commentId;
  String? reactionType;
  int? totalLikes;

  factory CommentReactionTypesModel.fromJson(Map<String, dynamic> json) => CommentReactionTypesModel(
        id: json["id"],
        userId: json["user_id"],
        commentId: json["comment_id"],
        reactionType: json["reaction_type"],
        totalLikes: json["total_likes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "comment_id": commentId,
        "reaction_type": reactionType,
        "total_likes": totalLikes,
      };
}
