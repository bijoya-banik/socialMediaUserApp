// ignore_for_file: constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/event/event_feed_controller.dart';
import 'package:buddyscripts/controller/feed/feed_details_controller.dart';
import 'package:buddyscripts/controller/feed/link_preview_controller.dart';
import 'package:buddyscripts/controller/feed/personal_feed_controller.dart';
import 'package:buddyscripts/controller/feed/state/feed_state.dart';
import 'package:buddyscripts/controller/feed/world_feed_controller.dart';
import 'package:buddyscripts/controller/feelings_activities/feelings_controller.dart';
import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/controller/page/page_feed_controller.dart';
import 'package:buddyscripts/controller/pagination/home/world_feed_tab.dart';
import 'package:buddyscripts/controller/profile/my_profile_feed_controller.dart';
import 'package:buddyscripts/controller/profile/user_profile_feed_controller.dart';
import 'package:buddyscripts/controller/saved_posts/saved_post_controller.dart';
import 'package:buddyscripts/controller/search/search_controlller.dart';
import 'package:buddyscripts/controller/story/all_story_controller.dart';
import 'package:buddyscripts/controller/story/story_controller.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/models/story/story_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:collection/collection.dart';

enum FeedType { HOME, PAGE, GROUP, EVENT, PROFILE, SAVED, DETAILS, SEARCH, STORY }
// enum ReactionType { LIKE, WOW, ANGRY, LOVE, HAHA, SAD }

final feedProvider = StateNotifierProvider<FeedController, FeedState>(
  (ref) => FeedController(ref: ref),
);

class FeedController extends StateNotifier<FeedState> {
  final Ref? ref;

  // List statusShareUserIdList = [];

  FeedController({this.ref}) : super(const FeedInitialState());

  Future createFeed({
    String? feedText,
    feedPrivacy,
    activityType,
    pageId,
    groupId,
    eventId,
    fileType,
    shareId,
    List<File>? images,
    FeedType? feedType,
    story,
    int? isBackground,
    String? bgColor,
    FeelingsModel? feelingsModel,
    pollOptions,
    pollPrivacy,
    bool isPoll = false,
  }) async {
    state = const FeedLoadingState();

    dynamic responseBody;
    dynamic metaData;

    if (ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel != null) {
      metaData = {
        "title": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.title,
        "url": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.url,
        "image": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.image,
        "description": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.description
      };
    } else {
      metaData = null;
    }

    dynamic feeling;

    if (feelingsModel != null) {
      feeling = {
        "text": feelingsModel.type == null
            ? feelingsModel.name
            : "is" + (feelingsModel.type == "FEELINGS" ? " feeling " : " celebrating ") + (feelingsModel.name ?? ""), // celebrating a special day",
        "icon": feelingsModel.icon
      };
    }

    Map<String, String> requestBody = {
      "feed_txt": feedText!,
      if (images!.isNotEmpty)
        if (fileType != null) "files": fileType,
      if (images.isNotEmpty)
        if (fileType != null) "uploadType": fileType,
      "meta_data": jsonEncode({"linkMeta": metaData, "contentsMetaData": null}),
      "feed_privacy": feedPrivacy == 'Public'
          ? 'PUBLIC'
          : feedPrivacy == 'Friends'
              ? 'FRIENDS'
              : 'ONLY ME',
      "activity_type": activityType,
      if (shareId != null && activityType == 'share') "share_id": shareId.toString(),
      if (pageId != null) "page_id": pageId.toString(),
      if (groupId != null) "group_id": groupId.toString(),
      if (eventId != null) "event_id": eventId.toString(),
      if (story != null) "is_story": story.toString(),
      "is_background": isBackground == null ? "0" : isBackground.toString(),
      if (bgColor != null) "bg_color": bgColor.toString(),
      if (feelingsModel != null) "feelings": jsonEncode(feeling),
      if (isPoll) "poll_options": jsonEncode(pollOptions),
      if (isPoll) "poll_privacy": jsonEncode(pollPrivacy),
    };

    print('requestBody = $requestBody');
    print("storyyyyyyyyyyyyyyyyy");
    print(responseBody);
    try {
      responseBody = await Network.handleResponse(
        await Network.multiPartRequest(API.createFeed, 'POST', body: requestBody, files: images),
      );
      if (responseBody != null) {
        if (story == 1) {
          final List<StoryModel> storyList = ref!.read(storyProvider.notifier).storyModel;
          int storyIndex;
          if (storyList.isNotEmpty) {
            storyIndex = storyList.indexWhere((element) => element.id == getIntAsync(USER_ID));
            if (storyIndex != -1) storyList.removeWhere((element) => element.id == getIntAsync(USER_ID));
          }

          FileElement? files;

          if (responseBody["files"].length > 0) {
            files = FileElement.fromJson(responseBody["files"][0]);
          }

          storyList.insert(
              1,
              StoryModel(
                id: ref!.read(userProvider.notifier).userData?.user?.id,
                firstName: ref!.read(userProvider.notifier).userData!.user?.firstName,
                lastName: ref!.read(userProvider.notifier).userData!.user?.lastName,
                profilePic: ref!.read(userProvider.notifier).userData!.user?.profilePic,
                type: responseBody["file_type"] == null ? "text" : files?.type,
                data: responseBody["file_type"] == null ? feedText : files?.fileLoc,
                bgColor: bgColor.toString(),
              ));

          // print(' bgColor: bgColor.toString() = bgColor: ${bgColor.toString()}');
          // print(' bgColor: bgColor.runtimeType =: ${bgColor.runtimeType}');
          // print(' bgColor: bgColor.runtimeType null =: ${bgColor.runtimeType == null}');

          await ref!.read(allstoryProvider.notifier).fetchAllStory();

          ref!.read(storyProvider.notifier).updateSuccessState(storyList);
        } else {
          FeedModel feed = FeedModel.fromJson(responseBody);

          ref!.read(worldFeedProvider.notifier).updateList(feed);
          ref!.read(personalFeedProvider.notifier).updateList(feed);
          if (feedType == FeedType.PROFILE) {
            final myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList;

            if (myProfileFeedList != null) {
              myProfileFeedList.feedData!.insert(0, feed);
              ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList.feedData!);
            }
          } else if (feedType == FeedType.GROUP) {
            final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
            groupFeedList!.insert(0, feed);
            ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
          } else if (feedType == FeedType.EVENT) {
            final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;
            eventFeedList!.insert(0, feed);
            ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList);
          } else if (feedType == FeedType.PAGE) {
            final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
            pageFeedList!.insert(0, feed);
            ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);
          }
        }

        ref!.read(assetManagerProvider).removeAll();
        ref!.read(linkPreviewProvider.notifier).updateState();
        ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel = null;
        ref!.read(feelingsProvider.notifier).selectedfeelingData = null;

