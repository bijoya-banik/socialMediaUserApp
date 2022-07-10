import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/conversations_state.dart';

final conversationsProvider = StateNotifierProvider<ConversationsController, ConversationsState>(
  (ref) => ConversationsController(ref: ref),
);

class ConversationsController extends StateNotifier<ConversationsState> {
  final Ref? ref;

  ConversationsController({this.ref}) : super(const ConversationsInitialState());
  List<ConversationsModel>? conversations = [];

  Future fetchConversations({bool isLoading = true, bool socket = false}) async {
    if (isLoading) state = const ConversationsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.conversations),
      );
      if (responseBody != null) {
        conversations = (responseBody as List<dynamic>).map((e) => ConversationsModel.fromJson(e)).toList();

        if (socket) conversations?.first.isSeen = 1;
        state = ConversationsSuccessState(conversations!);
      } else {
        state = const ConversationsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchConversations(): $error");
      print(stackTrace);
      state = const ConversationsErrorState();
    }
  }

  Future deleteConversation(buddyId) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {
      'buddy_id': buddyId,
    };

    /// Remove the conversation instantly
    conversations!.removeWhere((chat) => chat.buddyId == buddyId);
    state = ConversationsSuccessState(conversations!);

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deleteConversation, requestBody));
      if (conversations != null) {
        // int index = conversations!.indexWhere(((element) => element.buddyId == buddyId));
        // conversations![index].lastmsg = Lastmsg(msg: null);
        // state = ConversationsSuccessState(conversations!);
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future seenConversation(conId, buddyId) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {
      'id': conId,
    };
    state = ConversationsSuccessState(conversations!);

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.seenConversation, requestBody));
      if (conversations != null) {
        int index = conversations!.indexWhere(((element) => element.buddyId == buddyId));
        conversations![index].isSeen = 1;
      }
      state = ConversationsSuccessState(conversations!);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future unseenConversation(conId, buddyId) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {
      'id': conId,
    };

    state = ConversationsSuccessState(conversations!);

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.unseenConversation, requestBody));
      if (conversations != null) {
        int index = conversations!.indexWhere(((element) => element.buddyId == buddyId));
        conversations![index].isSeen = 0;
      }
      state = ConversationsSuccessState(conversations!);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  refreshState() {
    state = ConversationsSuccessState(conversations!);
  }
  
  updateState(List<ConversationsModel>? conversations) {
    state = ConversationsSuccessState(conversations!);
  }
}
