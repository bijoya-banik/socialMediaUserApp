

import 'package:buddyscripts/controller/chat/state/share_msg_state.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shareMsgProvider = StateNotifierProvider<SharedMsgController,ShareMsgState>(
  (ref) => SharedMsgController(ref: ref),
);

class SharedMsgController extends StateNotifier<ShareMsgState> {
  final Ref? ref;

  SharedMsgController({this.ref}) : super(const ShareMsgInitialState());
  List<ConversationsModel> conversations = [];

  Future fetchRecentChatList({bool isLoading = true,bool socket = false}) async {
    if (isLoading) state = const ShareMsgLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.conversations),
      );
      if (responseBody != null) {
        conversations = (responseBody as List<dynamic>)
            .map((e) => ConversationsModel.fromJson(e))
            .toList();

            if(socket) conversations.first.isSeen =1;
        state = ShareMsgSuccessState(conversations);
      } else {
        state = const ShareMsgErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchConversations(): $error");
      print(stackTrace);
      state = const ShareMsgErrorState();
    }
  }

  refreshState() {
    state = ShareMsgSuccessState(conversations);
  }
}
