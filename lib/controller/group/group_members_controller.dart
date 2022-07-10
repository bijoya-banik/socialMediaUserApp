import 'package:buddyscripts/controller/group/state/group_members_state.dart';
import 'package:buddyscripts/models/group/group_members_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupMembersProvider = StateNotifierProvider<GroupMembersController,GroupMembersState>(
  (ref) => GroupMembersController(ref: ref),
);

class GroupMembersController extends StateNotifier<GroupMembersState> {
  final Ref? ref;
  GroupMembersController({this.ref}) : super(const GroupMembersInitialState());

  GroupMembersModel? groupMembersModel;

  updateSuccessState(GroupMembersModel groupMembers) {
    groupMembersModel = groupMembers;
    state = GroupMembersSuccessState(groupMembersModel!);
  }

  Future fetchGroupMembers(String groupName) async {
    state = const GroupMembersLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groupDetails(groupName, tab: 'members')),
      );
      if (responseBody != null) {
        groupMembersModel = GroupMembersModel.fromJson(responseBody);
        state = GroupMembersSuccessState(groupMembersModel!);
      } else {
        state = const GroupMembersErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchGroupMembers(): $error");
      print(stackTrace);
      state = const GroupMembersErrorState();
    }
  }
}
