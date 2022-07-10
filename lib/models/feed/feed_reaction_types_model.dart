class FeedReactionTypesModel {
  FeedReactionTypesModel({
    this.id,
    this.userId,
    this.feedId,
    this.reactionType,
    this.meta,
  });

  int? id;
  int? userId;
  int? feedId;
  String? reactionType;
  Meta? meta;

  factory FeedReactionTypesModel.fromJson(Map<String, dynamic> json) => FeedReactionTypesModel(
        id: json["id"],
        userId: json["user_id"],
        feedId: json["feed_id"],
        reactionType: json["reaction_type"],
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "feed_id": feedId,
        "reaction_type": reactionType,
        "meta": meta == null ? meta : meta!.toJson(),
      };
}

class Meta {
  Meta({
    this.totalLikes,
  });

  int? totalLikes;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalLikes: json["total_likes"],
      );

  Map<String, dynamic> toJson() => {
        "total_likes": totalLikes,
      };
}
