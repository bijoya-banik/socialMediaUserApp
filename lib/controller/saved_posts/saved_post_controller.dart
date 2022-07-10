import 'package:buddyscripts/controller/pagination/saved_posts/saved_posts_scroll_provider.dart';
import 'package:buddyscripts/controller/saved_posts/state/saved_posts_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/saved_posts/saved_posts_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedPostsProvider = StateNotifierProvider<SavedPostsController, SavedPostsState>(
  (ref) => SavedPostsController(ref: ref),
);

class SavedPostsController extends StateNotifier<SavedPostsState> {
  final Ref? ref;
  SavedPostsController({this.ref}) : super(const SavedPostsInitialState());

  SavedPostsModel? savedPostsModel;
  int currentPage = 1;

  updateSuccessState(List<FeedModel> feedList) {
    savedPostsModel!.feedData!.data = feedList;
    state = SavedPostsSuccessState(savedPostsModel!);
  }

  Future fetchSavedPosts() async {
    state = const SavedPostsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.savedPosts()));
      print(responseBody);
      if (responseBody != null) {
        savedPostsModel = SavedPostsModel.fromJson(responseBody);
        currentPage = savedPostsModel!.feedData!.meta!.currentPage;
        state = SavedPostsSuccessState(savedPostsModel!);
      } else {
        state = const SavedPostsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const SavedPostsErrorState();
    }
  }

  Future fetchMoreSavedPosts() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.savedPosts(page: currentPage += 1)),
      );
      if (responseBody != null) {
        var friendRequestsModelInstance = SavedPostsModel.fromJson(responseBody);
        savedPostsModel!.feedData!.data!.addAll(friendRequestsModelInstance.feedData!.data!);
        state = SavedPostsSuccessState(savedPostsModel!);
        ref!.read(savedPostsScrollProvider.notifier).resetState();
      } else {
        state = const SavedPostsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMorefriendRequests(): $error");
      print(stackTrace);
      state = const SavedPostsErrorState();
    }
  }
}
