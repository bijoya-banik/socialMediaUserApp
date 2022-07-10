
class LinkPreviewModel {
    LinkPreviewModel({
        this.success,
        this.metaData,
    });

    bool? success;
    MetaData? metaData;

    factory LinkPreviewModel.fromJson(Map<String, dynamic> json) => LinkPreviewModel(
        success: json["success"],
        metaData: MetaData.fromJson(json["metaData"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "metaData": metaData?.toJson(),
    };
}

class MetaData {
    MetaData({
        this.url,
        this.title,
        this.siteName,
        this.description,
        this.mediaType,
        this.contentType,
        this.images,
        this.videos,
        this.favicons,
    });

    String? url;
    String? title;
    String? siteName;
    String? description;
    String? mediaType;
    String? contentType;
    List<String>? images;
    List<dynamic>? videos;
    List<String>? favicons;

    factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        url: json["url"],
        title: json["title"],
        siteName: json["siteName"],
        description: json["description"],
        mediaType: json["mediaType"],
        contentType: json["contentType"],
        images: List<String>.from(json["images"].map((x) => x)),
        videos: List<dynamic>.from(json["videos"].map((x) => x)),
        favicons: List<String>.from(json["favicons"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "siteName": siteName,
        "description": description,
        "mediaType": mediaType,
        "contentType": contentType,
        "images": List<dynamic>.from(images??[].map((x) => x)),
        "videos": List<dynamic>.from(videos??[].map((x) => x)),
        "favicons": List<dynamic>.from(favicons??[].map((x) => x)),
    };
}
