import 'package:buddyscripts/models/group/group_videos_model.dart';

abstract class GroupVideosState {
  const GroupVideosState();
}

class GroupVideosInitialState extends GroupVideosState {
  const GroupVideosInitialState();
}

class GroupVideosLoadingState extends GroupVideosState {
  const GroupVideosLoadingState();
}

class GroupVideosSuccessState extends GroupVideosState {
  final GroupVideosModel groupVideosModel;
  const GroupVideosSuccessState(this.groupVideosModel);
}

class GroupVideosErrorState extends GroupVideosState {
  const GroupVideosErrorState();
}
