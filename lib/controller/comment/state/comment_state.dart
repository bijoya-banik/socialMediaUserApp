import 'package:buddyscripts/models/feed/comment_model.dart';

abstract class CommentState {
  const CommentState();
}

class CommentInitialState extends CommentState {
  const CommentInitialState();
}

class CommentLoadingState extends CommentState {
  const CommentLoadingState();
}

class CommentSuccessState extends CommentState {
  final List<CommentModel> commentModel;
  const CommentSuccessState(this.commentModel);
}

class CommentErrorState extends CommentState {
  const CommentErrorState();
}
