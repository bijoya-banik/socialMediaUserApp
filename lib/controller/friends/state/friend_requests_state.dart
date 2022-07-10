import 'package:buddyscripts/models/friend/friend_requests_model.dart';

abstract class FriendRequestsState {
  const FriendRequestsState();
}

class FriendRequestsInitialState extends FriendRequestsState {
  const FriendRequestsInitialState();
}

class FriendRequestsLoadingState extends FriendRequestsState {
  const FriendRequestsLoadingState();
}

class FriendRequestsSuccessState extends FriendRequestsState {
  final FriendRequestsModel friendRequestsModel;
  const FriendRequestsSuccessState(this.friendRequestsModel);
}

class FriendRequestsErrorState extends FriendRequestsState {
  const FriendRequestsErrorState();
}

class FriendLoadingState extends FriendRequestsState {
  const FriendLoadingState();
}
