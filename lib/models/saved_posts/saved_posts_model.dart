import 'package:buddyscripts/models/feed/feed_model.dart';

class SavedPostsModel {
    SavedPostsModel({
        this.feedData,
    });

    FeedData? feedData;

    factory SavedPostsModel.fromJson(Map<String, dynamic> json) => SavedPostsModel(
        feedData: FeedData.fromJson(json["feedData"]),
    );

    Map<String, dynamic> toJson() => {
        "feedData": feedData?.toJson(),
    };
}

class FeedData {
    FeedData({
        this.meta,
        this.data,
    });

    FeedDataMeta? meta;
    List<FeedModel>? data;

    factory FeedData.fromJson(Map<String, dynamic> json) => FeedData(
        meta: FeedDataMeta.fromJson(json["meta"]),
        data: List<FeedModel>.from(json["data"].map((x) => FeedModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": List<FeedModel>.from(data??[].map((x) => x.toJson())),
    };
}

class FeedDataMeta {
    FeedDataMeta({
        this.total,
        this.perPage,
        this.currentPage,
        this.lastPage,
        this.firstPage,
        this.firstPageUrl,
        this.lastPageUrl,
        this.nextPageUrl,
        this.previousPageUrl,
    });

    int? total;
    int? perPage;
    dynamic currentPage;
    int? lastPage;
    int? firstPage;
    String? firstPageUrl;
    String? lastPageUrl;
    dynamic nextPageUrl;
    dynamic previousPageUrl;

    factory FeedDataMeta.fromJson(Map<String, dynamic> json) => FeedDataMeta(
        total: json["total"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        firstPage: json["first_page"],
        firstPageUrl: json["first_page_url"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        previousPageUrl: json["previous_page_url"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
        "current_page": currentPage,
        "last_page": lastPage,
        "first_page": firstPage,
        "first_page_url": firstPageUrl,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "previous_page_url": previousPageUrl,
    };
}