        if (ref!.read(worldFeedScrollProvider.notifier).controller.hasClients) {
          ref!.read(worldFeedScrollProvider.notifier).controller.animateTo(
                ref!.read(worldFeedScrollProvider.notifier).controller.position.minScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
        }

        state = const FeedSuccessState();
      } else {
        state = const FeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FeedErrorState();
    }
  }

  Future updateFeed({
    int? feedId,
    String? feedText,
    feedPrivacy,
    activityType,
    shareId,
    pageId,
    groupId,
    eventId,
    fileType,
    List<File>? images,
    FeedType? feedType,
    oldFiles,
    int? isBackground,
    String? bgColor,
    FeelingsModel? feelingsModel,
    pollOptions,
    pollPrivacy,
    bool isPoll = false,
  }) async {
    state = const FeedLoadingState();

    dynamic responseBody;
    dynamic metaData;

    if (ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel != null) {
      metaData = {
        "title": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.title,
        "url": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.url,
        "image": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.image,
        "description": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.description
      };
    } else {
      metaData = null;
    }

    dynamic feeling;

    if (feelingsModel != null) {
      feeling = {
        "text": "is" + (feelingsModel.type == "FEELINGS" ? " feeling " : " celebrating ") + (feelingsModel.name ?? ""), // celebrating a special day",
        "icon": feelingsModel.icon
      };
    }

    Map<String, String> requestBody = {
      "id": feedId.toString(),
      "feed_txt": feedText!,
      if (images!.isNotEmpty || oldFiles.length != 0)
        if (fileType != null) "files": fileType,
      if (images.isNotEmpty || oldFiles.length != 0)
        if (fileType != null) "uploadType": fileType,
      "meta_data": jsonEncode({"linkMeta": metaData, "contentsMetaData": null}),
      "feed_privacy": feedPrivacy == 'Public'
          ? 'PUBLIC'
          : feedPrivacy == 'Friends'
              ? 'FRIENDS'
              : 'ONLY ME',
      "activity_type": activityType,
      if (shareId != null && activityType == 'share') "share_id": shareId.toString(),
      if (pageId != null) "page_id": pageId.toString(),
      if (groupId != null) "group_id": groupId.toString(),
      if (eventId != null) "event_id": eventId.toString(),
      if (oldFiles != null || oldFiles.isNotEmpty) "old_files": jsonEncode(oldFiles),
      "is_background": isBackground.toString(),
      "bg_color": bgColor.toString(),
      // if (feelingsModel != null)
      "feelings": jsonEncode(feeling),
      if (isPoll) "poll_options": jsonEncode(pollOptions),
      if (isPoll) "poll_privacy": jsonEncode(pollPrivacy),
    };
    try {
      responseBody = await Network.handleResponse(
        await Network.multiPartRequest(API.updateFeed, 'POST', body: requestBody, files: images),
      );
      if (responseBody != null) {
        ref!.read(assetManagerProvider).removeAll();
        ref!.read(linkPreviewProvider.notifier).updateState();
        ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel = null;
        ref!.read(feelingsProvider.notifier).selectedfeelingData = null;
        NavigationService.popNavigate();

        state = const FeedSuccessState();
      } else {
        state = const FeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FeedErrorState();
    }
  }

  Future deleteFeed({FeedModel? feed, FeedType? feedType}) async {
    var requestBody = {'id': feed?.id, 'user_id': getIntAsync(USER_ID)};
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.deleteFeed, requestBody),
      );
      if (responseBody != null) {
        if (feedType == FeedType.HOME) {
          final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
          final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;

          FeedModel? isInWorldFeedList = worldFeedList.firstWhereOrNull((element) => element.id == feed?.id);
          FeedModel? isInPersonalFeedList = personalFeedList.firstWhereOrNull((element) => element.id == feed?.id);

          if (isInWorldFeedList != null) {
            worldFeedList.removeWhere((element) => element.id == feed?.id);
            ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
          }
          if (isInPersonalFeedList != null) {
            personalFeedList.removeWhere((element) => element.id == feed?.id);
            ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
          }
        } else if (feedType == FeedType.PROFILE) {
          final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList!.feedData;
          myProfileFeedList!.removeWhere((element) => element.id == feed?.id);
          ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList);
        } else if (feedType == FeedType.GROUP) {
          final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList!.feedData;
          groupFeedList!.removeWhere((element) => element.id == feed?.id);
          ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
        } else if (feedType == FeedType.EVENT) {
          final List<FeedModel>? eventFeedList = ref?.read(eventFeedProvider.notifier).eventFeedList!.feedData;
          eventFeedList!.removeWhere((element) => element.id == feed?.id);
          ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList);
        } else if (feedType == FeedType.PAGE) {
          final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList!.feedData;
          pageFeedList!.removeWhere((element) => element.id == feed?.id);
          ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);
        } else if (feedType == FeedType.SEARCH) {
          final List<FeedModel> searchFeedList = ref!.read(searchProvider.notifier).response;
          searchFeedList.removeWhere((element) => element.id == feed?.id);
          ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
        } else if (feedType == FeedType.DETAILS) {
          NavigationService.popNavigate();
        }
        NavigationService.popNavigate();
      } else {
        state = const FeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FeedErrorState();
    }
  }

  Future hideFeed({FeedModel? feed, FeedType? feedType}) async {
    var requestBody = {'id': feed?.id, 'user_id': getIntAsync(USER_ID)};
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.hideFeed, requestBody),
      );
      if (responseBody != null) {
        if (feedType == FeedType.HOME) {
          final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
          final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;

          FeedModel? isInWorldFeedList = worldFeedList.firstWhereOrNull((element) => element.id == feed?.id);
          FeedModel? isInPersonalFeedList = personalFeedList.firstWhereOrNull((element) => element.id == feed?.id);

          if (isInWorldFeedList != null) {
            worldFeedList.removeWhere((element) => element.id == feed?.id);
            ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
          }
          if (isInPersonalFeedList != null) {
            personalFeedList.removeWhere((element) => element.id == feed?.id);
            ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
          }
        } else if (feedType == FeedType.PROFILE) {
          final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
          myProfileFeedList?.removeWhere((element) => element.id == feed?.id);
          ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList!);
        } else if (feedType == FeedType.GROUP) {
          final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
          groupFeedList!.removeWhere((element) => element.id == feed?.id);
          ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
        } else if (feedType == FeedType.EVENT) {
          final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;
          eventFeedList!.removeWhere((element) => element.id == feed?.id);
          ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList);
        } else if (feedType == FeedType.PAGE) {
          final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
          pageFeedList!.removeWhere((element) => element.id == feed?.id);
          ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);
        } else if (feedType == FeedType.SEARCH) {
          final List<FeedModel> searchFeedList = ref!.read(searchProvider.notifier).response;
          searchFeedList.removeWhere((element) => element.id == feed?.id);
          ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
        } else if (feedType == FeedType.DETAILS) {
          NavigationService.popNavigate();
        }
        NavigationService.popNavigate();
      } else {
        state = const FeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FeedErrorState();
    }
  }

  Future saveFeed(int feedId, FeedType feedType) async {
    var requestBody = {'feed_id': feedId};
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.saveFeed, requestBody),
      );
      if (responseBody != null) {
        if (feedType == FeedType.HOME) {
          final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
          final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;

          FeedModel? isInWorldFeedList = worldFeedList.firstWhereOrNull((element) => element.id == feedId);
          FeedModel? isInPersonalFeedList = personalFeedList.firstWhereOrNull((element) => element.id == feedId);

          if (isInWorldFeedList != null) {
            await save(worldFeedList, feedId);
            ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
          }
          if (isInPersonalFeedList != null) {
            await save(personalFeedList, feedId);
            ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
          }
        } else if (feedType == FeedType.PROFILE) {
          final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
          final List<FeedModel>? userProfileFeedList = ref!.read(userProfileFeedProvider.notifier).userProfileFeedList?.feedData;

          FeedModel? isInMyProfileFeedList = myProfileFeedList?.firstWhereOrNull((element) => element.id == feedId);
          FeedModel? isInUserProfileFeedList = userProfileFeedList?.firstWhereOrNull((element) => element.id == feedId);

          if (isInMyProfileFeedList != null) {
            await save(myProfileFeedList, feedId);
            ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList!);
          }

          if (isInUserProfileFeedList != null) {
            await save(userProfileFeedList, feedId);
            ref!.read(userProfileFeedProvider.notifier).updateSuccessState(userProfileFeedList!);
          }
        } else if (feedType == FeedType.GROUP) {
          final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
          await save(groupFeedList, feedId);
          ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList!);
        } else if (feedType == FeedType.EVENT) {
          final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;
          await save(eventFeedList, feedId);
          ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList!);
        } else if (feedType == FeedType.PAGE) {
          final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
          await save(pageFeedList, feedId);
          ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList!);
        } else if (feedType == FeedType.SAVED) {
          final List<FeedModel>? savePostFeedList = ref!.read(savedPostsProvider.notifier).savedPostsModel?.feedData?.data;
          await save(savePostFeedList, feedId);
          ref!.read(pageFeedProvider.notifier).updateSuccessState(savePostFeedList!);
        } else if (feedType == FeedType.DETAILS) {
          final FeedModel? feedDetails = ref!.read(feedDetailsProvider.notifier).feedDetailsModel;

          if (feedDetails?.savedPosts == null) {
            feedDetails?.savedPosts = SavedPosts.fromJson({"user_id": getIntAsync(USER_ID), "feed_id": feedId});
          } else {
            feedDetails?.savedPosts = null;
          }

          ref!.read(feedDetailsProvider.notifier).updateDetailsSuccessState(feedDetails);
        }
        toast('Post saved successfully', bgColor: KColor.green);
      }
    } catch (error, stackTrace) {
      print("saveFeed(): $error");
      print(stackTrace);
    }
  }

  Future unsaveFeed(int feedId, FeedType feedType) async {
    var requestBody = {'feed_id': feedId};
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.unsaveFeed, requestBody),
      );
      if (responseBody != null) {
        if (feedType == FeedType.HOME) {
          final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
          final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;

          FeedModel? isInWorldFeedList = worldFeedList.firstWhereOrNull((element) => element.id == feedId);
          FeedModel? isInPersonalFeedList = personalFeedList.firstWhereOrNull((element) => element.id == feedId);

          if (isInWorldFeedList != null) {
            await save(worldFeedList, feedId);
            ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
          }
          if (isInPersonalFeedList != null) {
            await save(personalFeedList, feedId);
            ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
          }
        } else if (feedType == FeedType.PROFILE) {
          final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
          final List<FeedModel>? userProfileFeedList = ref!.read(userProfileFeedProvider.notifier).userProfileFeedList?.feedData;

          FeedModel? isInMyProfileFeedList = myProfileFeedList!.firstWhereOrNull((element) => element.id == feedId);
          FeedModel? isInUserProfileFeedList = userProfileFeedList!.firstWhereOrNull((element) => element.id == feedId);

          if (isInMyProfileFeedList != null) {
            await save(myProfileFeedList, feedId);
            ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList);
          }

          if (isInUserProfileFeedList != null) {
            await save(userProfileFeedList, feedId);
            ref!.read(userProfileFeedProvider.notifier).updateSuccessState(userProfileFeedList);
          }
        } else if (feedType == FeedType.GROUP) {
          final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
          await save(groupFeedList, feedId);
          ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList!);
        } else if (feedType == FeedType.EVENT) {
          final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;
          await save(eventFeedList, feedId);
          ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList!);
        } else if (feedType == FeedType.PAGE) {
          final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
          await save(pageFeedList, feedId);
          ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList!);
        } else if (feedType == FeedType.SAVED) {
          final List<FeedModel>? savedFeedList = ref!.read(savedPostsProvider.notifier).savedPostsModel?.feedData?.data;
          await save(savedFeedList, feedId);
          savedFeedList!.removeWhere((element) => element.id == feedId);

          ref!.read(savedPostsProvider.notifier).updateSuccessState(savedFeedList);
        } else if (feedType == FeedType.DETAILS) {
          final FeedModel? feedDetails = ref!.read(feedDetailsProvider.notifier).feedDetailsModel;

          if (feedDetails?.savedPosts == null) {
            feedDetails?.savedPosts = SavedPosts.fromJson({"user_id": getIntAsync(USER_ID), "feed_id": feedId});
          } else {
            feedDetails?.savedPosts = null;
          }

          ref!.read(feedDetailsProvider.notifier).updateDetailsSuccessState(feedDetails);
        }
        toast('Post unsaved successfully', bgColor: KColor.green);
      }
    } catch (error, stackTrace) {
      print("unsaveFeed(): $error");
      print(stackTrace);
    }
  }

  Future likeFeed({int? feedId, FeedType? feedType, bool? isLike, String? reactionType, String? action}) async {
    /// Checking like tapped from which feed type, so as to update state there
    if (feedType == FeedType.HOME) {
      final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
      final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;

      print("personalFeedList");
      print(personalFeedList);

      FeedModel? isInWorldFeedList = worldFeedList.firstWhereOrNull((element) => element.id == feedId);
      FeedModel? isInPersonalFeedList = personalFeedList.firstWhereOrNull((element) => element.id == feedId);

      if (isInWorldFeedList != null) {
        await like(worldFeedList, feedId, reactionType, action);
        ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
      }
      if (isInPersonalFeedList != null) {
        await like(personalFeedList, feedId, reactionType, action);
        ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
      }
    } else if (feedType == FeedType.PROFILE) {
      final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList == null
          ? []
          : ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
      final List<FeedModel>? userProfileFeedList = ref!.read(userProfileFeedProvider.notifier).userProfileFeedList == null
          ? []
          : ref!.read(userProfileFeedProvider.notifier).userProfileFeedList?.feedData;

      FeedModel? isInMyProfileFeedList = myProfileFeedList!.firstWhereOrNull((element) => element.id == feedId);
      FeedModel? isInUserProfileFeedList = userProfileFeedList!.firstWhereOrNull((element) => element.id == feedId);

      if (isInMyProfileFeedList != null) {
        await like(myProfileFeedList, feedId, reactionType, action);
        ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList);
      }

      if (isInUserProfileFeedList != null) {
        await like(userProfileFeedList, feedId, reactionType, action);
        ref!.read(userProfileFeedProvider.notifier).updateSuccessState(userProfileFeedList);
      }
    } else if (feedType == FeedType.GROUP) {
      final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
      await like(groupFeedList, feedId, reactionType, action);
      ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList!);
    } else if (feedType == FeedType.EVENT) {
      final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;
      await like(eventFeedList, feedId, reactionType, action);
      ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList!);
    } else if (feedType == FeedType.PAGE) {
      final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
      await like(pageFeedList, feedId, reactionType, action);
      ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList!);
    } else if (feedType == FeedType.SAVED) {
      final List<FeedModel>? savedFeedList = ref!.read(savedPostsProvider.notifier).savedPostsModel?.feedData?.data;

      await like(savedFeedList, feedId, reactionType, action);
      ref!.read(savedPostsProvider.notifier).updateSuccessState(savedFeedList!);
    } else if (feedType == FeedType.SEARCH) {
      final List<FeedModel> searchFeedList = ref!.read(searchProvider.notifier).response;
      await like(searchFeedList, feedId, reactionType, action);
      ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
    } else if (feedType == FeedType.DETAILS) {
      final FeedModel? feedDetails = ref!.read(feedDetailsProvider.notifier).feedDetailsModel;

      /// My like reaction
      if (feedDetails?.like == null) {
        feedDetails?.likeCount += 1;
        feedDetails?.like = Like.fromJson({
          "user_id": getIntAsync(USER_ID),
          "feed_id": feedId,
          "reaction_type": reactionType,
        });

        feedDetails?.likeType?.removeWhere((element) => element.userId == getIntAsync(USER_ID));

        if (feedDetails!.likeType!.where((element) => element.reactionType == reactionType).isEmpty) {
          feedDetails.likeType!.add(LikeType.fromJson({
            "user_id": getIntAsync(USER_ID),
            "feed_id": feedId,
            "reaction_type": reactionType,
            "meta": {"total_likes": 1}
          }));
        } else {
          var feedLikeTypeIndex = feedDetails.likeType!.indexWhere((element) => element.reactionType == reactionType);
          feedDetails.likeType![feedLikeTypeIndex].meta!.totalLikes += 1;
        }
      }

      /// My reactions
      else if (action == 'update') {
        // print(' map((entry) => entry.meta).toList() bfr ====> ${feedDetails?.likeType!.map((entry) => entry.meta!.totalLikes).toList()}');

        /// If I'm updating my previously added reaction
        if (feedDetails!.like != null) {
          // print('feed like ! = null;');
          var prevReactionIndex = feedDetails.likeType!.indexWhere((element) => element.reactionType == feedDetails.like!.reactionType);
          if (prevReactionIndex != -1) {
            if (feedDetails.likeType![prevReactionIndex].meta!.totalLikes == 1) {
              feedDetails.likeType!.removeAt(prevReactionIndex);
            } else {
              feedDetails.likeType![prevReactionIndex].meta!.totalLikes -= 1;
            }
          }
        }

        /// Adding/Updating my reaction
        feedDetails.like = Like.fromJson({
          "user_id": getIntAsync(USER_ID),
          "feed_id": feedId,
          "reaction_type": reactionType,
        });

        /// Checking if my current reaction exists in like type array,
        ///  so as to increase the totalLike count for that reaction type,
        ///  which is needed for sorting according to reactionTypeCount
        var feedLikeTypes = feedDetails.likeType!.where((element) => element.reactionType == reactionType);

        /// If feed like type array is empty, we need to insert new like type object to it
        if (feedLikeTypes.isEmpty) {
          feedDetails.likeType!.add(LikeType.fromJson({
            "user_id": getIntAsync(USER_ID),
            "feed_id": feedId,
            "reaction_type": reactionType,
            "meta": {"total_likes": 1}
          }));
        } else {
          var feedLikeTypeIndex = feedDetails.likeType!.indexWhere((element) => element.reactionType == reactionType);
          feedDetails.likeType![feedLikeTypeIndex].meta!.totalLikes += 1;
        }
      }

      /// Removing like/reaction
      else {
        feedDetails!.likeCount -= 1;
        feedDetails.like = null;

        feedDetails.likeType?.removeWhere((element) => (element.userId == getIntAsync(USER_ID)) && (element.meta!.totalLikes == 1));
      }
      // print('feedDetails?.likeCount = ${feedDetails.likeCount}');
      // print('feedDetails?.like = ${feedDetails.like}');
      feedDetails.likeType!.sort(((a, b) => a.meta!.totalLikes.compareTo(b.meta!.totalLikes)));
      feedDetails.likeType = feedDetails.likeType!.reversed.toList();
      // print(' map((entry) => entry.meta).toList() ====> ${feedDetails.likeType!.map((entry) => entry.meta!.totalLikes).toList()}');

      ref!.read(feedDetailsProvider.notifier).updateDetailsSuccessState(feedDetails);
    }
    var requestBody = {
      'feed_id': feedId,
      'isLike': isLike,
      'reaction_type': reactionType,
      'action': action,
    };

    try {
      await Network.handleResponse(await Network.postRequest(API.likeFeed, requestBody));
    } catch (e, stackTrace) {
      print(e.toString());
      print(stackTrace);
    }
  }

  like(List<FeedModel>? feedList, feedId, reactionType, action) {
    // print("feedId");
    // print(feedId);
    int index = feedList!.indexWhere((element) => element.id == feedId);
    // print("index");
    // print(index);

    if (index != -1) {
      if (feedList[index].like == null) {
        feedList[index].likeCount += 1;
        feedList[index].like = Like.fromJson({
          "user_id": getIntAsync(USER_ID),
          "feed_id": feedId,
          "reaction_type": reactionType,
        });
        // print('feedList[index].likeType bfr = ${feedList[index].likeType}');
        feedList[index].likeType!.removeWhere((element) => element.userId == getIntAsync(USER_ID));
        // print('feedList[index].likeType aftr = ${feedList[index].likeType}');

        if (feedList[index].likeType!.where((element) => element.reactionType == reactionType).isEmpty) {
          feedList[index].likeType!.add(LikeType.fromJson({
                "user_id": getIntAsync(USER_ID),
                "feed_id": feedId,
                "reaction_type": reactionType,
                "meta": {"total_likes": 1}
              }));
        } else {
          var feedLikeTypeIndex = feedList[index].likeType!.indexWhere((element) => element.reactionType == reactionType);
          feedList[index].likeType![feedLikeTypeIndex].meta!.totalLikes += 1;
        }
      } else if (action == 'update') {
        /// If I'm updating my previously added reaction
        if (feedList[index].like != null) {
          // print('feed like ! = null;');
          var prevReactionIndex = feedList[index].likeType!.indexWhere((element) => element.reactionType == feedList[index].like!.reactionType);
          // if (prevReactionIndex != -1) feedList[index].likeType![prevReactionIndex].meta!.totalLikes -= 1;
          if (prevReactionIndex != -1) {
            if (feedList[index].likeType![prevReactionIndex].meta!.totalLikes == 1) {
              feedList[index].likeType!.removeAt(prevReactionIndex);
            } else {
              feedList[index].likeType![prevReactionIndex].meta!.totalLikes -= 1;
            }
          }
        }

        feedList[index].like = Like.fromJson({
          "user_id": getIntAsync(USER_ID),
          "feed_id": feedId,
          "reaction_type": reactionType,
        });

        // feedList[index].likeType!.removeWhere((element) => element.userId == getIntAsync(USER_ID));
        if (feedList[index].likeType!.where((element) => element.reactionType == reactionType).isEmpty) {
          feedList[index].likeType!.add(LikeType.fromJson({
                "user_id": getIntAsync(USER_ID),
                "feed_id": feedId,
                "reaction_type": reactionType,
                "meta": {"total_likes": 1}
              }));
        } else {
          var feedLikeTypeIndex = feedList[index].likeType!.indexWhere((element) => element.reactionType == reactionType);
          feedList[index].likeType![feedLikeTypeIndex].meta!.totalLikes += 1;
        }
      } else {
        feedList[index].likeCount -= 1;
        feedList[index].like = null;
        feedList[index].likeType!.removeWhere((element) => (element.userId == getIntAsync(USER_ID)) && (element.meta!.totalLikes == 1));
      }
      // print('feedDetails?.likeCount = ${feedList[index].likeCount}');
      // print('feedDetails?.like = ${feedList[index].like}');

      feedList[index].likeType!.sort(((a, b) => a.meta!.totalLikes.compareTo(b.meta!.totalLikes)));
      feedList[index].likeType = feedList[index].likeType!.reversed.toList();
      // print(' map((entry) => entry.meta).toList() ====> ${feedList[index].likeType!.map((entry) => entry.meta!.totalLikes).toList()}');
    }
  }

  save(feedList, feedId) {
    int index = feedList.indexWhere((element) => element.id == feedId);
    if (index != 1) {
      if (feedList[index].savedPosts == null) {
        feedList[index].savedPosts = SavedPosts.fromJson({"user_id": getIntAsync(USER_ID), "feed_id": feedId});
      } else {
        feedList[index].savedPosts = null;
      }
    }
  }

  /// poll logic
  Future addPollOption({required String text, required int pollId, required FeedType feedType}) async {
    dynamic responseBody;

    var requestBody = {'poll_id': pollId, 'text': text};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.addPollOption, requestBody));

      if (responseBody != null) {
        PollOption option = PollOption.fromJson(responseBody);

        if (feedType == FeedType.HOME) {
          final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
          final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;
          FeedModel? isInWorldFeed = worldFeedList.firstWhereOrNull((element) => element.pollId == pollId);
          FeedModel? isInPersonalFeed = personalFeedList.firstWhereOrNull((element) => element.pollId == pollId);

          if (isInWorldFeed != null) {
            isInWorldFeed.poll!.pollOptions!.add(option);
            ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
          }
          if (isInPersonalFeed != null) {
            isInPersonalFeed.poll!.pollOptions!.add(option);
            ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
          }
        } else if (feedType == FeedType.PROFILE) {
          final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList == null
              ? []
              : ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
          final List<FeedModel>? userProfileFeedList = ref!.read(userProfileFeedProvider.notifier).userProfileFeedList == null
              ? []
              : ref!.read(userProfileFeedProvider.notifier).userProfileFeedList?.feedData;

          FeedModel? isInMyProfileFeed = myProfileFeedList!.firstWhereOrNull((element) => element.id == pollId);
          FeedModel? isInUserProfileFeed = userProfileFeedList!.firstWhereOrNull((element) => element.id == pollId);

          if (isInMyProfileFeed != null) {
            isInMyProfileFeed.poll!.pollOptions!.add(option);
            ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList);
          }

          if (isInUserProfileFeed != null) {
            isInUserProfileFeed.poll!.pollOptions!.add(option);
            ref!.read(userProfileFeedProvider.notifier).updateSuccessState(userProfileFeedList);
          }
        } else if (feedType == FeedType.GROUP) {
          final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
          FeedModel? groupFeed = groupFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

          if (groupFeed != null) {
            groupFeed.poll!.pollOptions!.add(option);
            ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
          }
        } else if (feedType == FeedType.EVENT) {
          final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;

          FeedModel? eventFeed = eventFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

          if (eventFeed != null) {
            eventFeed.poll!.pollOptions!.add(option);
            ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList);
          }
        } else if (feedType == FeedType.PAGE) {
          final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
          FeedModel? pageFeed = pageFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

          if (pageFeed != null) {
            pageFeed.poll!.pollOptions!.add(option);
            ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);
          }
        } else if (feedType == FeedType.SAVED) {
          final List<FeedModel>? savedFeedList = ref!.read(savedPostsProvider.notifier).savedPostsModel?.feedData?.data;

          FeedModel? savedPosts = savedFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

          if (savedPosts != null) {
            savedPosts.poll!.pollOptions!.add(option);
            ref!.read(savedPostsProvider.notifier).updateSuccessState(savedFeedList);
          }
        } else if (feedType == FeedType.SEARCH) {
          final List<FeedModel> searchFeedList = ref!.read(searchProvider.notifier).response;

          FeedModel? searchFeed = searchFeedList.firstWhereOrNull((element) => element.pollId == pollId);

          if (searchFeed != null) {
            searchFeed.poll!.pollOptions!.add(option);
            ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
          }
        } else if (feedType == FeedType.DETAILS) {
          final FeedModel? feedDetails = ref!.read(feedDetailsProvider.notifier).feedDetailsModel;

          if (feedDetails != null) {
            feedDetails.poll!.pollOptions!.add(option);
            ref!.read(feedDetailsProvider.notifier).updateDetailsSuccessState(feedDetails);
          }
        }
        NavigationService.popNavigate();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future deletePollOption({required int optionId, required int pollId, required FeedType feedType}) async {
    dynamic responseBody;

    var requestBody = {'poll_id': pollId, 'option_id': optionId};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deletePollOption, requestBody));

      if (responseBody != null) {
        if (feedType == FeedType.HOME) {
          final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
          final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;
          FeedModel? isInWorldFeed = worldFeedList.firstWhereOrNull((element) => element.pollId == pollId);
          FeedModel? isInPersonalFeed = personalFeedList.firstWhereOrNull((element) => element.pollId == pollId);

          if (isInWorldFeed != null) {
            isInWorldFeed.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
          }
          if (isInPersonalFeed != null) {
            isInPersonalFeed.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
          }
        } else if (feedType == FeedType.PROFILE) {
          final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList == null
              ? []
              : ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
          final List<FeedModel>? userProfileFeedList = ref!.read(userProfileFeedProvider.notifier).userProfileFeedList == null
              ? []
              : ref!.read(userProfileFeedProvider.notifier).userProfileFeedList?.feedData;

          FeedModel? isInMyProfileFeed = myProfileFeedList!.firstWhereOrNull((element) => element.id == pollId);
          FeedModel? isInUserProfileFeed = userProfileFeedList!.firstWhereOrNull((element) => element.id == pollId);

          if (isInMyProfileFeed != null) {
            isInMyProfileFeed.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList);
          }

          if (isInUserProfileFeed != null) {
            isInUserProfileFeed.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(userProfileFeedProvider.notifier).updateSuccessState(userProfileFeedList);
          }
        } else if (feedType == FeedType.GROUP) {
          final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
          FeedModel? groupFeed = groupFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

          if (groupFeed != null) {
            groupFeed.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
          }
        } else if (feedType == FeedType.EVENT) {
          final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;

          FeedModel? eventFeed = eventFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

          if (eventFeed != null) {
            eventFeed.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList);
          }
        } else if (feedType == FeedType.PAGE) {
          final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
          FeedModel? pageFeed = pageFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

          if (pageFeed != null) {
            pageFeed.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);
          }
        } else if (feedType == FeedType.SAVED) {
          final List<FeedModel>? savedFeedList = ref!.read(savedPostsProvider.notifier).savedPostsModel?.feedData?.data;

          FeedModel? savedPosts = savedFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

          if (savedPosts != null) {
            savedPosts.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(savedPostsProvider.notifier).updateSuccessState(savedFeedList);
          }
        } else if (feedType == FeedType.SEARCH) {
          final List<FeedModel> searchFeedList = ref!.read(searchProvider.notifier).response;

          FeedModel? searchFeed = searchFeedList.firstWhereOrNull((element) => element.pollId == pollId);

          if (searchFeed != null) {
            searchFeed.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
          }
        } else if (feedType == FeedType.DETAILS) {
          final FeedModel? feedDetails = ref!.read(feedDetailsProvider.notifier).feedDetailsModel;

          if (feedDetails != null) {
            feedDetails.poll!.pollOptions!.removeWhere((element) => element.id == optionId);
            ref!.read(feedDetailsProvider.notifier).updateDetailsSuccessState(feedDetails);
          }
        }
        NavigationService.popNavigate();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  addVoteLocally(
      {required int feedId,
      required int optionId,
      required int pollId,
      required FeedType feedType,
      required IsVotedOne? vote,
      bool multipleSelect = false}) {
    print("feedType");
    print(feedType);

    if (feedType == FeedType.HOME) {
      final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
      final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;
      FeedModel? isInWorldFeed = worldFeedList.firstWhereOrNull((element) => element.pollId == pollId);
      FeedModel? isInPersonalFeed = personalFeedList.firstWhereOrNull((element) => element.pollId == pollId);

      if (isInWorldFeed != null) {
        int index = isInWorldFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        isInWorldFeed.poll!.pollOptions![index].isVoted = vote;
        isInWorldFeed.poll!.isVotedOne = vote;

        if (vote != null) {
          isInWorldFeed.poll!.pollOptions![index].isVoted = vote;
          isInWorldFeed.poll!.pollOptions![index].voteOption?.add(vote);
          isInWorldFeed.poll!.pollOptions![index].totalVote = isInWorldFeed.poll!.pollOptions![index].totalVote + 1;
        } else {
          isInWorldFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (isInWorldFeed.poll!.pollOptions![index].totalVote > 0) {
            isInWorldFeed.poll!.pollOptions![index].totalVote = isInWorldFeed.poll!.pollOptions![index].totalVote - 1;
          }
        }
        int feedIndex = worldFeedList.indexWhere((element) => element.id == feedId);
        if (feedIndex != -1) {
          if (worldFeedList[feedIndex].share != null) {
            worldFeedList[feedIndex].share = isInWorldFeed;
          }
        }

        ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
      }
      if (isInPersonalFeed != null) {
        int index = isInPersonalFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        isInPersonalFeed.poll!.pollOptions![index].isVoted = vote;
        isInPersonalFeed.poll!.isVotedOne = vote;

        if (vote != null) {
          isInPersonalFeed.poll!.pollOptions![index].voteOption?.add(vote);
          isInPersonalFeed.poll!.pollOptions![index].totalVote = isInPersonalFeed.poll!.pollOptions![index].totalVote + 1;
        } else {
          isInPersonalFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (isInPersonalFeed.poll!.pollOptions![index].totalVote > 0) {
            isInPersonalFeed.poll!.pollOptions![index].totalVote = isInPersonalFeed.poll!.pollOptions![index].totalVote - 1;
          }
        }

        int feedIndex = personalFeedList.indexWhere((element) => element.id == feedId);
        if (feedIndex != -1) {
          if (personalFeedList[feedIndex].share != null) {
            personalFeedList[feedIndex].share = isInPersonalFeed;
          }
        }
        ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
      }
    } else if (feedType == FeedType.PROFILE) {
      final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList == null
          ? []
          : ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
      final List<FeedModel>? userProfileFeedList = ref!.read(userProfileFeedProvider.notifier).userProfileFeedList == null
          ? []
          : ref!.read(userProfileFeedProvider.notifier).userProfileFeedList?.feedData;
      print("userProfileFeedList data");
      print(userProfileFeedList);
      FeedModel? isInMyProfileFeed = myProfileFeedList!.firstWhereOrNull((element) => element.pollId == pollId);
      FeedModel? isInUserProfileFeed = userProfileFeedList!.firstWhereOrNull((element) => element.pollId == pollId);
      print("isInUserProfileFeed data");
      print(isInUserProfileFeed);
      if (isInMyProfileFeed != null) {
        isInMyProfileFeed.poll!.isVotedOne = vote;
        int index = isInMyProfileFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        isInMyProfileFeed.poll!.pollOptions![index].isVoted = vote;
        if (vote != null) {
          isInMyProfileFeed.poll!.pollOptions![index].voteOption?.add(vote);
          isInMyProfileFeed.poll!.pollOptions![index].totalVote = isInMyProfileFeed.poll!.pollOptions![index].totalVote + 1;
        } else {
          isInMyProfileFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (isInMyProfileFeed.poll!.pollOptions![index].totalVote > 0) {
            isInMyProfileFeed.poll!.pollOptions![index].totalVote = isInMyProfileFeed.poll!.pollOptions![index].totalVote - 1;
          }
        }

        int feedIndex = myProfileFeedList.indexWhere((element) => element.id == feedId);
        if (feedIndex != -1) {
          if (myProfileFeedList[feedIndex].share != null) {
            myProfileFeedList[feedIndex].share = isInMyProfileFeed;
          }
        }
        ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList);
      }

      if (isInUserProfileFeed != null) {
        print("isInUserProfileFeed");
        isInUserProfileFeed.poll!.isVotedOne = vote;
        int index = isInUserProfileFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        isInUserProfileFeed.poll!.pollOptions![index].isVoted = vote;
        if (vote != null) {
          isInUserProfileFeed.poll!.pollOptions![index].voteOption?.add(vote);
          isInUserProfileFeed.poll!.pollOptions![index].totalVote = isInUserProfileFeed.poll!.pollOptions![index].totalVote + 1;
        } else {
          isInUserProfileFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (isInUserProfileFeed.poll!.pollOptions![index].totalVote > 0) {
            isInUserProfileFeed.poll!.pollOptions![index].totalVote = isInUserProfileFeed.poll!.pollOptions![index].totalVote - 1;
          }
        }
        int feedIndex = userProfileFeedList.indexWhere((element) => element.id == feedId);
        if (feedIndex != -1) {
          if (userProfileFeedList[feedIndex].share != null) {
            userProfileFeedList[feedIndex].share = isInUserProfileFeed;
          }
        }
        ref!.read(userProfileFeedProvider.notifier).updateSuccessState(userProfileFeedList);
      }
    } else if (feedType == FeedType.GROUP) {
      final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
      FeedModel? groupFeed = groupFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

      if (groupFeed != null) {
        groupFeed.poll!.isVotedOne = vote;
        int index = groupFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        groupFeed.poll!.pollOptions![index].isVoted = vote;
        if (vote != null) {
          groupFeed.poll!.pollOptions![index].voteOption?.add(vote);
          groupFeed.poll!.pollOptions![index].totalVote = groupFeed.poll!.pollOptions![index].totalVote + 1;
        } else {
          groupFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (groupFeed.poll!.pollOptions![index].totalVote > 0) {
            groupFeed.poll!.pollOptions![index].totalVote = groupFeed.poll!.pollOptions![index].totalVote - 1;
          }
        }
        int feedIndex = groupFeedList.indexWhere((element) => element.id == feedId);
        if (feedIndex != -1) {
          if (groupFeedList[feedIndex].share != null) {
            groupFeedList[feedIndex].share = groupFeed;
          }
        }
        ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
      }
    } else if (feedType == FeedType.EVENT) {
      final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;

      FeedModel? eventFeed = eventFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

      if (eventFeed != null) {
        eventFeed.poll!.isVotedOne = vote;
        int index = eventFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        eventFeed.poll!.pollOptions![index].isVoted = vote;
        if (vote != null) {
          eventFeed.poll!.pollOptions![index].voteOption?.add(vote);
          eventFeed.poll!.pollOptions![index].totalVote = eventFeed.poll!.pollOptions![index].totalVote + 1;
        } else {
          eventFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (eventFeed.poll!.pollOptions![index].totalVote > 0) {
            eventFeed.poll!.pollOptions![index].totalVote = eventFeed.poll!.pollOptions![index].totalVote - 1;
          }
        }

        int feedIndex = eventFeedList.indexWhere((element) => element.id == feedId);
        if (feedIndex != -1) {
          if (eventFeedList[feedIndex].share != null) {
            eventFeedList[feedIndex].share = eventFeed;
          }
        }
        ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList);
      }
    } else if (feedType == FeedType.PAGE) {
      final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
      FeedModel? pageFeed = pageFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

      if (pageFeed != null) {
        pageFeed.poll!.isVotedOne = vote;
        int index = pageFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        pageFeed.poll!.pollOptions![index].isVoted = vote;
        if (vote != null) {
          pageFeed.poll!.pollOptions![index].voteOption?.add(vote);
          pageFeed.poll!.pollOptions![index].totalVote = pageFeed.poll!.pollOptions![index].totalVote + 1;
        } else {
          pageFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (pageFeed.poll!.pollOptions![index].totalVote > 0) {
            pageFeed.poll!.pollOptions![index].totalVote = pageFeed.poll!.pollOptions![index].totalVote - 1;
          }
        }

        int feedIndex = pageFeedList.indexWhere((element) => element.id == feedId);
        if (feedIndex != -1) {
          if (pageFeedList[feedIndex].share != null) {
            pageFeedList[feedIndex].share = pageFeed;
          }
        }
        ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);
      }
    } else if (feedType == FeedType.SAVED) {
      final List<FeedModel>? savedFeedList = ref!.read(savedPostsProvider.notifier).savedPostsModel?.feedData?.data;

      FeedModel? savedPosts = savedFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

      if (savedPosts != null) {
        savedPosts.poll!.isVotedOne = vote;
        int index = savedPosts.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        savedPosts.poll!.pollOptions![index].isVoted = vote;
        if (vote != null) {
          savedPosts.poll!.pollOptions![index].voteOption?.add(vote);
          savedPosts.poll!.pollOptions![index].totalVote = savedPosts.poll!.pollOptions![index].totalVote + 1;
        } else {
          savedPosts.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (savedPosts.poll!.pollOptions![index].totalVote > 0) {
            savedPosts.poll!.pollOptions![index].totalVote = savedPosts.poll!.pollOptions![index].totalVote - 1;
          }
        }

        int feedIndex = savedFeedList.indexWhere((element) => element.id == feedId);
        if (feedIndex != -1) {
          if (savedFeedList[feedIndex].share != null) {
            savedFeedList[feedIndex].share = savedPosts;
          }
        }
        ref!.read(savedPostsProvider.notifier).updateSuccessState(savedFeedList);
      }
    } else if (feedType == FeedType.SEARCH) {
      final List<FeedModel> searchFeedList = ref!.read(searchProvider.notifier).response;

      FeedModel? searchFeed = searchFeedList.firstWhereOrNull((element) => element.pollId == pollId);

      if (searchFeed != null) {
        searchFeed.poll!.isVotedOne = vote;
        int index = searchFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        searchFeed.poll!.pollOptions![index].isVoted = vote;
        if (vote != null) {
          searchFeed.poll!.pollOptions![index].voteOption?.add(vote);
          searchFeed.poll!.pollOptions![index].totalVote = searchFeed.poll!.pollOptions![index].totalVote + 1;
        } else {
          searchFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (searchFeed.poll!.pollOptions![index].totalVote > 0) {
            searchFeed.poll!.pollOptions![index].totalVote = searchFeed.poll!.pollOptions![index].totalVote - 1;
          }
        }

        int feedIndex = searchFeedList.indexWhere((element) => element.id == feedId);
        if (feedIndex != -1) {
          if (searchFeedList[feedIndex].share != null) {
            searchFeedList[feedIndex].share = searchFeed;
          }
        }
        ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
      }
    } else if (feedType == FeedType.DETAILS) {
      final FeedModel? feedDetails = ref!.read(feedDetailsProvider.notifier).feedDetailsModel;

      if (feedDetails != null) {
        if (feedDetails.pollId != null) {
          feedDetails.poll!.isVotedOne = vote;
          int index = feedDetails.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
          feedDetails.poll!.pollOptions![index].isVoted = vote;
          if (vote != null) {
            feedDetails.poll!.pollOptions![index].voteOption?.add(vote);
            feedDetails.poll!.pollOptions![index].totalVote = feedDetails.poll!.pollOptions![index].totalVote + 1;
          } else {
            feedDetails.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
            if (feedDetails.poll!.pollOptions![index].totalVote > 0) {
              feedDetails.poll!.pollOptions![index].totalVote = feedDetails.poll!.pollOptions![index].totalVote - 1;
            }
          }
        }
        if (feedDetails.share?.pollId != null) {
          feedDetails.share?.poll!.isVotedOne = vote;
          int index = feedDetails.share!.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
          feedDetails.share?.poll!.pollOptions![index].isVoted = vote;
          if (vote != null) {
            feedDetails.share?.poll!.pollOptions![index].voteOption?.add(vote);
            feedDetails.share?.poll!.pollOptions![index].totalVote = feedDetails.share!.poll!.pollOptions![index].totalVote + 1;
          } else {
            feedDetails.share?.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
            if (feedDetails.share!.poll!.pollOptions![index].totalVote > 0) {
              feedDetails.share?.poll!.pollOptions![index].totalVote = feedDetails.share!.poll!.pollOptions![index].totalVote - 1;
            }
          }
        }
        ref!.read(feedDetailsProvider.notifier).updateDetailsSuccessState(feedDetails);
      }
    }
  }

  removeVoteLocally({required int feedId, required int optionId, required int pollId, required FeedType feedType, required IsVotedOne? vote}) {
    if (feedType == FeedType.HOME) {
      final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
      final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;
      FeedModel? isInWorldFeed = worldFeedList.firstWhereOrNull((element) => element.pollId == pollId);
      FeedModel? isInPersonalFeed = personalFeedList.firstWhereOrNull((element) => element.pollId == pollId);

      if (isInWorldFeed != null) {
        int index = isInWorldFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        if (index != -1) {
          isInWorldFeed.poll!.pollOptions![index].isVoted = null;
          isInWorldFeed.poll!.isVotedOne = vote;
          print(isInWorldFeed.pollId);
          print(isInWorldFeed.poll!.pollOptions![index].isVoted);
          isInWorldFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (isInWorldFeed.poll!.pollOptions![index].totalVote > 0) {
            isInWorldFeed.poll!.pollOptions![index].totalVote = isInWorldFeed.poll!.pollOptions![index].totalVote - 1;
          }
          int feedIndex = worldFeedList.indexWhere((element) => element.id == feedId);
          if (feedIndex != -1) {
            if (worldFeedList[feedIndex].share != null) {
              worldFeedList[feedIndex].share = isInWorldFeed;
            }
          }

          ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
        }
      }
      if (isInPersonalFeed != null) {
        int index = isInPersonalFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        if (index != -1) {
          isInPersonalFeed.poll!.pollOptions![index].isVoted = null;
          isInPersonalFeed.poll!.isVotedOne = vote;
          isInPersonalFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (isInPersonalFeed.poll!.pollOptions![index].totalVote > 0) {
            isInPersonalFeed.poll!.pollOptions![index].totalVote = isInPersonalFeed.poll!.pollOptions![index].totalVote - 1;
          }
          int feedIndex = personalFeedList.indexWhere((element) => element.id == feedId);
          if (feedIndex != -1) {
            if (personalFeedList[feedIndex].share != null) {
              personalFeedList[feedIndex].share = isInPersonalFeed;
            }
          }
          ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
        }
      }
    } else if (feedType == FeedType.PROFILE) {
      final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList == null
          ? []
          : ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
      final List<FeedModel>? userProfileFeedList = ref!.read(userProfileFeedProvider.notifier).userProfileFeedList == null
          ? []
          : ref!.read(userProfileFeedProvider.notifier).userProfileFeedList?.feedData;

      FeedModel? isInMyProfileFeed = myProfileFeedList!.firstWhereOrNull((element) => element.pollId == pollId);
      FeedModel? isInUserProfileFeed = userProfileFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

      if (isInMyProfileFeed != null) {
        isInMyProfileFeed.poll!.isVotedOne = vote;
        int index = isInMyProfileFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        if (index != -1) {
          isInMyProfileFeed.poll!.pollOptions![index].isVoted = null;

          isInMyProfileFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (isInMyProfileFeed.poll!.pollOptions![index].totalVote > 0) {
            isInMyProfileFeed.poll!.pollOptions![index].totalVote = isInMyProfileFeed.poll!.pollOptions![index].totalVote - 1;
          }

          int feedIndex = myProfileFeedList.indexWhere((element) => element.id == feedId);
          if (feedIndex != -1) {
            if (myProfileFeedList[feedIndex].share != null) {
              myProfileFeedList[feedIndex].share = isInMyProfileFeed;
            }
          }

          ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList);
        }
      }

      if (isInUserProfileFeed != null) {
        isInUserProfileFeed.poll!.isVotedOne = vote;
        int index = isInUserProfileFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        if (index != -1) {
          isInUserProfileFeed.poll!.pollOptions![index].isVoted = null;

          isInUserProfileFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (isInUserProfileFeed.poll!.pollOptions![index].totalVote > 0) {
            isInUserProfileFeed.poll!.pollOptions![index].totalVote = isInUserProfileFeed.poll!.pollOptions![index].totalVote - 1;
          }
          int feedIndex = userProfileFeedList.indexWhere((element) => element.id == feedId);
          if (feedIndex != -1) {
            if (userProfileFeedList[feedIndex].share != null) {
              userProfileFeedList[feedIndex].share = isInMyProfileFeed;
            }
          }
          ref!.read(userProfileFeedProvider.notifier).updateSuccessState(userProfileFeedList);
        }
      }
    } else if (feedType == FeedType.GROUP) {
      final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
      FeedModel? groupFeed = groupFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

      if (groupFeed != null) {
        groupFeed.poll!.isVotedOne = vote;
        int index = groupFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        if (index != -1) {
          groupFeed.poll!.pollOptions![index].isVoted = null;

          groupFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (groupFeed.poll!.pollOptions![index].totalVote > 0) {
            groupFeed.poll!.pollOptions![index].totalVote = groupFeed.poll!.pollOptions![index].totalVote - 1;
          }
          int feedIndex = groupFeedList.indexWhere((element) => element.id == feedId);
          if (feedIndex != -1) {
            if (groupFeedList[feedIndex].share != null) {
              groupFeedList[feedIndex].share = groupFeed;
            }
          }
          ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
        }
      }
    } else if (feedType == FeedType.EVENT) {
      final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;

      FeedModel? eventFeed = eventFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

      if (eventFeed != null) {
        eventFeed.poll!.isVotedOne = vote;
        int index = eventFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        if (index != -1) {
          eventFeed.poll!.pollOptions![index].isVoted = null;

          eventFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (eventFeed.poll!.pollOptions![index].totalVote > 0) {
            eventFeed.poll!.pollOptions![index].totalVote = eventFeed.poll!.pollOptions![index].totalVote - 1;
          }

          int feedIndex = eventFeedList.indexWhere((element) => element.id == feedId);
          if (feedIndex != -1) {
            if (eventFeedList[feedIndex].share != null) {
              eventFeedList[feedIndex].share = eventFeed;
            }
          }

          ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList);
        }
      }
    } else if (feedType == FeedType.PAGE) {
      final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
      FeedModel? pageFeed = pageFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

      if (pageFeed != null) {
        pageFeed.poll!.isVotedOne = vote;
        int index = pageFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        if (index != -1) {
          pageFeed.poll!.pollOptions![index].isVoted = null;

          pageFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (pageFeed.poll!.pollOptions![index].totalVote > 0) {
            pageFeed.poll!.pollOptions![index].totalVote = pageFeed.poll!.pollOptions![index].totalVote - 1;
          }

          int feedIndex = pageFeedList.indexWhere((element) => element.id == feedId);
          if (feedIndex != -1) {
            if (pageFeedList[feedIndex].share != null) {
              pageFeedList[feedIndex].share = pageFeed;
            }
          }

          ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);
        }
      }
    } else if (feedType == FeedType.SAVED) {
      final List<FeedModel>? savedFeedList = ref!.read(savedPostsProvider.notifier).savedPostsModel?.feedData?.data;

      FeedModel? savedPosts = savedFeedList!.firstWhereOrNull((element) => element.pollId == pollId);

      if (savedPosts != null) {
        savedPosts.poll!.isVotedOne = vote;
        int index = savedPosts.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        if (index != -1) {
          savedPosts.poll!.pollOptions![index].isVoted = null;

          savedPosts.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (savedPosts.poll!.pollOptions![index].totalVote > 0) {
            savedPosts.poll!.pollOptions![index].totalVote = savedPosts.poll!.pollOptions![index].totalVote - 1;
          }

          int feedIndex = savedFeedList.indexWhere((element) => element.id == feedId);
          if (feedIndex != -1) {
            if (savedFeedList[feedIndex].share != null) {
              savedFeedList[feedIndex].share = savedPosts;
            }
          }

          ref!.read(savedPostsProvider.notifier).updateSuccessState(savedFeedList);
        }
      }
    } else if (feedType == FeedType.SEARCH) {
      final List<FeedModel> searchFeedList = ref!.read(searchProvider.notifier).response;

      FeedModel? searchFeed = searchFeedList.firstWhereOrNull((element) => element.pollId == pollId);

      if (searchFeed != null) {
        searchFeed.poll!.isVotedOne = vote;
        int index = searchFeed.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
        if (index != -1) {
          searchFeed.poll!.pollOptions![index].isVoted = null;

          searchFeed.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
          if (searchFeed.poll!.pollOptions![index].totalVote > 0) {
            searchFeed.poll!.pollOptions![index].totalVote = searchFeed.poll!.pollOptions![index].totalVote - 1;
          }

          int feedIndex = searchFeedList.indexWhere((element) => element.id == feedId);
          if (feedIndex != -1) {
            if (searchFeedList[feedIndex].share != null) {
              searchFeedList[feedIndex].share = searchFeed;
            }
          }

          ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
        }
      }
    } else if (feedType == FeedType.DETAILS) {
      final FeedModel? feedDetails = ref!.read(feedDetailsProvider.notifier).feedDetailsModel;

      if (feedDetails != null) {
        print(feedDetails.id);

        if (feedDetails.pollId != null) {
          feedDetails.poll!.isVotedOne = vote;
          int index = feedDetails.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
          if (index != -1) {
            feedDetails.poll!.pollOptions![index].isVoted = null;

            feedDetails.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
            if (feedDetails.poll!.pollOptions![index].totalVote > 0) {
              feedDetails.poll!.pollOptions![index].totalVote = feedDetails.poll!.pollOptions![index].totalVote - 1;
            }
          }
        }
        if (feedDetails.share?.pollId != null) {
          feedDetails.share?.poll!.isVotedOne = vote;
          int index = feedDetails.share!.poll!.pollOptions!.indexWhere((element) => element.id == optionId);
          if (index != -1) {
            feedDetails.share?.poll!.pollOptions![index].isVoted = null;

            feedDetails.share?.poll!.pollOptions![index].voteOption?.removeWhere((element) => element.userId == getIntAsync(USER_ID));
            if (feedDetails.share!.poll!.pollOptions![index].totalVote > 0) {
              feedDetails.share!.poll!.pollOptions![index].totalVote = feedDetails.share!.poll!.pollOptions![index].totalVote - 1;
            }
          }
        }

        ref!.read(feedDetailsProvider.notifier).updateDetailsSuccessState(feedDetails);
      }
    }
  }

  Future addVoteOption(
      {required int feedId,
      required int optionId,
      required int pollId,
      required FeedType feedType,
      required int mutipleOption,
      required bool isVote,
      bool isVotePrev = false,
      int? prevVoteId}) async {
    IsVotedOne? vote;
    if (isVote) {
      vote = IsVotedOne(
          pollId: pollId,
          optionId: optionId,
          userId: getIntAsync(USER_ID),
          user: IsVotedOneUser(
            id: getIntAsync(USER_ID),
            firstName: ref!.read(userProvider.notifier).userData?.user?.firstName,
            lastName: ref!.read(userProvider.notifier).userData?.user?.lastName,
            username: ref!.read(userProvider.notifier).userData?.user?.username,
            profilePic: ref!.read(userProvider.notifier).userData?.user?.profilePic,
          ));
    }

    if (mutipleOption == 0) {
      removeVoteLocally(feedId: feedId, pollId: pollId, optionId: prevVoteId ?? -1, feedType: feedType, vote: vote);
      if (!isVotePrev) {
        addVoteLocally(feedId: feedId, pollId: pollId, optionId: optionId, feedType: feedType, vote: vote);
      }
    } else {
      addVoteLocally(feedId: feedId, pollId: pollId, optionId: optionId, feedType: feedType, vote: vote);
    }

    var requestBody = {'poll_id': pollId, 'option_id': optionId};

    try {
      await Network.handleResponse(await Network.postRequest(API.addVoteOption, requestBody));
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }
}
