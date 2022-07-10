import 'package:buddyscripts/controller/feed/state/world_feed_state.dart';
import 'package:buddyscripts/controller/pagination/home/world_feed_tab.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final worldFeedProvider = StateNotifierProvider<WorldFeedController, WorldFeedState>(
  (ref) => WorldFeedController(ref: ref),
);

class WorldFeedController extends StateNotifier<WorldFeedState> {
  final Ref? ref;
  WorldFeedController({this.ref}) : super(const WorldFeedInitialState());

  List<FeedModel> worldFeedList = [];
  List<FeedModel> feedModelInstance = [];

  updateList(FeedModel feed) {
    worldFeedList.insert(0, feed);
    state = const WorldFeedLoadingState();
    state = WorldFeedSuccessState(worldFeedList);
  }

  updateSuccessState(List<FeedModel> feedList) {
    state = WorldFeedSuccessState(feedList);
  }

  Future fetchWorldFeed() async {
    state = const WorldFeedLoadingState();

    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.worldFeed));

      if (responseBody != null) {
        worldFeedList = (responseBody as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();
        feedModelInstance = worldFeedList;
        state = WorldFeedSuccessState(worldFeedList);
      } else {
        state = const WorldFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const WorldFeedErrorState();
    }
  }

  Future fetchMoreWorldFeed() async {
    dynamic responseBody;
    if (feedModelInstance.length > 14) {
      feedModelInstance = [];
      try {
        responseBody = await Network.handleResponse(await Network.getRequest(API.worldFeed + '&more=${worldFeedList.last.id}'));

        if (responseBody != null) {
          feedModelInstance = (responseBody as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();

          state = WorldFeedSuccessState(worldFeedList..addAll(feedModelInstance));
          ref!.read(worldFeedScrollProvider.notifier).resetState();
        } else {
          state = const WorldFeedErrorState();
        }
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        state = const WorldFeedErrorState();
      }
    } else {
      ref!.read(worldFeedScrollProvider.notifier).resetState();
    }
  }
}
