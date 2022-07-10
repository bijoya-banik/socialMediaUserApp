// ignore_for_file: unnecessary_null_comparison

import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/comment/state/comment_state.dart';
import 'package:buddyscripts/controller/event/event_feed_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/feed_details_controller.dart';
import 'package:buddyscripts/controller/feed/personal_feed_controller.dart';
import 'package:buddyscripts/controller/feed/world_feed_controller.dart';
import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/controller/page/page_feed_controller.dart';
import 'package:buddyscripts/controller/profile/my_profile_feed_controller.dart';
import 'package:buddyscripts/controller/profile/user_profile_feed_controller.dart';
import 'package:buddyscripts/controller/saved_posts/saved_post_controller.dart';
import 'package:buddyscripts/controller/search/search_controlller.dart';
import 'package:buddyscripts/models/feed/comment_model.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:collection/collection.dart';

final commentsProvider = StateNotifierProvider<CommentController, CommentState>((ref) {
  return CommentController(ref: ref);
});

class CommentController extends StateNotifier<CommentState> {
  final Ref? ref;
  CommentController({this.ref}) : super(const CommentInitialState());

  List<CommentModel> commentsModel = [];
  bool hasMoreComments = false;

  updateSuccessState(List<CommentModel> commentsModel) {
    state = CommentSuccessState(commentsModel);
  }

