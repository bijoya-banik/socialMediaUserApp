class AllStoryModel {
  AllStoryModel({
    this.data,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
    this.createdAt,
    this.id,
  });

  List<Datum>? data;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePic;
  dynamic createdAt;
  int? id;

  factory AllStoryModel.fromJson(Map<String, dynamic> json) => AllStoryModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        profilePic: json["profile_pic"],
        createdAt: json["created_at"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data ?? [].map((x) => x.toJson())),
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "profile_pic": profilePic,
        "created_at": createdAt,
        "id": id,
      };
}

class Datum {
  Datum({this.id, this.type, this.data, this.createdAt, this.bgColor});

  dynamic id;
  String? type;
  String? data;
  dynamic createdAt;
  dynamic bgColor;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        data: json["data"],
        createdAt: json["created_at"],
        bgColor: json["bg_color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "data": data,
        "created_at": createdAt,
        "bg_color": bgColor,
      };
}
