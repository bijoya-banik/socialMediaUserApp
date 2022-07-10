class ChatModel {
  ChatModel({this.chatLists, this.seen, this.onlineChat = ""});

  List<ChatList>? chatLists;
  int? seen;
  dynamic onlineChat;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      ChatModel(chatLists: List<ChatList>.from(json["chatLists"].map((x) => ChatList.fromJson(x))), seen: json["seen"], onlineChat: "");

  Map<String, dynamic> toJson() => {"chatLists": List<dynamic>.from(chatLists ?? [].map((x) => x.toJson())), "seen": seen, onlineChat: ""};
}

class ChatList {
  ChatList({
    this.id,
    this.userId,
    this.inboxKey,
    this.msg,
    this.files,
    this.replyId,
    this.replyMsg,
    this.replyFiles,
    this.chatMetaData,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.isSeen,
    this.user,
  });

  int? id;
  int? userId;
  String? inboxKey;
  String? msg;
  List<FileElement>? files;
  int? replyId;
  dynamic replyMsg;
  List<FileElement>? replyFiles;
  ChatMetaData? chatMetaData;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isSeen;
  User? user;

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
        id: json["id"],
        userId: json["user_id"],
        inboxKey: json["inbox_key"],
        msg: json["msg"],
        files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        replyId: json["reply_id"],
        replyMsg: json["reply_msg"],
        replyFiles: json["reply_files"] == null ? [] : List<FileElement>.from(json["reply_files"].map((x) => FileElement.fromJson(x))),
        chatMetaData: json["meta_data"] == null ? null : ChatMetaData.fromJson(json["meta_data"]),
        isDeleted: json["is_deleted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isSeen: json["is_seen"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "inbox_key": inboxKey,
        "msg": msg,
        "files": List<dynamic>.from(files ?? [].map((x) => x.toJson())),
        "reply_id": replyId ?? 0,
        "reply_msg": replyMsg ?? "",
        "reply_files": List<dynamic>.from(files ?? [].map((x) => x.toJson())),
        "meta_data": chatMetaData?.toJson(),
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_seen": isSeen ?? 0,
        "user": user?.toJson(),
      };
}

class FileElement {
  FileElement({
    this.fileLoc,
    this.originalName,
    this.extname,
    this.size,
    this.type,
    this.isLocal,
  });

  String? fileLoc;
  String? originalName;
  String? extname;
  int? size;
  String? type;
  bool? isLocal;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        fileLoc: json["fileLoc"],
        originalName: json["originalName"],
        extname: json["extname"],
        size: json["size"],
        type: json["type"],
        isLocal: false,
      );

  Map<String, dynamic> toJson() => {
        "fileLoc": fileLoc,
        "originalName": originalName,
        "extname": extname,
        "size": size,
        "type": type,
      };
}

class ChatMetaData {
  ChatMetaData({
    this.linkMeta,
    this.feedMeta,
  });

  LinkMeta? linkMeta;
  FeedMeta? feedMeta;

  factory ChatMetaData.fromJson(Map<String, dynamic> json) => ChatMetaData(
        linkMeta: json["link_meta"] == null ? null : LinkMeta.fromJson(json["link_meta"]),
        feedMeta: json["feed_meta"] == null ? null : FeedMeta.fromJson(json["feed_meta"]),
      );

  Map<String, dynamic> toJson() => {
        "link_meta": linkMeta?.toJson(),
        "feed_meta": feedMeta?.toJson(),
      };
}

class FeedMeta {
  FeedMeta({
    this.id,
    this.title,
    this.desc,
    this.fileLoc,
    this.type,
    this.linkMeta,
  });

  int? id;
  String? title;
  String? desc;
  String? fileLoc;
  String? type;
  LinkMeta? linkMeta;

  factory FeedMeta.fromJson(Map<String, dynamic> json) => FeedMeta(
        id: json["id"],
        title: json["title"],
        desc: json["desc"],
        fileLoc: json["fileLoc"],
        type: json["type"],
        linkMeta: json["link_meta"] == null ? null : LinkMeta.fromJson(json["link_meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": title,
        "desc": desc ?? "",
        "fileLoc": fileLoc ?? "",
        "type": type ?? "",
        "link_meta": linkMeta?.toJson(),
      };
}

class LinkMeta {
  LinkMeta({
    this.title,
    this.siteName,
    this.url,
    this.image,
    this.description,
  });

  String? title;
  String? siteName;
  String? url;
  dynamic image;
  String? description;

  factory LinkMeta.fromJson(Map<String, dynamic> json) => LinkMeta(
        title: json["title"],
        siteName: json["siteName"],
        url: json["url"],
        image: json["image"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "siteName": siteName,
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
    this.isOnline,
    this.meta,
    userId,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePic;
  String? isOnline;
  Meta? meta;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        profilePic: json["profile_pic"],
        isOnline: json["is_online"],
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "profile_pic": profilePic,
        "is_online": isOnline,
        "meta": meta?.toJson(),
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}
