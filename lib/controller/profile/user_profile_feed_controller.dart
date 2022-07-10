import 'package:buddyscripts/controller/pagination/profile/profile_feed_tab.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_feed_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/profile/profile_feed_model.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileFeedProvider = StateNotifierProvider<UserProfileFeedController, UserProfileFeedState>(
  (ref) => UserProfileFeedController(ref: ref),
);

class UserProfileFeedController extends StateNotifier<UserProfileFeedState> {
  final Ref? ref;
  UserProfileFeedController({this.ref}) : super(const UserProfileFeedInitialState());

  ProfileFeedModel? userProfileFeedList;

  updateSuccessState(List<FeedModel> feedList) {
    userProfileFeedList?.feedData = feedList;
    state = UserProfileFeedSuccessState(userProfileFeedList ?? ProfileFeedModel());
  }

  updateOverviewSuccessState(ProfileOverView profileOverview) {
    userProfileFeedList!.basicOverView = profileOverview;
    state = UserProfileFeedSuccessState(userProfileFeedList!);
  }

  Future fetchProfileFeed(String userName) async {
    state = const UserProfileFeedLoadingState();

    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.profileDetails(userName)));

      if (responseBody != null || responseBody != "") {
        userProfileFeedList = ProfileFeedModel.fromJson(responseBody);
        state = UserProfileFeedSuccessState(userProfileFeedList!);
      } else {
        state = const UserProfileFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const UserProfileFeedErrorState();
    }
  }

  Future fetchMoreProfileFeed(String userName) async {
    dynamic responseBody;
    try {
      responseBody =
          await Network.handleResponse(await Network.getRequest(API.profileDetails(userName, lastId: userProfileFeedList!.feedData!.last.id)));

      if (responseBody != null) {
        var profileFeedModelInstance = (responseBody['feedData'] as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();
        userProfileFeedList!.feedData!.addAll(profileFeedModelInstance);
        state = UserProfileFeedSuccessState(userProfileFeedList!);
        ref!.read(profileFeedScrollProvider.notifier).resetState();
      } else {
        state = const UserProfileFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const UserProfileFeedErrorState();
    }
  }
}
