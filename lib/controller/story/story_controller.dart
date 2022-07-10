import 'package:buddyscripts/controller/story/state/story_state.dart';
import 'package:buddyscripts/models/story/story_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storyProvider = StateNotifierProvider<StoryController,StoryState>(
  (ref) => StoryController(ref: ref),
);

class StoryController extends StateNotifier<StoryState> {
  final Ref? ref;
  StoryController({this.ref}) : super(const StoryInitialState());

  List<StoryModel> storyModel = [StoryModel()];

  updateSuccessState(List<StoryModel> storyModelInstance) {
    state = StorySuccessState(storyModelInstance);
  }

  Future fetchStory() async {
    storyModel.clear();
    storyModel.add(StoryModel());
    List<StoryModel> storyModelInstance;
    state = const StoryLoadingState();
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.getStory),
      );
      if (responseBody != null) {
        storyModelInstance = (responseBody as List<dynamic>).map((x) => StoryModel.fromJson(x)).toList();

        storyModel.addAll(storyModelInstance);

        state = StorySuccessState(storyModel);
      } else {
        state = const StoryErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchStory(): $error");
      print(stackTrace);
      state = const StoryErrorState();
    }
  }

  refreshState() {
    state = StorySuccessState(storyModel);
  }
}
