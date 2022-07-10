import 'package:buddyscripts/controller/feed/state/feed_reacted_users_state.dart';
import 'package:buddyscripts/controller/feed/state/feed_reaction_types_state.dart';
import 'package:buddyscripts/controller/pagination/feed/feed_reacted_users_scroll_provider.dart';
import 'package:buddyscripts/models/feed/feed_reacted_users_model.dart';
import 'package:buddyscripts/models/feed/feed_reaction_types_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedReactedUsersProvider = StateNotifierProvider<FeedReactedUsersController, FeedReactedUsersState>(
  (ref) => FeedReactedUsersController(ref: ref),
);

class FeedReactedUsersController extends StateNotifier<FeedReactedUsersState> {
  final Ref? ref;
  FeedReactedUsersController({this.ref}) : super(const FeedReactedUsersInitialState());

  List<FeedReactedUsersModel> feedReactedUsersModel = [];

  Future fetchFeedReactedUsers(int feedId, {String reactionType = "all"}) async {
    feedReactedUsersModel = [];
    state = const FeedReactedUsersLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.feedReactedUsers(feedId, reactionType: reactionType)),
      );
      if (responseBody != null) {
        feedReactedUsersModel = (responseBody as List<dynamic>).map((x) => FeedReactedUsersModel.fromJson(x)).toList();

        state = FeedReactedUsersSuccessState(feedReactedUsersModel);
      } else {
        state = const FeedReactedUsersErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchFeedReactedUsers() error =  $error");
      print(stackTrace);
      state = const FeedReactedUsersErrorState();
    }
  }

  Future fetchMoreFeedReactedUsers(int feedId, {String reactionType = "all"}) async {
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.feedReactedUsers(feedId, reactionType: reactionType, lastId: feedReactedUsersModel.last.id)),
      );
      if (responseBody != null) {
        var feedReactedUsersModelInstance = (responseBody as List<dynamic>).map((x) => FeedReactedUsersModel.fromJson(x)).toList();
        if (feedReactedUsersModelInstance.isNotEmpty &&
            (feedReactedUsersModelInstance.first.id == feedReactedUsersModel.first.id ||
                feedReactedUsersModelInstance.first.id == feedReactedUsersModel.last.id)) return;
        feedReactedUsersModel.addAll(feedReactedUsersModelInstance);

        state = FeedReactedUsersSuccessState(feedReactedUsersModel);
        ref!.read(feedReactedUsersScrollProvider.notifier).resetState();
      } else {
        state = const FeedReactedUsersErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchFeedReactedUsers() error =  $error");
      print(stackTrace);
      state = const FeedReactedUsersErrorState();
    }
  }
}

final feedReactionTypesProvider = StateNotifierProvider<FeedReactionTypesController, FeedReactionTypesState>(
  (ref) => FeedReactionTypesController(ref: ref),
);

class FeedReactionTypesController extends StateNotifier<FeedReactionTypesState> {
  final Ref? ref;
  FeedReactionTypesController({this.ref}) : super(const FeedReactionTypesInitialState());

  List<FeedReactionTypesModel>? feedReactionTypesModel = [FeedReactionTypesModel(reactionType: 'Like')];

  Future fetchFeedReactionTypes(int feedId, {String reactionType = "all"}) async {
    feedReactionTypesModel!.clear();
    feedReactionTypesModel = [FeedReactionTypesModel(reactionType: 'All')];
    state = const FeedReactionTypesLoadingState();
    print('FeedReactionTypesLoadingState =  $state');
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.feedReactionTypes(feedId)),
      );
      if (responseBody != null) {
        var feedReactionTypesInstance = (responseBody as List<dynamic>).map((x) => FeedReactionTypesModel.fromJson(x)).toList();

        state = FeedReactionTypesSuccessState(feedReactionTypesModel!..addAll(feedReactionTypesInstance));
      } else {
        state = const FeedReactionTypesErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchFeedReactionTypes() error =  $error");
      print(stackTrace);
      state = const FeedReactionTypesErrorState();
    }
  }
}
