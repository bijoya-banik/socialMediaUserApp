class CallUserModel {
  CallUserModel({
    this.userName,
    this.firstName,
    this.lastName,
    this.userId,
    this.profilePic
  });

  String? userName;
  String? firstName;
  String? lastName;
  dynamic userId;
  dynamic profilePic;

  factory CallUserModel.fromJson(Map<String, dynamic> json) => CallUserModel(
        userName: json["userName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userId: json["userId"],
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "firstName": firstName,
        "lastName": lastName,
        "userId": userId,
        "profilePic": profilePic,
      };
}
