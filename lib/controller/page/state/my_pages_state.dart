import 'package:buddyscripts/models/page/pages_model.dart';

abstract class MyPagesState {
  const MyPagesState();
}

class MyPagesInitialState extends MyPagesState {
  const MyPagesInitialState();
}

class MyPagesLoadingState extends MyPagesState {
  const MyPagesLoadingState();
}

class MyPagesSuccessState extends MyPagesState {
  final PagesModel pagesModel;
  const MyPagesSuccessState(this.pagesModel);
}

class MyPagesErrorState extends MyPagesState {
  const MyPagesErrorState();
}
