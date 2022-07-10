import 'package:buddyscripts/models/page/pages_model.dart';

abstract class FollowedPagesState {
  const FollowedPagesState();
}

class FollowedPagesInitialState extends FollowedPagesState {
  const FollowedPagesInitialState();
}

class FollowedPagesLoadingState extends FollowedPagesState {
  const FollowedPagesLoadingState();
}

class FollowedPagesSuccessState extends FollowedPagesState {
  final PagesModel pagesModel;
  const FollowedPagesSuccessState(this.pagesModel);
}

class FollowedPagesErrorState extends FollowedPagesState {
  const FollowedPagesErrorState();
}
