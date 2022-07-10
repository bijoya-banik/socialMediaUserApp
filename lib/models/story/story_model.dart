class StoryModel {
  StoryModel({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.type,
    this.data,
    this.bgColor,
    this.createdAt,
  });

  int? id;
  String? firstName;
  String? lastName;
  dynamic profilePic;
  String? type;
  dynamic data;
  dynamic bgColor;
  dynamic createdAt;

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePic: json["profile_pic"],
        type: json["type"],
        data: json["data"],
        bgColor:json["bg_color"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "profile_pic": profilePic,
        "type": type,
        "data": data,
        "bg_color": data,
        "created_at": createdAt,
      };
}
