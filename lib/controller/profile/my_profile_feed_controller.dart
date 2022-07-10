import 'package:buddyscripts/controller/pagination/profile/profile_feed_tab.dart';
import 'package:buddyscripts/controller/profile/state/my_profile_feed_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/profile/profile_feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myProfileFeedProvider = StateNotifierProvider<MyProfileFeedController, MyProfileFeedState>(
  (ref) => MyProfileFeedController(ref: ref),
);

class MyProfileFeedController extends StateNotifier<MyProfileFeedState> {
  final Ref? ref;
  MyProfileFeedController({this.ref}) : super(const MyProfileFeedInitialState());

  ProfileFeedModel? myProfileFeedList;

  updateSuccessState(List<FeedModel> feedList) {
    myProfileFeedList!.feedData = feedList;
    state = MyProfileFeedSuccessState(myProfileFeedList!);
  }

  updateBasicInfoState(profileFeedModel) {
    state = MyProfileFeedSuccessState(profileFeedModel);
  }

  refreshBasicInfoState(profileInfo) {
    myProfileFeedList!.basicOverView = profileInfo;
    state = MyProfileFeedSuccessState(myProfileFeedList!);
  }

  Future fetchProfileFeed(String userName) async {
    state = const MyProfileFeedLoadingState();

    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.profileDetails(userName)));

      if (responseBody != null) {
        myProfileFeedList = ProfileFeedModel.fromJson(responseBody);
        state = MyProfileFeedSuccessState(myProfileFeedList!);
      } else {
        state = const MyProfileFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const MyProfileFeedErrorState();
    }
  }

  Future fetchMoreProfileFeed(String userName) async {
    dynamic responseBody;
    try {
      responseBody =
          await Network.handleResponse(await Network.getRequest(API.profileDetails(userName, lastId: myProfileFeedList!.feedData!.last.id)));

      if (responseBody != null) {
      
          var profileFeedModelInstance = (responseBody['feedData'] as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();
         
          // if (profileFeedModelInstance.isNotEmpty) {
          myProfileFeedList!.feedData!.addAll(profileFeedModelInstance);
          state = MyProfileFeedSuccessState(myProfileFeedList!);
          ref!.read(profileFeedScrollProvider.notifier).resetState();
      // }
      } else {
        state = const MyProfileFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const MyProfileFeedErrorState();
    }
  }
}
