import 'package:buddyscripts/models/page/page_feed_model.dart';

abstract class PageFeedState {
  const PageFeedState();
}

class PageFeedInitialState extends PageFeedState {
  const PageFeedInitialState();
}

class PageFeedLoadingState extends PageFeedState {
  const PageFeedLoadingState();
}

class PageFeedSuccessState extends PageFeedState {
  final PageFeedModel pageFeedModel;
  const PageFeedSuccessState(this.pageFeedModel);
}

class PageFeedErrorState extends PageFeedState {
  const PageFeedErrorState();
}
