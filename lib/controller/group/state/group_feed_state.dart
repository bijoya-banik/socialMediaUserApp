import 'package:buddyscripts/models/group/group_feed_model.dart';

abstract class GroupFeedState {
  const GroupFeedState();
}

class GroupFeedInitialState extends GroupFeedState {
  const GroupFeedInitialState();
}

class GroupFeedLoadingState extends GroupFeedState {
  const GroupFeedLoadingState();
}

class GroupFeedSuccessState extends GroupFeedState {
  final GroupFeedModel groupFeedModel;
  const GroupFeedSuccessState(this.groupFeedModel);
}

class GroupFeedErrorState extends GroupFeedState {
  const GroupFeedErrorState();
}
