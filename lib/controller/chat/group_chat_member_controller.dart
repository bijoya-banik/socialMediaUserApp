import 'package:buddyscripts/controller/chat/group_chat_admin_controller.dart';
import 'package:buddyscripts/controller/chat/state/group_chat_member_state.dart';
import 'package:buddyscripts/models/group_chat/group_chat_members_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupChatMemberProvider = StateNotifierProvider<GroupChatMemberController, GroupChatMemberState>(
  (ref) => GroupChatMemberController(ref: ref),
);

class GroupChatMemberController extends StateNotifier<GroupChatMemberState> {
  final Ref? ref;

  GroupChatMemberController({this.ref}) : super(const GroupChatMemberInitialState());
  List<GroupChatMemberModel>? groupChatAllMemberModel;

  Future fetchGroupChatAllMembers(int id) async {
   // if (groupChatAllMemberModel == null) {
      state = const GroupChatMemberLoadingState();
   // }
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.getAllChatMembers(id)));
      print(responseBody);
      if (responseBody != null) {
        groupChatAllMemberModel = (responseBody as List<dynamic>).map((e) => GroupChatMemberModel.fromJson(e)).toList();

        state = GroupChatMemberSuccessState(groupChatAllMemberModel!);
      } else {
        state = const GroupChatMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupChatMemberErrorState();
    }
  }

  Future addMember({required inboxId, required List userId}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'inbox_id': inboxId, 'user_id': userId};
    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.addNewChatMember, requestBody));

      await fetchGroupChatAllMembers(inboxId);

      NavigationService.popNavigate();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future removeMember({required inboxId, required buddyId}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'inbox_id': inboxId, 'buddy_id': buddyId};
    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.removeChatMember, requestBody));

      final groupChatAdminList = ref!.read(groupChatAdminProvider.notifier).groupChatAdminModel;
      if (groupChatAdminList.isNotEmpty) {
        groupChatAdminList.removeWhere((element) => element.userId == buddyId);
        ref!.read(groupChatAdminProvider.notifier).updateSuccessState(groupChatAdminList);
      }

      groupChatAllMemberModel!.removeWhere((element) => element.userId == buddyId);

      state = GroupChatMemberSuccessState(groupChatAllMemberModel!);

      NavigationService.popNavigate();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future removeAdminRole({required inboxId, required buddyId}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'inbox_id': inboxId, 'buddy_id': buddyId};
    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.removeChatAdminRole, requestBody));

      final groupChatAdminList = ref!.read(groupChatAdminProvider.notifier).groupChatAdminModel;
      groupChatAdminList.removeWhere((element) => element.userId == buddyId);
      ref!.read(groupChatAdminProvider.notifier).updateSuccessState(groupChatAdminList);
      int userIndex;
      userIndex = groupChatAllMemberModel!.indexWhere((element) => element.userId == buddyId);

      if (userIndex != -1) {
        groupChatAllMemberModel![userIndex].role = "USER";
      }
      state = GroupChatMemberSuccessState(groupChatAllMemberModel!);

      NavigationService.popNavigate();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future makeAdmin({required GroupChatMemberModel groupMember}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'inbox_id': groupMember.inboxId, 'buddy_id': groupMember.userId};
    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.makeChatAdmin, requestBody));

      List<GroupChatMemberModel> groupChatAdminList = ref!.read(groupChatAdminProvider.notifier).groupChatAdminModel;
      groupChatAdminList.add(groupMember);
      ref!.read(groupChatAdminProvider.notifier).updateSuccessState(groupChatAdminList);
      int userIndex;
      userIndex = groupChatAllMemberModel!.indexWhere((element) => element.userId == groupMember.userId);

      if (userIndex != -1) {
        groupChatAllMemberModel![userIndex].role = "ADMIN";
      }
      state = GroupChatMemberSuccessState(groupChatAllMemberModel!);

      NavigationService.popNavigate();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }
}
