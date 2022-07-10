
import 'package:buddyscripts/controller/friends/state/all_friends_state.dart';
import 'package:buddyscripts/controller/pagination/friends/all_friends_scroll_provider.dart';
import 'package:buddyscripts/models/friend/friend_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FriendType {ALL, SUGGESTIONS}

final allFriendsprovider = StateNotifierProvider<AllFriendsController,AllFriendsState>(
    (ref) => AllFriendsController(ref:ref),
);

class AllFriendsController extends StateNotifier<AllFriendsState> {
   final Ref? ref;
   AllFriendsController({this.ref}) : super(const AllFriendsInitialState());

 FriendModel? allfriendsModel;
  int currentPage = 1;

    updateSuccessState(FriendModel? friendList) {
    allfriendsModel = friendList;
    state = AllFriendsSuccessState(allfriendsModel??FriendModel());
  }

   Future fetchAllFriends() async {
     state = const AllFriendsLoadingState();
     dynamic responseBody;
      try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.allFriends()));
     print(responseBody);
      if (responseBody != null) {
         allfriendsModel = FriendModel.fromJson(responseBody);
         currentPage = allfriendsModel?.meta?.currentPage;
        state = AllFriendsSuccessState(allfriendsModel!);
      } else {
        state = const AllFriendsErrorState();
      }
    } 
      catch (error, stackTrace) {
         print(error);
         print(stackTrace);
         state = const AllFriendsErrorState();
     }
   }

    Future fetchMoreAllFriends() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.allFriends(page: currentPage += 1)),
      );
      if (responseBody != null) {
        var allfriendsModelInstance = FriendModel.fromJson(responseBody);
        allfriendsModel?.data?.addAll(allfriendsModelInstance.data!);
        state = AllFriendsSuccessState(allfriendsModel!);
        ref!.read(allFriendsScrollProvider.notifier).resetState();
      } else {
        state = const AllFriendsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreAllfriends(): $error");
      print(stackTrace);
      state = const AllFriendsErrorState();
    }
  }
}