import 'package:buddyscripts/models/page/page_photos_model.dart';

abstract class PagePhotosState {
  const PagePhotosState();
}

class PagePhotosInitialState extends PagePhotosState {
  const PagePhotosInitialState();
}

class PagePhotosLoadingState extends PagePhotosState {
  const PagePhotosLoadingState();
}

class PagePhotosSuccessState extends PagePhotosState {
  final PagePhotosModel pagePhotosModel;
  const PagePhotosSuccessState(this.pagePhotosModel);
}

class PagePhotosErrorState extends PagePhotosState {
  const PagePhotosErrorState();
}
