import 'package:buddyscripts/models/feed/comment_reacted_users_model.dart';

abstract class CommentReactedUsersState {
  const CommentReactedUsersState();
}

class CommentReactedUsersInitialState extends CommentReactedUsersState {
  const CommentReactedUsersInitialState();
}

class CommentReactedUsersLoadingState extends CommentReactedUsersState {
  const CommentReactedUsersLoadingState();
}

class CommentReactedUsersSuccessState extends CommentReactedUsersState {
  final List<CommentReactedUsersModel> commentReactedUsers;
  const CommentReactedUsersSuccessState(this.commentReactedUsers);
}

class CommentReactedUsersErrorState extends CommentReactedUsersState {
  const CommentReactedUsersErrorState();
}
