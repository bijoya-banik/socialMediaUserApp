import 'package:buddyscripts/models/feed/comment_model.dart';

abstract class CommentReplyState {
  const CommentReplyState();
}

class CommentReplyInitialState extends CommentReplyState {
  const CommentReplyInitialState();
}

class CommentReplyLoadingState extends CommentReplyState {
  const CommentReplyLoadingState();
}

class CommentReplySuccessState extends CommentReplyState {
  final List<CommentModel> commentModel;
  const CommentReplySuccessState(this.commentModel);
}

class CommentReplyErrorState extends CommentReplyState {
  const CommentReplyErrorState();
}
