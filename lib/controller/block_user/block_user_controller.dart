// ignore_for_file: unnecessary_null_comparison

import 'package:buddyscripts/controller/block_user/state/block_user_state.dart';
import 'package:buddyscripts/controller/chat/chat_friends_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/personal_feed_controller.dart';
import 'package:buddyscripts/controller/feed/world_feed_controller.dart';
import 'package:buddyscripts/controller/friends/all_friends_controller.dart';
import 'package:buddyscripts/controller/friends/friend_requests_controller.dart';
import 'package:buddyscripts/controller/friends/friend_suggestions_controller.dart';
import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/controller/search/search_controlller.dart';
import 'package:buddyscripts/models/block_user/block_user_model.dart';
import 'package:buddyscripts/models/chats/chat_friends_model.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/friend/friend_model.dart';
import 'package:buddyscripts/models/friend/friend_requests_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final blockUserProvider = StateNotifierProvider<BlockUserController,BlockUserState>(
  (ref) => BlockUserController(ref: ref),
);

class BlockUserController extends StateNotifier<BlockUserState> {
  final Ref? ref;
  BlockUserController({this.ref}) : super(const BlockUserInitialState());

  BlockUserModel? blockUserModel;
  int currentPage = 1;

  updateSuccessState(BlockUserModel friendList) {
    blockUserModel = friendList;
    state = BlockUserSuccessState(blockUserModel!);
  }

  Future fetchBlockUser() async {
    state = const BlockUserLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.blockUser()));
      print(responseBody);
      if (responseBody != null) {
        blockUserModel = BlockUserModel.fromJson(responseBody);
        currentPage = blockUserModel?.meta?.currentPage??1;
        state = BlockUserSuccessState(blockUserModel!);
      } else {
        state = const BlockUserErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const BlockUserErrorState();
    }
  }

  Future fetchMoreBlockUser() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.blockUser(page: currentPage += 1)),
      );
      if (responseBody != null) {
        var blockUserModelInstance = BlockUserModel.fromJson(responseBody);
        blockUserModel?.data?.addAll(blockUserModelInstance.data!);
        state = BlockUserSuccessState(blockUserModel!);
      } else {
        state = const BlockUserErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreAllfriends(): $error");
      print(stackTrace);
      state = const BlockUserErrorState();
    }
  }

  Future unblock(int friendId) async {
    dynamic responseBody;

    var requestBody = {'bId': friendId};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.unblock, requestBody));

      if (responseBody != null) {
        blockUserModel?.data?.removeWhere((element) => element.id == friendId);

        ref!.read(blockUserProvider.notifier).updateSuccessState(blockUserModel!);
      } else {
        state = const UnblockedUserErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const UnblockedUserErrorState();
    }
  }

   block(friendId, {FeedType? feedType, FeedModel? feed, String? route}) async {
    dynamic responseBody;

    var requestBody = {'blocked_user_id': friendId};

    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.block, requestBody));

   
      if (responseBody != null) {
     //   ref!.read(blockUserProvider).updateSuccessState(blockUserModel);

        FriendModel? allFriendsModel = ref!.read(allFriendsprovider.notifier).allfriendsModel;
     
        if (allFriendsModel != null) {
          int allFriendsIndex = allFriendsModel.data!.indexWhere(((element) => element.id == friendId));
          if (allFriendsIndex != -1) allFriendsModel.data!.removeWhere((element) => element.id == friendId);
          ref!.read(allFriendsprovider.notifier).updateSuccessState(allFriendsModel);
        }

        FriendRequestsModel? friendRequestsModel = ref!.read(friendRequestsProvider.notifier).friendRequestsModel;
        if (friendRequestsModel != null) {
          int friendRequestsIndex = friendRequestsModel.data!.indexWhere(((element) => element.id == friendId));
          if (friendRequestsIndex != -1) friendRequestsModel.data!.removeWhere((element) => element.friendId == friendId);
          ref!.read(friendRequestsProvider.notifier).updateSuccessState(friendRequestsModel);
        }

        FriendModel? friendSuggestionsModel = ref!.read(friendSuggestionsprovider.notifier).friendSuggestionsModel;
        if (friendSuggestionsModel != null) {
          int friendSuggestionsIndex = friendSuggestionsModel.data!.indexWhere(((element) => element.id == friendId));
          if (friendSuggestionsIndex != -1) friendSuggestionsModel.data!.removeWhere((element) => element.id == friendId);
          ref!.read(friendSuggestionsprovider.notifier).updateSuccessState(friendSuggestionsModel);
        }

        ChatFriendsModel chatFriendsModel = ref!.read(chatFriendsProvider.notifier).chatFriendsModel!;
        if (chatFriendsModel != null) {
          int chatFriendsIndex = chatFriendsModel.data!.indexWhere(((element) => element.id == friendId));
          if (chatFriendsIndex != -1) chatFriendsModel.data!.removeWhere((element) => element.id == friendId);
          ref!.read(chatFriendsProvider.notifier).updateSuccessState(chatFriendsModel);
        }

        final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
        final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;

        // var isInWorldFeedList = worldFeedList.firstWhere((element) => element.id == feed.userId, orElse: () => null);
        // var isInPersonalFeedList = personalFeedList.firstWhere((element) => element.id == feed.userId, orElse: () => null);

        if (worldFeedList != null) {
          int isInWorldFeedIndex = worldFeedList.indexWhere(((element) => element.userId == friendId));
          if (isInWorldFeedIndex != -1) {
            worldFeedList.removeWhere((element) => element.userId == friendId);
          ref!.read(groupFeedProvider.notifier).updateSuccessState(worldFeedList);
          }
        }

        if (personalFeedList != null) {
          int isInPersonalFeedIndex = personalFeedList.indexWhere(((element) => element.userId == friendId));
          if (isInPersonalFeedIndex != -1) personalFeedList.removeWhere((element) => element.userId == friendId);
          ref!.read(groupFeedProvider.notifier).updateSuccessState(worldFeedList);
        }
        List<FeedModel> groupFeedList = [];
        if (ref!.read(groupFeedProvider.notifier).groupFeedList != null) {
          groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList!.feedData!;
        }

        if (groupFeedList.isNotEmpty) {
          int groupFeedListIndex = groupFeedList.indexWhere(((element) => element.userId == friendId));
          print("groupFeedListIndex");
          print(groupFeedListIndex);

          if (groupFeedListIndex != -1) groupFeedList.removeWhere((element) => element.userId == friendId);
          ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
        }
        final dynamic searchFeedList = ref!.read(searchProvider.notifier).response;

        print("ref!.read(searchProvider).response");
        print(ref!.read(searchProvider.notifier).response);

   
        if (searchFeedList!=null ) {
          if(searchFeedList.isNotEmpty){
          int searchIndex = searchFeedList.indexWhere(((element) => element.userId == friendId));
          if (searchIndex != -1) searchFeedList.removeWhere((element) => element.userId == friendId);
          ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
        }
       }
        if (route != "feedCard") {
          NavigationService.popNavigate();
        }
      } else {
        state = const BlockedUserErrorState();
      }
      NavigationService.popNavigate();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const BlockedUserErrorState();
    }
  }
}
