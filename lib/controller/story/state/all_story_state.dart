
import 'package:buddyscripts/models/story/all_story_model.dart';

abstract class AllStoryState {
  const AllStoryState();
}

class AllStoryInitialState extends AllStoryState {
  const AllStoryInitialState();
}

class AllStoryLoadingState extends AllStoryState {
  const AllStoryLoadingState();
}

class AllStorySuccessState extends AllStoryState {
  final List<AllStoryModel> allStoryModel;
  const AllStorySuccessState(this.allStoryModel);
}

class AllStoryErrorState extends AllStoryState {
  const AllStoryErrorState();
}
