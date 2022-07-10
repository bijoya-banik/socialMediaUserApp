import 'package:buddyscripts/controller/feed/state/personal_feed_state.dart';
import 'package:buddyscripts/controller/pagination/home/world_feed_tab.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personalFeedProvider = StateNotifierProvider<PersonalFeedController,PersonalFeedState>(
  (ref) => PersonalFeedController(ref: ref),
);

class PersonalFeedController extends StateNotifier<PersonalFeedState> {
  final Ref? ref;
  PersonalFeedController({this.ref}) : super(const PersonalFeedInitialState());

  List<FeedModel> personalFeedList = [];
  List<FeedModel> feedModelInstance = [];

  
  updateList(FeedModel feed) {
    personalFeedList.insert(0, feed);
    state = PersonalFeedSuccessState(personalFeedList);
  }

  updateSuccessState(List<FeedModel> feedList) {
    state = PersonalFeedSuccessState(feedList);
  }

  Future fetchPersonalFeed() async {
    state = const PersonalFeedLoadingState();

    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.personalFeed));

      if (responseBody != null) {
        personalFeedList = (responseBody as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();
        feedModelInstance = personalFeedList;
        state = PersonalFeedSuccessState(personalFeedList);
      } else {
        state = const PersonalFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const PersonalFeedErrorState();
    }
  }

  Future fetchMorePersonalFeed() async {
    dynamic responseBody;

    if (feedModelInstance.length > 14) {
      feedModelInstance = [];
      try {
        responseBody = await Network.handleResponse(await Network.getRequest(API.personalFeed + '&more=${personalFeedList.last.id}'));

        if (responseBody != null) {
          feedModelInstance = (responseBody as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();
          state = PersonalFeedSuccessState(personalFeedList..addAll(feedModelInstance));
          ref!.read(worldFeedScrollProvider.notifier).resetState();
          // ref.read(personalFeedScrollProvider).resetState();
        } else {
          state = const PersonalFeedErrorState();
        }
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        state = const PersonalFeedErrorState();
      }
    } else {
      ref!.read(worldFeedScrollProvider.notifier).resetState();
    }
  }
}
