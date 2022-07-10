import 'package:buddyscripts/controller/chat/chat_friends_controller.dart';
import 'package:buddyscripts/controller/friends/all_friends_controller.dart';
import 'package:buddyscripts/controller/pagination/friends/friend_requests_scroll_provider.dart';
import 'package:buddyscripts/controller/profile/user_profile_feed_controller.dart';
import 'package:buddyscripts/models/chats/chat_friends_model.dart';
import 'package:buddyscripts/models/friend/friend_model.dart' as friend;
import 'package:buddyscripts/models/friend/friend_requests_model.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart' as overview;
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/controller/friends/state/friend_requests_state.dart';

final friendRequestsProvider = StateNotifierProvider<FriendRequestsController, FriendRequestsState>(
  (ref) => FriendRequestsController(ref: ref),
);

class FriendRequestsController extends StateNotifier<FriendRequestsState> {
  final Ref? ref;
  FriendRequestsController({this.ref}) : super(const FriendRequestsInitialState());

  FriendRequestsModel? friendRequestsModel;
  int currentPage = 1;

  updateSuccessState(FriendRequestsModel friendRequestList) {
    friendRequestsModel = friendRequestList;
    state = FriendRequestsSuccessState(friendRequestList);
  }

  Future fetchFriendRequests() async {
    if (friendRequestsModel == null) state = const FriendRequestsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.friendRequests()));
      print(responseBody);
      if (responseBody != null) {
        friendRequestsModel = FriendRequestsModel.fromJson(responseBody);
        currentPage = friendRequestsModel?.meta?.currentPage;
        state = FriendRequestsSuccessState(friendRequestsModel!);
      } else {
        state = const FriendRequestsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FriendRequestsErrorState();
    }
  }

  Future fetchMoreFriendRequests() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.friendRequests(page: currentPage += 1)),
      );
      if (responseBody != null) {
        var friendRequestsModelInstance = FriendRequestsModel.fromJson(responseBody);
        friendRequestsModel?.data?.addAll(friendRequestsModelInstance.data!);
        state = FriendRequestsSuccessState(friendRequestsModel!);
        ref!.read(friendRequestsScrollProvider.notifier).resetState();
      } else {
        state = const FriendRequestsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMorefriendRequests(): $error");
      print(stackTrace);
      state = const FriendRequestsErrorState();
    }
  }

  Future deleteRequest(int friendId) async {
    dynamic responseBody;

    var requestBody = {'friend_id': friendId};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deleteFriendRequest, requestBody));

      if (responseBody != null) {
        friendRequestsModel?.data!.removeWhere((element) => element.friendId == friendId);
        NavigationService.popNavigate();
        ref!.read(friendRequestsProvider.notifier).updateSuccessState(friendRequestsModel!);
      } else {
        state = const FriendRequestsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FriendRequestsErrorState();
    }
  }

  Future acceptRequest({friendId, friendOverview}) async {
    dynamic responseBody;

    var requestBody = {'id': friendId};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.friendRequest, requestBody));

      if (responseBody != null) {
        if (friendRequestsModel != null) {
          friendRequestsModel?.data!.removeWhere((element) => element.friendId == friendId);
        }
        ref!.read(friendRequestsProvider.notifier).updateSuccessState(friendRequestsModel!);

        friend.FriendModel? allFriendsModel = ref!.read(allFriendsprovider.notifier).allfriendsModel;

        if (friendOverview != null) {
          friend.Datum friendDataInstance = friend.Datum(
              id: friendOverview.id,
              firstName: friendOverview.firstName,
              lastName: friendOverview.lastName,
              profilePic: friendOverview.profilePic,
              username: friendOverview.username);
          if (allFriendsModel != null) {
            allFriendsModel.data?.add(friendDataInstance);
            ref!.read(allFriendsprovider.notifier).updateSuccessState(allFriendsModel);
          }

          overview.Friend friendInstance = overview.Friend.fromJson(responseBody);
          overview.ProfileOverView friendProfileInstance = overview.ProfileOverView(
            id: friendOverview.id,
            username: friendOverview.username,
            firstName: friendOverview.firstName,
            lastName: friendOverview.lastName,
            email: friendOverview.email,
            userType: friendOverview.userType,
            profilePic: friendOverview.profilePic,
            cover: friendOverview.cover,
            appToken: friendOverview.appToken,
            gender: friendOverview.appToken,
            isOnline: friendOverview.isOnline,
            status: friendOverview.status,
            msgCount: friendOverview.msgCount,
            friendCount: friendOverview.friendCount,
            birthDate: friendOverview.birthDate,
            about: friendOverview.about,
            phone: friendOverview.phone,
            website: friendOverview.website,
            nickName: friendOverview.nickName,
            currentCity: friendOverview.currentCity,
            homeTown: friendOverview.homeTown,
            country: friendOverview.country,
            workData: friendOverview.workData,
            skillData: friendOverview.skillData,
            educationData: friendOverview.educationData,
            createdAt: friendOverview.createdAt,
            updatedAt: friendOverview.updatedAt,
            friend: friendInstance,
          );

          ref!.read(userProfileFeedProvider.notifier).updateOverviewSuccessState(friendProfileInstance);
        }
      } else {
        state = const FriendRequestsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FriendRequestsErrorState();
    }
  }

  Future unfriend(friendData) async {
    dynamic responseBody;

    var requestBody = {'id': friendData.id};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.friendRequest, requestBody));

      if (responseBody != null) {
        friend.FriendModel? allFriendsModel = ref!.read(allFriendsprovider.notifier).allfriendsModel;
        if (allFriendsModel != null) {
          allFriendsModel.data!.removeWhere((element) => element.id == friendData.id);
        }
        ref!.read(allFriendsprovider.notifier).updateSuccessState(allFriendsModel);

        overview.ProfileOverView friendProfileInstance = overview.ProfileOverView(
          id: friendData.id,
          username: friendData.username,
          firstName: friendData.firstName,
          lastName: friendData.lastName,
          email: friendData.email,
          userType: friendData.userType,
          profilePic: friendData.profilePic,
          cover: friendData.cover,
          appToken: friendData.appToken,
          gender: friendData.gender,
          isOnline: friendData.isOnline,
          status: friendData.status,
          msgCount: friendData.msgCount,
          friendCount: friendData.friendCount,
          birthDate: friendData.birthDate,
          about: friendData.about,
          phone: friendData.phone,
          website: friendData.website,
          nickName: friendData.nickName,
          currentCity: friendData.currentCity,
          homeTown: friendData.homeTown,
          country: friendData.country,
          workData: friendData.workData,
          skillData: friendData.skillData,
          educationData: friendData.educationData,
          createdAt: friendData.createdAt,
          updatedAt: friendData.updatedAt,
        );

        ref!.read(userProfileFeedProvider.notifier).updateOverviewSuccessState(friendProfileInstance);

        ChatFriendsModel? chatFriendsModel = ref!.read(chatFriendsProvider.notifier).chatFriendsModel;
        if (chatFriendsModel != null) {
          int chatFriendsIndex = chatFriendsModel.data!.indexWhere(((element) => element.id == friendData.id));
          if (chatFriendsIndex != -1) {
            chatFriendsModel.data!.removeWhere((element) => element.id == friendData.id);
          }
          ref!.read(chatFriendsProvider.notifier).updateSuccessState(chatFriendsModel);
        }
      } else {
        state = const FriendRequestsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FriendRequestsErrorState();
    }
  }

  Future addFriend(friendData) async {
    dynamic responseBody;
    var requestBody = {'id': friendData.id};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.friendRequest, requestBody));

      if (responseBody != null) {
        overview.Friend friendInstance = overview.Friend.fromJson(responseBody);
        overview.ProfileOverView friendProfileInstance = overview.ProfileOverView(
          id: friendData.id,
          username: friendData.username,
          firstName: friendData.firstName,
          lastName: friendData.lastName,
          email: friendData.email,
          userType: friendData.userType,
          profilePic: friendData.profilePic,
          cover: friendData.cover,
          appToken: friendData.appToken,
          gender: friendData.gender,
          isOnline: friendData.isOnline,
          status: friendData.status,
          msgCount: friendData.msgCount,
          friendCount: friendData.friendCount,
          birthDate: friendData.birthDate,
          about: friendData.about,
          phone: friendData.phone,
          website: friendData.website,
          nickName: friendData.nickName,
          currentCity: friendData.currentCity,
          homeTown: friendData.homeTown,
          country: friendData.country,
          workData: friendData.workData,
          skillData: friendData.skillData,
          educationData: friendData.educationData,
          createdAt: friendData.createdAt,
          updatedAt: friendData.updatedAt,
          friend: friendInstance,
        );

        ref!.read(userProfileFeedProvider.notifier).updateOverviewSuccessState(friendProfileInstance);
      } else {
        state = const FriendRequestsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FriendRequestsErrorState();
    }
  }
}
