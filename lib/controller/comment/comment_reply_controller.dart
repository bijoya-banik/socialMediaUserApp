import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/comment/comment_controller.dart';
import 'package:buddyscripts/controller/comment/state/comment_reply_state.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/models/feed/comment_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

final commentRepliesProvider = StateNotifierProvider<CommentReplyController, CommentReplyState>((ref) {
  return CommentReplyController(ref: ref);
});

class CommentReplyController extends StateNotifier<CommentReplyState> {
  final Ref? ref;
  CommentReplyController({this.ref}) : super(const CommentReplyInitialState());

  List<CommentModel> commentReplyModel = [];
  bool hasMoreCommentReplies = false;

  Future fetchCommentReplies(int feedId) async {
    state = const CommentReplyLoadingState();

    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.feedCommentReplies(feedId)));
      if (responseBody != null) {
        commentReplyModel = (responseBody as List<dynamic>).map((x) => CommentModel.fromJson(x)).toList();
        hasMoreCommentReplies = commentReplyModel.length > 9 ? true : false;

        state = CommentReplySuccessState(commentReplyModel);
      } else {
        state = const CommentReplyErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentReplyErrorState();
    }
  }

  Future fetchMoreCommentReplies(int feedId) async {
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.feedCommentReplies(feedId, lastId: commentReplyModel.last.id)));
      if (responseBody != null) {
        var commentReplyModelInstance = (responseBody as List<dynamic>).map((x) => CommentModel.fromJson(x)).toList();
        hasMoreCommentReplies = commentReplyModelInstance.isNotEmpty ? true : false;

        state = CommentReplySuccessState(commentReplyModel..addAll(commentReplyModelInstance));
      } else {
        state = const CommentReplyErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentReplyErrorState();
    }
  }

  Future createCommentReply({int? feedId, int? feedUserId, String? commentText, int? parentId, FeedType? feedType}) async {
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
        CommentModel replyModelInstance = CommentModel.fromJson(responseBody);
        replyModelInstance.user = ref!.read(userProvider.notifier).userData?.user;
        commentReplyModel.insert(0, replyModelInstance);

        final List<CommentModel> commentList = ref!.read(commentsProvider.notifier).commentsModel;
        commentList[commentList.indexWhere((element) => element.id == parentId)].replyCount += 1;
      } else {
        state = const CommentReplyErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentReplyErrorState();
    }
  }

  Future updateCommentReply({CommentModel? commentReplyData, String? commentReplyText}) async {
    dynamic responseBody;

    var requestBody = {'id': commentReplyData?.id, 'comment_txt': commentReplyText};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.updateComment, requestBody));
      if (responseBody != null) {
        commentReplyData?.commentTxt = commentReplyText;
        state = CommentReplySuccessState(commentReplyModel);
      } else {
        state = const CommentReplyErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentReplyErrorState();
    }
  }

  Future deleteCommentReply({int? feedId, int? commentId, int? parentId, FeedType? feedType}) async {
    dynamic responseBody;

    var requestBody = {
      'feed_id': feedId,
      'id': commentId,
      'parrent_id': parentId,
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deleteComment, requestBody));
      if (responseBody != null) {
        commentReplyModel.removeWhere((element) => element.id == commentId);
        hasMoreCommentReplies = commentReplyModel.isNotEmpty ? true : false;
        state = CommentReplySuccessState(commentReplyModel);

        final List<CommentModel> commentList = ref!.read(commentsProvider.notifier).commentsModel;
        commentList[commentList.indexWhere((element) => element.id == parentId)].replyCount -= 1;
        ref!.read(commentsProvider.notifier).updateSuccessState(commentList);
      } else {
        state = const CommentReplyErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentReplyErrorState();
    }
  }

  Future likeCommmentReply({CommentModel? replyData, reaction, action}) async {
    // if (replyData?.commentlike == null) {
    //   commentReplyModel[commentReplyModel.indexWhere((element) => element.id == replyData?.id)].likeCount += 1;
    //   commentReplyModel[commentReplyModel.indexWhere((element) => element.id == replyData?.id)].commentlike = CommentLike.fromJson({
    //     'comment_id': replyData?.id,
    //     'user_id': getIntAsync(USER_ID),
    //     'reaction_type': reaction,
    //   });
    // } else {
    //   commentReplyModel[commentReplyModel.indexWhere((element) => element.id == replyData!.id)].likeCount -= 1;
    //   commentReplyModel[commentReplyModel.indexWhere((element) => element.id == replyData!.id)].commentlike = null;
    // }

    CommentModel commentModel = commentReplyModel[commentReplyModel.indexWhere((element) => element.id == replyData!.id)];
    // print(
    // ' map((entry) => entry.meta).toList() init ====> ${commentModel.totalLikes!.map((entry) => "${entry.reactionType} ${entry.totalLikes}").toList()}');

    if (commentModel.commentlike == null) {
      commentModel.likeCount += 1;
      commentModel.commentlike = CommentLike(
        userId: getIntAsync(USER_ID),
        commentId: replyData!.id,
        reactionType: reaction,
      );

      // Checking if my reaction exists in total reactions array,
      // so as to add or just update the reactions count for that reaction type
      var commentTotalLikes = commentModel.totalLikes!.where((element) => element.reactionType == reaction);
      // print('commentTotalLikes = $commentTotalLikes');
      // print('commentTotalLikes = ${commentTotalLikes.runtimeType}');
      if (commentTotalLikes.isNotEmpty) {
        commentTotalLikes.first.totalLikes++;
      } else {
        commentModel.totalLikes!.add(CommentLike(commentId: replyData.id, reactionType: reaction, totalLikes: 1));
      }
    } else if (action == 'update') {
      /// If I'm updating my previously added reaction
      if (commentModel.commentlike != null) {
        // print('feed like ! = null;');

        var prevReactionIndex = commentModel.totalLikes!.indexWhere((element) => element.reactionType == replyData!.commentlike!.reactionType);
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
        commentId: replyData!.id,
        reactionType: reaction,
      );

      /// Checking if my current reaction exists in like type array,
      ///  so as to increase the totalLike count for that reaction type
      var feedLikeTypes = commentModel.totalLikes!.where((element) => element.reactionType == reaction);

      /// If feed like type array is empty, we need to insert new like type object to it
      if (feedLikeTypes.isEmpty) {
        commentModel.totalLikes!.add(CommentLike(
          userId: getIntAsync(USER_ID),
          commentId: replyData.id,
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
      var reactionToRemove =
          commentModel.totalLikes!.where((element) => (element.reactionType == replyData!.commentlike!.reactionType) && (element.totalLikes == 1));
      if (reactionToRemove.isEmpty) {
        // print('reactionToRemove == null  = $reactionToRemove');
        commentModel.totalLikes!.where((element) => element.reactionType == replyData!.commentlike!.reactionType).first.totalLikes -= 1;
      } else {
        // print('reactionToRemove != null  = $reactionToRemove');
        commentModel.totalLikes!
            .removeWhere((element) => (element.reactionType == replyData!.commentlike!.reactionType) && (element.totalLikes == 1));
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

    state = CommentReplySuccessState(commentReplyModel);

    var requestBody = {
      'comment_id': replyData!.id,
      'action': action,
      'reaction': reaction,
    };

    try {
      await Network.handleResponse(await Network.postRequest(API.likeComment, requestBody));
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CommentReplyErrorState();
    }
  }
}
