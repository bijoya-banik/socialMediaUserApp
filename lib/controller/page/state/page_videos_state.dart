import 'package:buddyscripts/models/page/page_videos_model.dart';

abstract class PageVideosState {
  const PageVideosState();
}

class PageVideosInitialState extends PageVideosState {
  const PageVideosInitialState();
}

class PageVideosLoadingState extends PageVideosState {
  const PageVideosLoadingState();
}

class PageVideosSuccessState extends PageVideosState {
  final PageVideosModel pageVideosModel;
  const PageVideosSuccessState(this.pageVideosModel);
}

class PageVideosErrorState extends PageVideosState {
  const PageVideosErrorState();
}
