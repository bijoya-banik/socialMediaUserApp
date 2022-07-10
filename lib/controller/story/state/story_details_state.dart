

import 'package:buddyscripts/models/story/story_details_model.dart';

abstract class StoryDetailsState {
  const StoryDetailsState();
}

class StoryDetailsInitialState extends StoryDetailsState {
  const StoryDetailsInitialState();
}

class StoryDetailsLoadingState extends StoryDetailsState {
  const StoryDetailsLoadingState();
}
class StoryDetailsProcessingState extends StoryDetailsState {
  const StoryDetailsProcessingState();
}

class StoryDetailsSuccessState extends StoryDetailsState {
  final List< StoryDetailsModel> storyDetailsModelList;
  const StoryDetailsSuccessState(this.storyDetailsModelList);
}

class StoryDetailsErrorState extends StoryDetailsState {
  const StoryDetailsErrorState();
}
