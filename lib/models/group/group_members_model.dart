class GroupMembersModel {
  GroupMembersModel({
    this.basicOverView,
    this.adminAndModerators,
    this.allMembers,
  });

  BasicOverView? basicOverView;
  List<GroupMember>? adminAndModerators;
  List<GroupMember>? allMembers;

  factory GroupMembersModel.fromJson(Map<String, dynamic> json) => GroupMembersModel(
        basicOverView: BasicOverView.fromJson(json["basicOverView"]),
        adminAndModerators: List<GroupMember>.from(json["adminAndModerators"].map((x) => GroupMember.fromJson(x))),
        allMembers: List<GroupMember>.from(json["allMembers"].map((x) => GroupMember.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "basicOverView": basicOverView?.toJson(),
        "adminAndModerators": List<dynamic>.from(adminAndModerators??[].map((x) => x.toJson())),
        "allMembers": List<dynamic>.from(allMembers??[].map((x) => x.toJson())),
      };
}

class GroupMember {
  GroupMember({
    this.id,
    this.userId,
    this.groupId,
    this.isAdmin,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  int? userId;
  int? groupId;
  String? isAdmin;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
        id: json["id"],
        userId: json["user_id"],
        groupId: json["group_id"],
        isAdmin: json["is_admin"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "group_id": groupId,
        "is_admin": isAdmin,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class User {
  User({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.profilePic,
    this.cover,
    this.password,
    this.appToken,
    this.gender,
    this.isOnline,
    this.status,
    this.msgCount,
    this.friendCount,
    this.birthDate,
    this.about,
    this.phone,
    this.website,
    this.nickName,
    this.currentCity,
    this.homeTown,
    this.country,
    this.workData,
    this.skillData,
    this.educationData,
    this.createdAt,
    this.updatedAt,
    this.meta,
  });

  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  int? userType;
  String? profilePic;
  String? cover;
  String? password;
  String? appToken;
  String? gender;
  String? isOnline;
  String? status;
  int? msgCount;
  int? friendCount;
  DateTime? birthDate;
  String? about;
  String? phone;
  String? website;
  String? nickName;
  String? currentCity;
  String? homeTown;
  String? country;
  String? workData;
  dynamic skillData;
  dynamic educationData;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserMeta? meta;

  factory User.fromJson(Map<String?, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        userType: json["userType"],
        profilePic: json["profile_pic"],
        cover: json["cover"],
        password: json["password"],
        appToken: json["appToken"],
        gender: json["gender"],
        isOnline: json["is_online"],
        status: json["status"],
        msgCount: json["msg_count"],
        friendCount: json["friend_count"],
        birthDate: json["birth_date"] == null ? null : DateTime.parse(json["birth_date"]),
        about: json["about"],
        phone: json["phone"],
        website: json["website"],
        nickName: json["nick_name"],
        currentCity: json["current_city"],
        homeTown: json["home_town"],
        country: json["country"],
        workData: json["work_data"],
        skillData: json["skill_data"],
        educationData: json["education_data"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        meta: UserMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "userType": userType,
        "profile_pic": profilePic,
        "cover": cover,
        "password": password,
        "appToken": appToken ?? "",
        "gender": gender,
        "is_online": isOnline,
        "status": status,
        "msg_count":  msgCount??0,
        "friend_count": friendCount,
        "birth_date":  birthDate?.toIso8601String(),
        "about": about??"",
        "phone": phone ??"",
        "website": website??"",
        "nick_name": nickName ??"",
        "current_city": currentCity ??"",
        "home_town": homeTown??"",
        "country": country??"",
        "work_data": workData ??"",
        "skill_data": skillData,
        "education_data": educationData,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "meta": meta?.toJson(),
      };
}

class UserMeta {
  UserMeta({
    this.isBanned,
  });

  String? isBanned;

  factory UserMeta.fromJson(Map<String, dynamic> json) => UserMeta(
        isBanned: json["is_banned"],
      );

  Map<String, dynamic> toJson() => {
        "is_banned": isBanned,
      };
}

class BasicOverView {
  BasicOverView({
    this.id,
    this.groupName,
    this.slug,
    this.profilePic,
    this.cover,
    this.about,
    this.country,
    this.city,
    this.address,
    this.groupPrivacy,
    this.totalMembers,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
    this.isMember,
    this.meta,
  });

  int? id;
  String? groupName;
  String? slug;
  String? profilePic;
  String? cover;
  String? about;
  dynamic country;
  dynamic city;
  dynamic address;
  String? groupPrivacy;
  int? totalMembers;
  String? categoryName;
  DateTime? createdAt;
  DateTime? updatedAt;
  GroupMember? isMember;
  BasicOverViewMeta? meta;

  factory BasicOverView.fromJson(Map<String, dynamic> json) => BasicOverView(
        id: json["id"],
        groupName: json["group_name"],
        slug: json["slug"],
        profilePic: json["profile_pic"],
        cover: json["cover"],
        about: json["about"],
        country: json["country"],
        city: json["city"],
        address: json["address"],
        groupPrivacy: json["group_privacy"],
        totalMembers: json["total_members"],
        categoryName: json["category_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isMember: json["is_member"]==null?null:GroupMember.fromJson(json["is_member"]),
        meta: BasicOverViewMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "slug": slug,
        "profile_pic": profilePic,
        "cover": cover,
        "about": about,
        "country": country,
        "city": city,
        "address": address,
        "group_privacy": groupPrivacy,
        "total_members": totalMembers,
        "category_name": categoryName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_member": isMember?.toJson(),
        "meta": meta?.toJson(),
      };
}

class BasicOverViewMeta {
  BasicOverViewMeta();

  factory BasicOverViewMeta.fromJson(Map<String, dynamic> json) => BasicOverViewMeta();

  Map<String, dynamic> toJson() => {};
}
