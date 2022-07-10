import 'package:buddyscripts/models/page/page_about_model.dart';

abstract class PageAboutState {
  const PageAboutState();
}

class PageAboutInitialState extends PageAboutState {
  const PageAboutInitialState();
}

class PageAboutLoadingState extends PageAboutState {
  const PageAboutLoadingState();
}

class PageAboutSuccessState extends PageAboutState {
  final PageAboutModel pageAboutModel;
  const PageAboutSuccessState(this.pageAboutModel);
}

class PageAboutErrorState extends PageAboutState {
  const PageAboutErrorState();
}