  Future fetchComments(int feedId) async {
    state = const CommentLoadingState();

    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.feedComments(feedId)));
      if (responseBody != null) {
        commentsModel = (responseBody as List<dynamic>).map((x) => CommentModel.fromJson(x)).toList();
        hasMoreComments = commentsModel.length > 9 ? true : false;

        print(hasMoreComments);
        state = CommentSuccessState(commentsModel);
      } else {
        state = const CommentErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentErrorState();
    }
  }

  Future fetchMoreComments(int feedId) async {
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.feedComments(feedId, lastId: commentsModel.last.id)));
      if (responseBody != null) {
        var commentsModelInstance = (responseBody as List<dynamic>).map((x) => CommentModel.fromJson(x)).toList();
        hasMoreComments = commentsModelInstance.isNotEmpty ? true : false;

        state = CommentSuccessState(commentsModel..addAll(commentsModelInstance));
      } else {
        state = const CommentErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentErrorState();
    }
  }

  Future createComment({int? feedId, int? feedUserId, String? commentText, int? parentId, FeedType? feedType}) async {
    dynamic responseBody;

    var requestBody = {
      'feed_id': feedId,
      'feed_user_id': feedUserId,
      'comment_txt': commentText,
      'parrent_id': parentId,
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.createComment, requestBody));
      if (responseBody != null) {
        CommentModel commentModelInstance = CommentModel.fromJson(responseBody);
        commentModelInstance.user = ref!.read(userProvider.notifier).userData?.user!;
        commentsModel.insert(0, commentModelInstance);

        /* 
          * Incrementing comment count based on FeedType
        */
        if (feedType == FeedType.HOME) {
          final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
          final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;

          FeedModel? isInWorldFeedList = worldFeedList.firstWhereOrNull((element) => element.id == feedId);
          FeedModel? isInPersonalFeedList = personalFeedList.firstWhereOrNull((element) => element.id == feedId);

          if (isInWorldFeedList != null) {
            worldFeedList[worldFeedList.indexWhere((element) => element.id == feedId)].commentCount += 1;
            ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
          }
          if (isInPersonalFeedList != null) {
            personalFeedList[personalFeedList.indexWhere((element) => element.id == feedId)].commentCount += 1;
            ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
          }
        } else if (feedType == FeedType.PROFILE) {
          final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList == null
              ? []
              : ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
          final List<FeedModel>? userProfileFeedList = ref!.read(userProfileFeedProvider.notifier).userProfileFeedList == null
              ? []
              : ref!.read(userProfileFeedProvider.notifier).userProfileFeedList?.feedData;

          FeedModel? isInMyProfileFeedList = myProfileFeedList?.firstWhereOrNull((element) => element.id == feedId);
          FeedModel? isInUserProfileFeedList = userProfileFeedList?.firstWhereOrNull((element) => element.id == feedId);

          if (isInMyProfileFeedList != null) {
            myProfileFeedList![myProfileFeedList.indexWhere((element) => element.id == feedId)].commentCount += 1;
            ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList);
          }

          if (isInUserProfileFeedList != null) {
            userProfileFeedList?[userProfileFeedList.indexWhere((element) => element.id == feedId)].commentCount += 1;
            ref!.read(userProfileFeedProvider.notifier).updateSuccessState(userProfileFeedList!);
          }
        } else if (feedType == FeedType.GROUP) {
          final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
          groupFeedList![groupFeedList.indexWhere((element) => element.id == feedId)].commentCount += 1;

          ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
        } else if (feedType == FeedType.PAGE) {
          final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
          pageFeedList![pageFeedList.indexWhere((element) => element.id == feedId)].commentCount += 1;

          ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);
        } else if (feedType == FeedType.EVENT) {
          final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;
          eventFeedList![eventFeedList.indexWhere((element) => element.id == feedId)].commentCount += 1;

          ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList);
        } else if (feedType == FeedType.SEARCH) {
          final List<FeedModel> searchFeedList = ref!.read(searchProvider.notifier).response;
          searchFeedList[searchFeedList.indexWhere((element) => element.id == feedId)].commentCount += 1;

          ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
        } else if (feedType == FeedType.SAVED) {
          final List<FeedModel>? savedFeedList = ref!.read(savedPostsProvider.notifier).savedPostsModel?.feedData?.data;
          savedFeedList![savedFeedList.indexWhere((element) => element.id == feedId)].commentCount += 1;

          ref!.read(savedPostsProvider.notifier).updateSuccessState(savedFeedList);
        } else if (feedType == FeedType.DETAILS) {
          final FeedModel? feedDetails = ref!.read(feedDetailsProvider.notifier).feedDetailsModel;
          feedDetails?.commentCount += 1;

          ref!.read(feedDetailsProvider.notifier).updateDetailsSuccessState(feedDetails);
        }
      } else {
        state = const CommentErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentErrorState();
    }
  }

  Future updateComment({CommentModel? commentData, String? commentText}) async {
    dynamic responseBody;

    var requestBody = {'id': commentData?.id, 'comment_txt': commentText};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.updateComment, requestBody));
      if (responseBody != null) {
        commentData?.commentTxt = commentText;
        state = CommentSuccessState(commentsModel);
      } else {
        state = const CommentErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentErrorState();
    }
  }

  Future deleteComment({int? feedId, int? commentId, FeedType? feedType}) async {
    dynamic responseBody;

    var requestBody = {'feed_id': feedId, 'id': commentId};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deleteComment, requestBody));
      if (responseBody != null) {
        commentsModel.removeWhere((element) => element.id == commentId);
        hasMoreComments = commentsModel.isNotEmpty ? true : false;

        state = CommentSuccessState(commentsModel);

        /* 
          * Decrementing comment count based on FeedType
        */
        if (feedType == FeedType.HOME) {
          final List<FeedModel> worldFeedList = ref!.read(worldFeedProvider.notifier).worldFeedList;
          final List<FeedModel> personalFeedList = ref!.read(personalFeedProvider.notifier).personalFeedList;

          FeedModel? isInWorldFeedList = worldFeedList.firstWhereOrNull(
            (element) => element.id == feedId,
          );
          FeedModel? isInPersonalFeedList = personalFeedList.firstWhereOrNull(
            (element) => element.id == feedId,
          );

          if (isInWorldFeedList != null) {
            worldFeedList[worldFeedList.indexWhere((element) => element.id == feedId)].commentCount -= 1;
            ref!.read(worldFeedProvider.notifier).updateSuccessState(worldFeedList);
          }
          if (isInPersonalFeedList != null) {
            personalFeedList[personalFeedList.indexWhere((element) => element.id == feedId)].commentCount -= 1;
            ref!.read(personalFeedProvider.notifier).updateSuccessState(personalFeedList);
          }
        } else if (feedType == FeedType.PROFILE) {
          final List<FeedModel>? myProfileFeedList = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList?.feedData;
          final List<FeedModel>? userProfileFeedList = ref!.read(userProfileFeedProvider.notifier).userProfileFeedList?.feedData;

          FeedModel? isInMyProfileFeedList = myProfileFeedList?.firstWhereOrNull(
            (element) => element.id == feedId,
          );
          FeedModel? isInUserProfileFeedList = userProfileFeedList?.firstWhereOrNull((element) => element.id == feedId);

          if (isInMyProfileFeedList != null) {
            myProfileFeedList![myProfileFeedList.indexWhere((element) => element.id == feedId)].commentCount -= 1;
            ref!.read(myProfileFeedProvider.notifier).updateSuccessState(myProfileFeedList);
          }

          if (isInUserProfileFeedList != null) {
            userProfileFeedList![userProfileFeedList.indexWhere((element) => element.id == feedId)].commentCount -= 1;
            ref!.read(userProfileFeedProvider.notifier).updateSuccessState(userProfileFeedList);
          }
        } else if (feedType == FeedType.GROUP) {
          final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList?.feedData;
          groupFeedList![groupFeedList.indexWhere((element) => element.id == feedId)].commentCount -= 1;

          ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);
        } else if (feedType == FeedType.PAGE) {
          final List<FeedModel>? pageFeedList = ref!.read(pageFeedProvider.notifier).pageFeedList?.feedData;
          pageFeedList![pageFeedList.indexWhere((element) => element.id == feedId)].commentCount -= 1;

          ref!.read(pageFeedProvider.notifier).updateSuccessState(pageFeedList);
        } else if (feedType == FeedType.EVENT) {
          final List<FeedModel>? eventFeedList = ref!.read(eventFeedProvider.notifier).eventFeedList?.feedData;
          eventFeedList![eventFeedList.indexWhere((element) => element.id == feedId)].commentCount -= 1;

          ref!.read(eventFeedProvider.notifier).updateSuccessState(eventFeedList);
        } else if (feedType == FeedType.SEARCH) {
          final List<FeedModel> searchFeedList = ref!.read(searchProvider.notifier).response;
          searchFeedList[searchFeedList.indexWhere((element) => element.id == feedId)].commentCount -= 1;

          ref!.read(searchProvider.notifier).updateSuccessState(searchFeedList);
        } else if (feedType == FeedType.SAVED) {
          final List<FeedModel>? savedFeedList = ref!.read(savedPostsProvider.notifier).savedPostsModel?.feedData?.data;
          savedFeedList![savedFeedList.indexWhere((element) => element.id == feedId)].commentCount -= 1;

          ref!.read(savedPostsProvider.notifier).updateSuccessState(savedFeedList);
        } else if (feedType == FeedType.DETAILS) {
          final FeedModel? feedDetails = ref!.read(feedDetailsProvider.notifier).feedDetailsModel;
          feedDetails?.commentCount -= 1;

          ref!.read(feedDetailsProvider.notifier).updateDetailsSuccessState(feedDetails);
        }
      } else {
        state = const CommentErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentErrorState();
    }
  }

  Future likeCommment({CommentModel? commentData, action, reaction}) async {
    CommentModel commentModel = commentsModel[commentsModel.indexWhere((element) => element.id == commentData!.id)];
    // print(
    // ' map((entry) => entry.meta).toList() init ====> ${commentModel.totalLikes!.map((entry) => "${entry.reactionType} ${entry.totalLikes}").toList()}');

    if (commentModel.commentlike == null) {
      commentModel.likeCount += 1;
      commentModel.commentlike = CommentLike(
        userId: getIntAsync(USER_ID),
        commentId: commentData!.id,
        reactionType: reaction,
      );

      // Checking if my reaction exists in total reactions array,
      // so as to add or just update the reactions count for that reaction type
      var commentTotalLikes = commentModel.totalLikes!.firstWhereOrNull((element) => element.reactionType == reaction);
      // print('commentTotalLikes = $commentTotalLikes');
      // print('commentTotalLikes = ${commentTotalLikes.runtimeType}');
      if (commentTotalLikes != null) {
        commentTotalLikes.totalLikes++;
      } else {
        commentModel.totalLikes!.add(CommentLike(commentId: commentData.id, reactionType: reaction, totalLikes: 1));
      }
    } else if (action == 'update') {
      /// If I'm updating my previously added reaction
      if (commentModel.commentlike != null) {
        // print('feed like ! = null;');

        var prevReactionIndex = commentModel.totalLikes!.indexWhere((element) => element.reactionType == commentData!.commentlike!.reactionType);
        // print('prevReactionIndex = $prevReactionIndex');

        if (prevReactionIndex != -1) {
          // print('inside if prevReactionIndex = $prevReactionIndex');
          if (commentModel.totalLikes![prevReactionIndex].totalLikes == 1) {
            // print(
            // ' map((entry) => entry.meta).toList()  ====> ${commentModel.totalLikes!.map((entry) => "${entry.reactionType} ${entry.totalLikes}").toList()}');
            // print('removing at index');

            commentModel.totalLikes!.removeAt(prevReactionIndex);
            // print(
            // ' map((entry) => entry.meta).toList()  ====> ${commentModel.totalLikes!.map((entry) => "${entry.reactionType} ${entry.totalLikes}").toList()}');
          } else {
            // print('-=1');
            commentModel.totalLikes![prevReactionIndex].totalLikes -= 1;
          }
        }
      }

      /// Adding/Updating my reaction
      commentModel.commentlike = CommentLike(
        userId: getIntAsync(USER_ID),
        commentId: commentData!.id,
        reactionType: reaction,
      );

      /// Checking if my current reaction exists in like type array,
      ///  so as to increase the totalLike count for that reaction type
      var feedLikeTypes = commentModel.totalLikes!.where((element) => element.reactionType == reaction);

      /// If feed like type array is empty, we need to insert new like type object to it
      if (feedLikeTypes.isEmpty) {
        commentModel.totalLikes!.add(CommentLike(
          userId: getIntAsync(USER_ID),
          commentId: commentData.id,
          reactionType: reaction,
          totalLikes: 1,
        ));
        // print(' added here ====> ${commentModel.totalLikes!.map((entry) => "${entry.reactionType} ${entry.totalLikes}").toList()}');
      } else {
        var feedLikeTypeIndex = commentModel.totalLikes!.indexWhere((element) => element.reactionType == reaction);
        commentModel.totalLikes![feedLikeTypeIndex].totalLikes += 1;
      }
      //
    } else {
      var reactionToRemove = commentModel.totalLikes!
          .firstWhereOrNull((element) => (element.reactionType == commentData!.commentlike!.reactionType) && (element.totalLikes == 1));
      if (reactionToRemove == null) {
        // print('reactionToRemove == null  = $reactionToRemove');
        commentModel.totalLikes!.where((element) => element.reactionType == commentData!.commentlike!.reactionType).first.totalLikes -= 1;
      } else {
        // print('reactionToRemove != null  = $reactionToRemove');
        commentModel.totalLikes!
            .removeWhere((element) => (element.reactionType == commentData!.commentlike!.reactionType) && (element.totalLikes == 1));
      }

      commentModel.likeCount -= 1;
      commentModel.commentlike = null;
    }

    commentModel.totalLikes!.sort(((a, b) => a.totalLikes.compareTo(b.totalLikes)));
    // print(
    // ' map((entry) => entry.meta).toList() before ====> ${commentModel.totalLikes!.map((entry) => "${entry.reactionType} ${entry.totalLikes}").toList()}');
    commentModel.totalLikes = commentModel.totalLikes!.reversed.toList();
    // print(
    // ' map((entry) => entry.meta).toList() after ====> ${commentModel.totalLikes!.map((entry) => "${entry.reactionType} ${entry.totalLikes}").toList()}');

    state = CommentSuccessState(commentsModel);

    var requestBody = {
      'comment_id': commentData?.id,
      'action': action,
      'reaction': reaction,
    };

    try {
      await Network.handleResponse(await Network.postRequest(API.likeComment, requestBody));
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentErrorState();
    }
  }
}
