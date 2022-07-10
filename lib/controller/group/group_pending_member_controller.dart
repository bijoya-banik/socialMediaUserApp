import 'package:buddyscripts/controller/group/state/group_pending_member_state.dart';
import 'package:buddyscripts/models/group/group_pending_member_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupPendingMemberProvider = StateNotifierProvider<GroupPendingMemberController,GroupPendingMemberState>(
  (ref) => GroupPendingMemberController(ref: ref),
);

class GroupPendingMemberController extends StateNotifier<GroupPendingMemberState> {
  final Ref? ref;
  GroupPendingMemberController({this.ref}) : super(const GroupPendingMemberInitialState());

  List<GroupPendingMemberModel> groupPendingMemberModel = [];

  Future fetchGroupPendingMember(groupId) async {
    state = const GroupPendingMemberLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(
        API.groupPendingMember(grpId: groupId),
      ));
      if (responseBody != null) {
        groupPendingMemberModel = (responseBody as List<dynamic>).map((x) => GroupPendingMemberModel.fromJson(x)).toList();
        state = GroupPendingMemberSuccessState(groupPendingMemberModel);
      } else {
        state = const GroupPendingMemberErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchGroupPendingMember(): $error");
      print(stackTrace);
      state = const GroupPendingMemberErrorState();
    }
  }

  Future deleteRequest({friendId, grpId}) async {
    dynamic responseBody;

    var requestBody = {'user_id': friendId, 'group_id': grpId};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deleteMember, requestBody));

      if (responseBody != null) {
        groupPendingMemberModel.removeWhere((element) => element.userId == friendId);
        state = GroupPendingMemberSuccessState(groupPendingMemberModel);
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future acceptRequest({friendId, grpId}) async {
    dynamic responseBody;

    var requestBody = {'user_id': friendId, 'group_id': grpId};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.acceptMember, requestBody));

      if (responseBody != null) {
        groupPendingMemberModel.removeWhere((element) => element.userId == friendId);
        state = GroupPendingMemberSuccessState(groupPendingMemberModel);
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }
}
