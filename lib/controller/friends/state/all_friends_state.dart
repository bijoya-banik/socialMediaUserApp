import 'package:buddyscripts/models/friend/friend_model.dart';

abstract class AllFriendsState {
    const AllFriendsState();
}
class AllFriendsInitialState extends AllFriendsState {
    const AllFriendsInitialState();
}
class AllFriendsLoadingState extends AllFriendsState {
    const AllFriendsLoadingState();
}
class AllFriendsSuccessState extends AllFriendsState {
   final FriendModel allFriendsModel;
    const AllFriendsSuccessState(this.allFriendsModel);
}
class AllFriendsErrorState extends AllFriendsState {
    const AllFriendsErrorState();
}