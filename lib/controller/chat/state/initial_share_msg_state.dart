
import 'package:buddyscripts/models/chats/conversations_model.dart';

abstract class InitialShareMsgState {
  const InitialShareMsgState();
}

class InitialShareMsgInitialState extends InitialShareMsgState {
  const InitialShareMsgInitialState();
}

class InitialShareMsgLoadingState extends InitialShareMsgState {
  const InitialShareMsgLoadingState();
}

class InitialShareMsgSuccessState extends InitialShareMsgState {
  final List<ConversationsModel> initialShareMsg;
  const InitialShareMsgSuccessState(this.initialShareMsg);
}

class InitialShareMsgErrorState extends InitialShareMsgState {
  const InitialShareMsgErrorState();
}
