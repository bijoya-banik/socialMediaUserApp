import 'package:buddyscripts/controller/page/state/followed_pages_state.dart';
import 'package:buddyscripts/controller/pagination/page/followed_pages_tab.dart';
import 'package:buddyscripts/models/page/pages_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final followedPagesProvider = StateNotifierProvider<FollowedPagesController,FollowedPagesState>(
  (ref) => FollowedPagesController(ref: ref),
);

class FollowedPagesController extends StateNotifier<FollowedPagesState> {
  final Ref? ref;
  FollowedPagesController({this.ref}) : super(const FollowedPagesInitialState());

  PagesModel? followedPagesModel;
  int currentPage = 1;

  updateSuccessState(PagesModel followedPages) {
    followedPagesModel = followedPages;
    state = FollowedPagesSuccessState(followedPagesModel!);
  }

  Future fetchFollowedPages() async {
    state = const FollowedPagesLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pages(tab: 'followed')),
      );
      if (responseBody != null) {
        followedPagesModel = PagesModel.fromJson(responseBody);
        currentPage = followedPagesModel!.meta!.currentPage;
        state = FollowedPagesSuccessState(followedPagesModel!);
      } else {
        state = const FollowedPagesErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchFollowedPages(): $error");
      print(stackTrace);
      state = const FollowedPagesErrorState();
    }
  }

  Future fetchMorefollowedPages() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pages(tab: 'followed', page: currentPage += 1)),
      );
      if (responseBody != null) {
        var followedPagesModelInstance = PagesModel.fromJson(responseBody);
        followedPagesModel!.data!.addAll(followedPagesModelInstance.data!);
        state = FollowedPagesSuccessState(followedPagesModel!);
        ref!.read(followedPagesScrollProvider.notifier).resetState();
      } else {
        state = const FollowedPagesErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreFollowedPages(): $error");
      print(stackTrace);
      state = const FollowedPagesErrorState();
    }
  }
}
