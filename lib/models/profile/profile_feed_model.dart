import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';

class ProfileFeedModel {
  ProfileFeedModel({
    this.basicOverView,
    this.feedData,
  });

  ProfileOverView? basicOverView;
  List<FeedModel>? feedData;

  factory ProfileFeedModel.fromJson(Map<String, dynamic> json) => ProfileFeedModel(
        basicOverView: ProfileOverView.fromJson(json["basicOverView"]),
        feedData: List<FeedModel>.from(json["feedData"].map((x) => FeedModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "basicOverView": basicOverView?.toJson(),
        "feedData": List<FeedModel>.from(feedData??[].map((x) => x.toJson())),
      };
}
