import 'package:buddyscripts/controller/comment/state/comment_reacted_users_state.dart';
import 'package:buddyscripts/controller/comment/state/comment_reaction_types.dart';
import 'package:buddyscripts/controller/pagination/comment/comment_reacted_users_scroll_provider.dart';
import 'package:buddyscripts/models/feed/comment_reacted_users_model.dart';
import 'package:buddyscripts/models/feed/comment_reaction_types_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentReactedUsersProvider = StateNotifierProvider<CommentReactedUsersController, CommentReactedUsersState>(
  (ref) => CommentReactedUsersController(ref: ref),
);

class CommentReactedUsersController extends StateNotifier<CommentReactedUsersState> {
  final Ref? ref;
  CommentReactedUsersController({this.ref}) : super(const CommentReactedUsersInitialState());

  List<CommentReactedUsersModel> commentReactedUsers = [];

  Future fetchCommentReactedUsers(commentId, {reactionType = 'all'}) async {
    state = const CommentReactedUsersLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.commentReactedUsers(commentId, reactionType: reactionType)),
      );
      if (responseBody != null) {
        commentReactedUsers = (responseBody as List<dynamic>).map((x) => CommentReactedUsersModel.fromJson(x)).toList();

        state = CommentReactedUsersSuccessState(commentReactedUsers);
      } else {
        state = const CommentReactedUsersErrorState();
      }
    } catch (error, stackTrace) {
      print('fetchCommentReactedUsers() error = $error');
      print(stackTrace);
      state = const CommentReactedUsersErrorState();
    }
  }

  Future fetchMoreCommentReactedUsers(int feedId, {String reactionType = "all"}) async {
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.feedReactedUsers(feedId, reactionType: reactionType, lastId: commentReactedUsers.last.id)),
      );
      if (responseBody != null) {
        var commentReactedUsersModelInstance = (responseBody as List<dynamic>).map((x) => CommentReactedUsersModel.fromJson(x)).toList();
        if (commentReactedUsersModelInstance.isNotEmpty &&
            (commentReactedUsersModelInstance.first.id == commentReactedUsers.first.id ||
                commentReactedUsersModelInstance.first.id == commentReactedUsers.last.id)) return;

        commentReactedUsers.addAll(commentReactedUsersModelInstance);

        state = CommentReactedUsersSuccessState(commentReactedUsers);
        ref!.read(commentReactedUsersScrollProvider.notifier).resetState();
      } else {
        state = const CommentReactedUsersErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchFeedReactedUsers() error =  $error");
      print(stackTrace);
      state = const CommentReactedUsersErrorState();
    }
  }
}

final commentReactionTypesProvider = StateNotifierProvider<CommentReactionTypesController, CommentReactionTypesState>(
  (ref) => CommentReactionTypesController(ref: ref),
);

class CommentReactionTypesController extends StateNotifier<CommentReactionTypesState> {
  final Ref? ref;
  CommentReactionTypesController({this.ref}) : super(const CommentReactionTypesInitialState());

  List<CommentReactionTypesModel> commentReactionTypes = [];

  Future fetchCommentReactionTypes(commentId) async {
    commentReactionTypes = [CommentReactionTypesModel(reactionType: 'All')];
    state = const CommentReactionTypesLoadingState();
    // print('CommentReactionTypesLoadingState =  $state');

    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.commentReactionTypes(commentId)),
      );
      if (responseBody != null) {
        var commentReactionTypesInstance = (responseBody as List<dynamic>).map((x) => CommentReactionTypesModel.fromJson(x)).toList();

        state = CommentReactionTypesSuccessState(commentReactionTypes..addAll(commentReactionTypesInstance));
      } else {
        state = const CommentReactionTypesErrorState();
      }
    } catch (error, stackTrace) {
      print('fetchCommentReactionTypes() error = $error');
      print(stackTrace);
      state = const CommentReactionTypesErrorState();
    }
  }
}
