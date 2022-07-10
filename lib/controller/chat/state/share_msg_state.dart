

import 'package:buddyscripts/models/chats/conversations_model.dart';

abstract class ShareMsgState {
  const ShareMsgState();
}

class ShareMsgInitialState extends ShareMsgState {
  const ShareMsgInitialState();
}

class ShareMsgLoadingState extends ShareMsgState {
  const ShareMsgLoadingState();
}

class ShareMsgSuccessState extends ShareMsgState {
  final List<ConversationsModel> shareMsg;
  const ShareMsgSuccessState(this.shareMsg);
}

class ShareMsgErrorState extends ShareMsgState {
  const ShareMsgErrorState();
}
