import 'package:buddyscripts/controller/chat/state/group_chat_admin_state.dart';
import 'package:buddyscripts/models/group_chat/group_chat_members_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupChatAdminProvider = StateNotifierProvider<GroupChatAdminController, GroupChatAdminState>(
  (ref) => GroupChatAdminController(ref: ref),
);

class GroupChatAdminController extends StateNotifier<GroupChatAdminState> {
  final Ref? ref;

  GroupChatAdminController({this.ref}) : super( const GroupChatAdminInitialState());
  List<GroupChatMemberModel> groupChatAdminModel=[];

    updateSuccessState(List<GroupChatMemberModel> groupChatAdminModel) {
    state = GroupChatAdminSuccessState(groupChatAdminModel);
  }

  Future fetchGroupChatAdmins(int id) async {
    // if (groupChatAdminModel.isEmpty) {
      state = const GroupChatAdminLoadingState();
 //   }
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.getAllChatAdmins(id)));
      print(responseBody);
      if (responseBody != null) {
        groupChatAdminModel = (responseBody as List<dynamic>).map((e) => GroupChatMemberModel.fromJson(e)).toList();

        state = GroupChatAdminSuccessState(groupChatAdminModel);
      } else {
        state = const GroupChatAdminErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupChatAdminErrorState();
    }
  }
}
