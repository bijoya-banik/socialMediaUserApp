import 'package:buddyscripts/models/page/pages_model.dart';

abstract class DiscoverPagesState {
  const DiscoverPagesState();
}

class DiscoverPagesInitialState extends DiscoverPagesState {
  const DiscoverPagesInitialState();
}

class DiscoverPagesLoadingState extends DiscoverPagesState {
  const DiscoverPagesLoadingState();
}

class DiscoverPagesSuccessState extends DiscoverPagesState {
  final PagesModel pagesModel;
  const DiscoverPagesSuccessState(this.pagesModel);
}

class DiscoverPagesErrorState extends DiscoverPagesState {
  const DiscoverPagesErrorState();
}
