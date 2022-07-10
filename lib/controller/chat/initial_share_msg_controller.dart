import 'package:buddyscripts/controller/chat/state/initial_share_msg_state.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialShareMsgProvider = StateNotifierProvider<InitialShareMsgController, InitialShareMsgState>(
  (ref) => InitialShareMsgController(ref: ref),
);

class InitialShareMsgController extends StateNotifier<InitialShareMsgState> {
  final Ref? ref;

  InitialShareMsgController({this.ref}) : super(const InitialShareMsgInitialState());
  List<ConversationsModel>? conversations = [];

  Future fetchConversations({bool isLoading = true, bool socket = false}) async {
    if (isLoading) state = const InitialShareMsgLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.conversations),
      );
      if (responseBody != null) {
        conversations = (responseBody as List<dynamic>).map((e) => ConversationsModel.fromJson(e)).toList();

        if (socket) conversations?.first.isSeen = 1;
        state = InitialShareMsgSuccessState(conversations!);
      } else {
        state = const InitialShareMsgErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchConversations(): $error");
      print(stackTrace);
      state = const InitialShareMsgErrorState();
    }
  }
}
