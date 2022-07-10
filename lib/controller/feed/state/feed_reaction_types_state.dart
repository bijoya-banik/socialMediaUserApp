import 'package:buddyscripts/models/feed/feed_reaction_types_model.dart';

abstract class FeedReactionTypesState {
  const FeedReactionTypesState();
}

class FeedReactionTypesInitialState extends FeedReactionTypesState {
  const FeedReactionTypesInitialState();
}

class FeedReactionTypesLoadingState extends FeedReactionTypesState {
  const FeedReactionTypesLoadingState();
}

class FeedReactionTypesSuccessState extends FeedReactionTypesState {
  final List<FeedReactionTypesModel>? feedReactionTypesModel;
  const FeedReactionTypesSuccessState(this.feedReactionTypesModel);
}

class FeedReactionTypesErrorState extends FeedReactionTypesState {
  const FeedReactionTypesErrorState();
}
