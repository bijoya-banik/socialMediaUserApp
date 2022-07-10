import 'package:buddyscripts/models/profile/profile_overview_model.dart';

class ProfilePhotosModel {
  ProfilePhotosModel({
    this.basicOverView,
    this.photos,
  });

  ProfileOverView? basicOverView;
  List<Photo>? photos;

  factory ProfilePhotosModel.fromJson(Map<String, dynamic> json) => ProfilePhotosModel(
        basicOverView: ProfileOverView.fromJson(json["basicOverView"]),
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "basicOverView": basicOverView?.toJson(),
        "photos": List<dynamic>.from(photos??[].map((x) => x.toJson())),
      };
}

class Photo {
  Photo({
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

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
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
