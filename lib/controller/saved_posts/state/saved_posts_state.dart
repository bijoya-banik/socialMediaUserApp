import 'package:buddyscripts/models/saved_posts/saved_posts_model.dart';

abstract class SavedPostsState {
    const SavedPostsState();
}
class SavedPostsInitialState extends SavedPostsState {
    const SavedPostsInitialState();
}
class SavedPostsLoadingState extends SavedPostsState {
    const SavedPostsLoadingState();
}
class SavedPostsSuccessState extends SavedPostsState {
    final SavedPostsModel savedPostsModel;
    const SavedPostsSuccessState(this.savedPostsModel);
}
class SavedPostsErrorState extends SavedPostsState {
    const SavedPostsErrorState();
}