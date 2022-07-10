import 'package:buddyscripts/models/feed/comment_reaction_types_model.dart';

abstract class CommentReactionTypesState {
  const CommentReactionTypesState();
}

class CommentReactionTypesInitialState extends CommentReactionTypesState {
  const CommentReactionTypesInitialState();
}

class CommentReactionTypesLoadingState extends CommentReactionTypesState {
  const CommentReactionTypesLoadingState();
}

class CommentReactionTypesSuccessState extends CommentReactionTypesState {
  final List<CommentReactionTypesModel> commentReactedTypesModel;
  const CommentReactionTypesSuccessState(this.commentReactedTypesModel);
}

class CommentReactionTypesErrorState extends CommentReactionTypesState {
  const CommentReactionTypesErrorState();
}
