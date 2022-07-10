import 'package:buddyscripts/controller/friends/state/friend_suggestions_state.dart';
import 'package:buddyscripts/controller/pagination/friends/friend_suggestions_scroll_provider.dart';
import 'package:buddyscripts/models/friend/friend_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendSuggestionsprovider = StateNotifierProvider<FriendSuggestionsController,FriendSuggestionsState>(
  (ref) => FriendSuggestionsController(ref: ref),
);

class FriendSuggestionsController extends StateNotifier<FriendSuggestionsState> {
  final Ref? ref;
  FriendSuggestionsController({this.ref}) : super(const FriendSuggestionsInitialState());

  FriendModel? friendSuggestionsModel;
  int currentPage = 1;

    updateSuccessState(FriendModel friendSuggestionsInstance) {
    friendSuggestionsModel = friendSuggestionsInstance;
    state = FriendSuggestionsSuccessState(friendSuggestionsModel!);
  }

  Future fetchFriendSuggestions() async {
    state = const FriendSuggestionsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.friendSuggestions()));
      print(responseBody);
      if (responseBody != null) {
        friendSuggestionsModel = FriendModel.fromJson(responseBody);
        currentPage = friendSuggestionsModel?.meta?.currentPage;
        state = FriendSuggestionsSuccessState(friendSuggestionsModel!);
      } else {
        state = const FriendSuggestionsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FriendSuggestionsErrorState();
    }
  }

  Future fetchMoreFriendSuggestions() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.friendSuggestions(page: currentPage += 1)),
      );
      if (responseBody != null) {
        var friendSuggestionsModelInstance = FriendModel.fromJson(responseBody);
        friendSuggestionsModel?.data?.addAll(friendSuggestionsModelInstance.data!);
        state = FriendSuggestionsSuccessState(friendSuggestionsModel!);
        ref!.read(friendSuggestionsScrollProvider.notifier).resetState();
      } else {
        state = const FriendSuggestionsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMorefriendSuggestions(): $error");
      print(stackTrace);
      state = const FriendSuggestionsErrorState();
    }
  }
}
