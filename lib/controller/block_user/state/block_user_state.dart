import 'package:buddyscripts/models/block_user/block_user_model.dart';

abstract class BlockUserState {
  const BlockUserState();
}

class BlockUserInitialState extends BlockUserState {
  const BlockUserInitialState();
}

class BlockUserLoadingState extends BlockUserState {
  const BlockUserLoadingState();
}

class BlockUserSuccessState extends BlockUserState {
  final BlockUserModel blockUserModel;
  const BlockUserSuccessState(this.blockUserModel);
}

class BlockUserErrorState extends BlockUserState {
  const BlockUserErrorState();
}



class BlockedUserErrorState extends BlockUserState {
  const BlockedUserErrorState();
}

class UnblockedUserErrorState extends BlockUserState {
  const UnblockedUserErrorState();
}
