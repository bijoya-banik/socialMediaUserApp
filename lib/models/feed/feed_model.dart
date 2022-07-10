class FeedModel {
  FeedModel(
      {this.id,
      this.userId,
      this.pageId,
      this.groupId,
      this.eventId,
      this.feedTxt,
      this.activityType,
      this.fileType,
      this.files,
      this.feedPrivacy,
      this.likeCount = 0,
      this.commentCount = 0,
      this.shareCount,
      this.metaData,
      this.shareId,
      this.createdAt,
      this.updatedAt,
      this.likeType,
      this.isFeedEdit,
      this.isAdPost,
      this.campaign,
      this.comments,
      this.name,
      this.url,
      this.pic,
      this.uid,
      this.slug,
      this.share,
      this.group,
      this.user,
      this.event,
      this.like,
      this.page,
      this.savedPosts,
      this.meta,
      this.feedFrom,
      this.isBackground,
      this.bgColor,
      this.feelings,
      this.poll,
      this.pollId});

  int? id;
  int? userId;
  int? pageId;
  int? groupId;
  int? eventId;
  String? feedTxt;
  String? activityType;
  String? fileType;
  List<FileElement>? files;
  FeedPrivacy? feedPrivacy;
  int likeCount;
  int commentCount;
  int? shareCount;
  MetaData? metaData;
  dynamic shareId;
  dynamic createdAt;
  dynamic updatedAt;
  List<LikeType>? likeType;
  bool? isFeedEdit;
  bool? isAdPost;
  Campaign? campaign;
  List<dynamic>? comments;
  String? name;
  String? url;
  String? pic;
  int? uid;
  String? slug;
  FeedModel? share;
  dynamic group;
  User? user;
  dynamic event;
  Like? like;
  dynamic page;
  SavedPosts? savedPosts;
  FeedModelMeta? meta;
  String? feedFrom;
  int? isBackground;
  String? bgColor;
  Feelings? feelings;
  int? pollId;
  Poll? poll;

  factory FeedModel.fromJson(Map<String?, dynamic> json) => FeedModel(
        id: json["id"],
        userId: json["user_id"],
        pageId: json["page_id"],
        groupId: json["groupId"],
        eventId: json["event_id"],
        feedTxt: json["feed_txt"],
        activityType: json["activity_type"],
        fileType: json["file_type"],
        files: json["files"] == null ? [] : List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        feedPrivacy: feedPrivacyValues.map?[json["feed_privacy"]],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        shareCount: json["share_count"],
        metaData: json["meta_data"] == null ? null : MetaData.fromJson(json["meta_data"]),
        shareId: json["share_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        likeType: json["like_type"] == null ? [] : List<LikeType>.from(json["like_type"].map((x) => LikeType.fromJson(x))),
        isFeedEdit: json["is_feed_edit"],
        isAdPost: json["is_ad_post"],
        campaign: json["campaign"] == null ? null : Campaign.fromJson(json["campaign"]),
        comments: json["comments"] == null ? [] : List<dynamic>.from(json["comments"].map((x) => x)),
        name: json["name"],
        url: json["url"],
        pic: json["pic"],
        uid: json["uid"],
        slug: json["slug"],
        share: json["share"] == null ? null : FeedModel.fromJson(json["share"]),
        group: json["group"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        event: json["event"],
        like: json["like"] == null ? null : Like.fromJson(json["like"]),
        page: json["page"],
        savedPosts: json["savedPosts"] == null ? null : SavedPosts.fromJson(json["savedPosts"]),
        meta: FeedModelMeta.fromJson(json["meta"]),
        feedFrom: json["feed_from"],
        isBackground: json["is_background"],
        bgColor: json["bg_color"],
        feelings: json["feelings"] == null ? null : Feelings.fromJson(json["feelings"]),
        pollId: json["poll_id"],
        poll: json["poll"] == null ? null : Poll.fromJson(json["poll"]),
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "page_id": pageId,
        "groupId": groupId,
        "event_id": eventId,
        "feed_txt": feedTxt,
        "activity_type": activityType,
        "file_type": fileType,
        "files": files == null ? [] : List<dynamic>.from((files == null ? [] : files!).map((x) => x.toJson())),
        "feed_privacy": feedPrivacyValues.reverse[feedPrivacy],
        "like_count": likeCount,
        "comment_count": commentCount,
        "share_count": shareCount,
        "meta_data": metaData?.toJson(),
        "share_id": shareId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "like_type": List<dynamic>.from((likeType == null ? [] : likeType!).map((x) => x.toJson())),
        "is_feed_edit": isFeedEdit,
        "is_ad_post": isAdPost,
        "campaign": campaign?.toJson(),
        "comments": List<dynamic>.from((comments ?? []).map((x) => x.toJson())),
        "name": name,
        "url": url,
        "pic": pic,
        "uid": uid,
        "slug": slug,
        "share": share?.toJson(),
        "group": group,
        "user": user?.toJson(),
        "event": event,
        "like": like?.toJson(),
        "page": page,
        "savedPosts": savedPosts?.toJson(),
        "meta": meta?.toJson(),
        "feed_from": feedFrom,
        "is_background": isBackground,
        "bg_color": bgColor,
        "feelings": feelings?.toJson(),
        "poll_id": pollId,
        "poll": poll?.toJson(),
      };
}

class LikeType {
  LikeType({
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
  LikeTypeMeta? meta;

  factory LikeType.fromJson(Map<String, dynamic> json) => LikeType(
        id: json["id"],
        userId: json["user_id"],
        feedId: json["feed_id"],
        reactionType: json["reaction_type"],
        meta: LikeTypeMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "feed_id": feedId,
        "reaction_type": reactionType,
        "meta": meta?.toJson(),
      };
}

class LikeTypeMeta {
  LikeTypeMeta({
    this.totalLikes = 0,
  });

  int totalLikes;

  factory LikeTypeMeta.fromJson(Map<String, dynamic> json) => LikeTypeMeta(
        totalLikes: json["total_likes"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "total_likes": totalLikes,
      };
}

class Page {
  Page({
    this.id,
    this.pageName,
    this.slug,
    this.profilePic,
    this.meta,
  });

  int? id;
  String? pageName;
  String? slug;
  String? profilePic;
  FeedModelMeta? meta;

  factory Page.fromJson(Map<String?, dynamic> json) => Page(
        id: json["id"],
        pageName: json["page_name"],
        slug: json["slug"],
        profilePic: json["profile_pic"],
        meta: FeedModelMeta.fromJson(json["meta"]),
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "page_name": pageName,
        "slug": slug,
        "profile_pic": profilePic,
        "meta": meta?.toJson(),
      };
}

class Campaign {
  Campaign({
    this.id,
    this.name,
    this.title,
    this.destinationUrl,
    this.text,
    this.shortDescription,
    this.spendingAmount,
    this.startDateTime,
    this.endDateTime,
    this.userId,
    this.ageFrom,
    this.ageTo,
    this.feedId,
    this.pageId,
    this.country,
    this.gender,
    this.status,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.meta,
  });

  int? id;
  String? name;
  String? title;
  String? destinationUrl;
  String? text;
  String? shortDescription;
  double? spendingAmount;
  DateTime? startDateTime;
  DateTime? endDateTime;
  int? userId;
  DateTime? ageFrom;
  DateTime? ageTo;
  int? feedId;
  int? pageId;
  String? country;
  String? gender;
  String? status;
  dynamic data;
  dynamic createdAt;
  dynamic updatedAt;
  CampaignMeta? meta;

  factory Campaign.fromJson(Map<String?, dynamic> json) => Campaign(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        destinationUrl: json["destination_url"],
        text: json["text"],
        shortDescription: json["short_description"],
        spendingAmount: json["spending_amount"].toDouble(),
        startDateTime: DateTime.parse(json["start_date_time"]),
        endDateTime: DateTime.parse(json["end_date_time"]),
        userId: json["user_id"],
        ageFrom: json["age_from"] == null ? null : DateTime.parse(json["age_from"]),
        ageTo: json["age_to"] == null ? null : DateTime.parse(json["age_to"]),
        feedId: json["feed_id"],
        pageId: json["page_id"],
        country: json["country"],
        gender: json["gender"],
        status: json["status"],
        data: json["data"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        meta: CampaignMeta.fromJson(json["meta"]),
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "destination_url": destinationUrl,
        "text": text,
        "short_description": shortDescription,
        "spending_amount": spendingAmount,
        "start_date_time": startDateTime == null ? startDateTime : startDateTime!.toIso8601String(),
        "end_date_time": endDateTime == null ? endDateTime : endDateTime!.toIso8601String(),
        "user_id": userId,
        "age_from": ageFrom == null ? ageFrom : ageFrom!.toIso8601String(),
        "age_to": ageTo == null ? null : ageTo!.toIso8601String(),
        "feed_id": feedId,
        "page_id": pageId,
        "country": country,
        "gender": gender,
        "status": status,
        "data": data,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "meta": meta!.toJson(),
      };
}

class CampaignMeta {
  CampaignMeta({
    this.totalAdClickCount,
    this.totalAdImpressionCount,
  });

  int? totalAdClickCount;
  int? totalAdImpressionCount;

  factory CampaignMeta.fromJson(Map<String?, dynamic> json) => CampaignMeta(
        totalAdClickCount: json["totalAdClick_count"],
        totalAdImpressionCount: json["totalAdImpression_count"],
      );

  Map<String?, dynamic> toJson() => {
        "totalAdClick_count": totalAdClickCount,
        "totalAdImpression_count": totalAdImpressionCount,
      };
}

enum FeedPrivacy { PUBLIC, FRIENDS }

final feedPrivacyValues = EnumValues({"FRIENDS": FeedPrivacy.FRIENDS, "PUBLIC": FeedPrivacy.PUBLIC});

class FileElement {
  FileElement({
    this.fileLoc,
    this.originalName,
    this.extname,
    this.size,
    this.type,
  });

  String? fileLoc;
  String? originalName;
  String? extname;
  int? size;
  String? type;

  factory FileElement.fromJson(Map<String?, dynamic> json) => FileElement(
        fileLoc: json["fileLoc"],
        originalName: json["originalName"],
        extname: json["extname"],
        size: json["size"],
        type: json["type"],
      );

  Map<String?, dynamic> toJson() => {
        "fileLoc": fileLoc,
        "originalName": originalName,
        "extname": extname,
        "size": size,
        "type": type,
      };
}

class Like {
  Like({
    this.id,
    this.userId,
    this.feedId,
    this.reactionType,
    this.meta,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? feedId;
  String? reactionType;
  LikeMeta? meta;
  User? user;
  dynamic createdAt;
  dynamic updatedAt;

  factory Like.fromJson(Map<String?, dynamic> json) => Like(
        id: json["id"],
        userId: json["user_id"],
        feedId: json["feed_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        reactionType: json["reaction_type"],
        meta: json["meta"] == null ? null : LikeMeta.fromJson(json["meta"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "feed_id": feedId,
        "reaction_type": reactionType,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "meta": meta == null ? null : meta!.toJson(),
        "user": user == null ? null : user!.toJson(),
      };
}

class LikeMeta {
  LikeMeta();

  factory LikeMeta.fromJson(Map<String, dynamic> json) => LikeMeta();

  Map<String, dynamic> toJson() => {};
}

class FeedModelMeta {
  FeedModelMeta();

  factory FeedModelMeta.fromJson(Map<String?, dynamic> json) => FeedModelMeta();

  Map<String?, dynamic> toJson() => {};
}

class SavedPosts {
  SavedPosts({
    this.id,
    this.userId,
    this.feedId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? feedId;
  dynamic createdAt;
  dynamic updatedAt;

  factory SavedPosts.fromJson(Map<String?, dynamic> json) => SavedPosts(
        id: json["id"],
        userId: json["user_id"],
        feedId: json["feed_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "feed_id": feedId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class MetaData {
  MetaData({
    this.linkMeta,
    this.contentsMetaData,
  });

  LinkMeta? linkMeta;
  dynamic contentsMetaData;

  factory MetaData.fromJson(Map<String?, dynamic> json) => MetaData(
        linkMeta: json["linkMeta"] == null ? null : LinkMeta.fromJson(json["linkMeta"]),
        contentsMetaData: json["contentsMetaData"],
      );

  Map<String?, dynamic> toJson() => {
        "linkMeta": linkMeta == null ? null : linkMeta!.toJson(),
        "contentsMetaData": contentsMetaData,
      };
}

class LinkMeta {
  LinkMeta({
    this.title,
    this.url,
    this.image,
    this.description,
  });

  String? title;
  String? url;
  dynamic image;
  String? description;

  factory LinkMeta.fromJson(Map<String?, dynamic> json) => LinkMeta(
        title: json["title"],
        url: json["url"],
        image: json["image"],
        description: json["description"],
      );

  Map<String?, dynamic> toJson() => {
        "title": title,
        "url": url,
        "image": image,
        "description": description,
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
  FeedModelMeta? meta;

  factory User.fromJson(Map<String?, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        profilePic: json["profile_pic"],
        meta: FeedModelMeta.fromJson(json["meta"]),
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "profile_pic": profilePic,
        "meta": meta?.toJson(),
      };
}

class Feelings {
  Feelings({
    this.text,
    this.icon,
  });

  String? text;
  String? icon;

  factory Feelings.fromJson(Map<String, dynamic> json) => Feelings(
        text: json["text"] ?? "",
        icon: json["icon"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "icon": icon,
      };
}

class Poll {
  Poll({
    this.id,
    this.privacy,
    this.isMultipleSelected,
    this.allowUserAddOption,
    this.voteByAnyOne,
    this.createdAt,
    this.updatedAt,
    this.isVotedOne,
    this.pollOptions,
  });

  int? id;
  dynamic privacy;
  int? isMultipleSelected;
  int? allowUserAddOption;
  String? voteByAnyOne;
  DateTime? createdAt;
  DateTime? updatedAt;
  IsVotedOne? isVotedOne;
  List<PollOption>? pollOptions;

  factory Poll.fromJson(Map<String, dynamic> json) => Poll(
        id: json["id"],
        privacy: json["privacy"],
        isMultipleSelected: json["is_multiple_selected"],
        allowUserAddOption: json["allow_user_add_option"],
        voteByAnyOne: json["vote_by_any_one"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isVotedOne: json["isVotedOne"] == null ? null : IsVotedOne.fromJson(json["isVotedOne"]),
        pollOptions: List<PollOption>.from(json["pollOptions"].map((x) => PollOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "privacy": privacy,
        "is_multiple_selected": isMultipleSelected,
        "allow_user_add_option": allowUserAddOption,
        "vote_by_any_one": voteByAnyOne,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "isVotedOne": isVotedOne?.toJson(),
        "pollOptions": List<dynamic>.from(pollOptions ?? [].map((x) => x.toJson())),
      };
}

class IsVotedOne {
  IsVotedOne({
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
  DateTime? createdAt;
  DateTime? updatedAt;
  IsVotedOneUser? user;

  factory IsVotedOne.fromJson(Map<String, dynamic> json) => IsVotedOne(
        id: json["id"],
        pollId: json["poll_id"],
        optionId: json["option_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : IsVotedOneUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poll_id": pollId,
        "option_id": optionId,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class IsVotedOneUser {
  IsVotedOneUser({
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
  LikeMeta? meta;

  factory IsVotedOneUser.fromJson(Map<String, dynamic> json) => IsVotedOneUser(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        profilePic: json["profile_pic"],
        meta: LikeMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "profile_pic": profilePic,
        "meta": meta?.toJson(),
      };
}

class PollOption {
  PollOption({
    this.id,
    this.pollId,
    this.userId,
    this.totalVote = 0,
    this.text,
    this.createdAt,
    this.updatedAt,
    this.isVoted,
    this.voteOption,
    this.user,
  });

  int? id;
  int? pollId;
  int? userId;
  int totalVote;
  String? text;
  DateTime? createdAt;
  DateTime? updatedAt;
  IsVotedOne? isVoted;
  List<IsVotedOne>? voteOption;
  IsVotedOneUser? user;

  factory PollOption.fromJson(Map<String, dynamic> json) => PollOption(
        id: json["id"],
        pollId: json["poll_id"],
        userId: json["user_id"],
        totalVote: json["total_vote"],
        text: json["text"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isVoted: json["isVoted"] == null ? null : IsVotedOne.fromJson(json["isVoted"]),
        voteOption: List<IsVotedOne>.from(json["voteOption"].map((x) => IsVotedOne.fromJson(x))),
        user: IsVotedOneUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poll_id": pollId,
        "user_id": userId,
        "total_vote": totalVote,
        "text": text,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "isVoted": isVoted?.toJson(),
        "voteOption": List<dynamic>.from(voteOption ?? [].map((x) => x.toJson())),
        "user": user?.toJson(),
      };
}

class EnumValues<T> {
  Map<String?, T>? map;
  Map<T, String?>? reverseMap;

  EnumValues(this.map);

  Map<T, String?> get reverse {
    reverseMap ??= map?.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
