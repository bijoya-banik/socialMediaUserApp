import 'package:buddyscripts/controller/chat/state/chat_friends_state.dart';
import 'package:buddyscripts/models/chats/chat_friends_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatFriendsProvider = StateNotifierProvider<ChatFriendsController,ChatFriendsState>(
  (ref) => ChatFriendsController(ref: ref),
);

class ChatFriendsController extends StateNotifier<ChatFriendsState> {
  final Ref? ref;
  ChatFriendsController({this.ref}) : super(const ChatFriendsInitialState());

  ChatFriendsModel? chatFriendsModel;

  updateSuccessState(ChatFriendsModel chatFriendsModelInstance) {
    chatFriendsModel = chatFriendsModelInstance;
    state = ChatFriendsSuccessState(chatFriendsModel!);
  }

  Future fetchChatFriends() async {
    state = const ChatFriendsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.chatFriends),
      );
      if (responseBody != null) {
        chatFriendsModel = ChatFriendsModel.fromJson(responseBody);
        state = ChatFriendsSuccessState(chatFriendsModel!);
      } else {
        state = const ChatFriendsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchChatFriends(): $error");
      print(stackTrace);
      state = const ChatFriendsErrorState();
    }
  }

  refreshState() {
    state = ChatFriendsSuccessState(chatFriendsModel!);
  }
}
