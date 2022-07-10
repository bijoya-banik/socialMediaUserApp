import 'package:buddyscripts/models/friend/friend_model.dart';

abstract class FriendSuggestionsState {
    const FriendSuggestionsState();
}
class FriendSuggestionsInitialState extends FriendSuggestionsState {
    const FriendSuggestionsInitialState();
}
class FriendSuggestionsLoadingState extends FriendSuggestionsState {
    const FriendSuggestionsLoadingState();
}
class FriendSuggestionsSuccessState extends FriendSuggestionsState {
   final FriendModel friendSuggestionsModel;
    const FriendSuggestionsSuccessState(this.friendSuggestionsModel);
}
class FriendSuggestionsErrorState extends FriendSuggestionsState {
    const FriendSuggestionsErrorState();
}