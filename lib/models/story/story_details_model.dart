class StoryDetailsModel {
  StoryDetailsModel({
    this.data,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.createdAt,
    this.id,
  });

  List<Datum>? data;
  String? firstName;
  String? lastName;
  String? profilePic;
  dynamic createdAt;
  dynamic id;

  factory StoryDetailsModel.fromJson(Map<String, dynamic> json) => StoryDetailsModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePic: json["profile_pic"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data??[].map((x) => x.toJson())),
        "first_name": firstName,
        "last_name": lastName,
        "profile_pic": profilePic,
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}

class Datum {
  Datum({
    this.type,
    this.data,
    this.createdAt,
  });

  dynamic type;
  String? data;
  dynamic createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: json["type"],
        data: json["data"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data,
        "created_at": createdAt,
      };
}
