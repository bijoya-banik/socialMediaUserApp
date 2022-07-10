import 'package:buddyscripts/models/profile/profile_overview_model.dart';

class ProfileVideosModel {
  ProfileVideosModel({
    this.basicOverView,
    this.videos,
  });

  ProfileOverView? basicOverView;
  List<Video>? videos;

  factory ProfileVideosModel.fromJson(Map<String, dynamic> json) => ProfileVideosModel(
        basicOverView: ProfileOverView.fromJson(json["basicOverView"]),
        videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "basicOverView": basicOverView?.toJson(),
        "videos": List<dynamic>.from(videos??[].map((x) => x.toJson())),
      };
}

class Video {
  Video({
    this.fileLoc,
    this.originalName,
    this.extname,
    this.size,
    this.type,
    this.hashName,
    this.id,
  });

  String? fileLoc;
  String? originalName;
  String? extname;
  int? size;
  String? type;
  String? hashName;
  int? id;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        fileLoc: json["fileLoc"],
        originalName: json["originalName"],
        extname: json["extname"],
        size: json["size"],
        type: json["type"],
        hashName: json["hashName"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "fileLoc": fileLoc,
        "originalName": originalName,
        "extname": extname,
        "size": size,
        "type": type,
        "hashName": hashName,
        "id": id,
      };
}
