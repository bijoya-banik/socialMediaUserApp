
import 'package:buddyscripts/models/story/story_model.dart';

abstract class StoryState {
  const StoryState();
}

class StoryInitialState extends StoryState {
  const StoryInitialState();
}

class StoryLoadingState extends StoryState {
  const StoryLoadingState();
}

class StorySuccessState extends StoryState {
  final List<StoryModel> storyModel;
  const StorySuccessState(this.storyModel);
}

class StoryErrorState extends StoryState {
  const StoryErrorState();
}
