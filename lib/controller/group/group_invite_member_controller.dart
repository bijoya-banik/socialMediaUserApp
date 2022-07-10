import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/controller/group/group_members_controller.dart';
import 'package:buddyscripts/controller/group/state/group_invite_member_state.dart';
import 'package:buddyscripts/models/group/group_feed_model.dart';
import 'package:buddyscripts/models/group/group_invite_member_model.dart';
import 'package:buddyscripts/models/group/group_members_model.dart' as member;
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupInviteMemberProvider = StateNotifierProvider<GroupInviteMemberController,GroupInviteMemberState>(
  (ref) => GroupInviteMemberController(ref: ref),
);

class GroupInviteMemberController extends StateNotifier<GroupInviteMemberState> {
  final Ref? ref;
  GroupInviteMemberController({this.ref}) : super(const GroupInviteMemberInitialState());

  List<GroupInviteMemberModel> groupInviteMemberModel = [];
  List<GroupInviteMemberModel> groupInviteMemberSearchResultModel = [];

  Future fetchSuggestedMembers(int groupId) async {
    state = const GroupInviteMemberLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.invitedMemberListGroup(groupId)),
      );
      if (responseBody != null) {
        groupInviteMemberModel = (responseBody as List<dynamic>).map((x) => GroupInviteMemberModel.fromJson(x)).toList();
        state = GroupInviteMemberSuccessState(groupInviteMemberModel);
      } else {
        state = const GroupInviteMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupInviteMemberErrorState();
    }
  }

  Future changeState() async {
    List<GroupInviteMemberModel> groupinviteMembersModel = ref!.read(groupInviteMemberProvider.notifier).groupInviteMemberModel;
    state = GroupInviteMemberSuccessState(groupinviteMembersModel);
  }

  Future searchMembers({required int groupId, String searchedString = ""}) async {
    state = const GroupInviteMemberLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.searchMemberGroup(groupId, searchedString)),
      );
      if (responseBody != null) {
        groupInviteMemberSearchResultModel = (responseBody as List<dynamic>).map((e) => GroupInviteMemberModel.fromJson(e)).toList();
        state = GroupInviteMemberSearchResultSuccessState(groupInviteMemberSearchResultModel);
      } else {
        state = const GroupInviteMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupInviteMemberErrorState();
    }
  }

  Future inviteMemberToGroup({required int userId, required int groupId, bool search = false}) async {
    dynamic responseBody;
    var requestBody = {
      'group_id': groupId,
      'user_id': userId,
    };
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.inviteMemberToGroup, requestBody),
      );
      if (responseBody != null) {
        if (search) {
          groupInviteMemberSearchResultModel[groupInviteMemberSearchResultModel.indexWhere((element) => element.id == userId)].status = "invited";
          state = GroupInviteMemberSearchResultSuccessState(groupInviteMemberSearchResultModel);
        } else {
          groupInviteMemberModel[groupInviteMemberModel.indexWhere((element) => element.id == userId)].status = "invited";
          state = GroupInviteMemberSuccessState(groupInviteMemberModel);
        }

        BasicOverView? groupOverview = ref!.read(groupFeedProvider.notifier).groupFeedList!.basicOverView;
        BasicOverView groupBasicOverview = BasicOverView(
          id: groupOverview!.id,
          groupName: groupOverview.groupName,
          slug: groupOverview.slug,
          profilePic: groupOverview.profilePic,
          cover: groupOverview.cover,
          about: groupOverview.about,
          country: groupOverview.country,
          city: groupOverview.city,
          address: groupOverview.address,
          groupPrivacy: groupOverview.groupPrivacy == 'Public' ? 'PUBLIC' : 'ONLY ME',
          totalMembers: groupOverview.totalMembers! + 1,
          categoryName: groupOverview.categoryName,
          isMember: groupOverview.isMember,
          meta: groupOverview.meta,
        );
        ref!.read(groupFeedProvider.notifier).updateGroupDetails(groupBasicOverview);
      } else {
        state = const GroupInviteMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupInviteMemberErrorState();
    }
  }

  Future removeMember({groupId, userId}) async {
    dynamic responseBody;
    var requestBody = {
      'group_id': groupId,
      'user_id': userId,
    };
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.removeMember, requestBody),
      );
      if (responseBody != null) {
        member.GroupMembersModel? groupMembersModel = ref!.read(groupMembersProvider.notifier).groupMembersModel;
        groupMembersModel!.allMembers!.removeWhere((element) => element.userId == userId);

        ref!.read(groupMembersProvider.notifier).updateSuccessState(groupMembersModel);

        BasicOverView? groupOverview = ref!.read(groupFeedProvider.notifier).groupFeedList!.basicOverView;
        BasicOverView groupBasicOverview = BasicOverView(
          id: groupOverview!.id,
          groupName: groupOverview.groupName,
          slug: groupOverview.slug,
          profilePic: groupOverview.profilePic,
          cover: groupOverview.cover,
          about: groupOverview.about,
          country: groupOverview.country,
          city: groupOverview.city,
          address: groupOverview.address,
          groupPrivacy: groupOverview.groupPrivacy,
          totalMembers: groupOverview.totalMembers! - 1,
          categoryName: groupOverview.categoryName,
          isMember: groupOverview.isMember,
          meta: groupOverview.meta,
        );
        ref!.read(groupFeedProvider.notifier).updateGroupDetails(groupBasicOverview);
        NavigationService.popNavigate();
      } else {
        state = const GroupInviteMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupInviteMemberErrorState();
    }
  }

  Future makeAdmin({groupId, userData}) async {
    dynamic responseBody;
    var requestBody = {
      'group_id': groupId,
      'user_id': userData.userId,
    };
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.makeAdmin, requestBody),
      );
      if (responseBody != null) {
        member.GroupMembersModel? groupMembersModel = ref!.read(groupMembersProvider.notifier).groupMembersModel;
        groupMembersModel!.allMembers!.removeWhere((element) => element.userId == userData.userId);
        member.GroupMember groupMemberInstance = member.GroupMember(
          id: userData.id,
          userId: userData.userId,
          groupId: userData.groupId,
          isAdmin: "admin",
          createdAt: userData.createdAt,
          updatedAt: userData.updatedAt,
          user: userData.user,
        );
        groupMembersModel.adminAndModerators!.add(groupMemberInstance);
        ref!.read(groupMembersProvider.notifier).updateSuccessState(groupMembersModel);
      } else {
        state = const GroupInviteMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupInviteMemberErrorState();
    }
  }

  Future removeAdmin({groupId, userData}) async {
    dynamic responseBody;
    var requestBody = {
      'group_id': groupId,
      'user_id': userData.userId,
    };
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.removeAdmin, requestBody),
      );
      if (responseBody != null) {
        member.GroupMembersModel? groupMembersModel = ref!.read(groupMembersProvider.notifier).groupMembersModel;
        groupMembersModel!.adminAndModerators!.removeWhere((element) => element.userId == userData.userId);
        member.GroupMember groupMemberInstance = member.GroupMember(
          id: userData.id,
          userId: userData.userId,
          groupId: userData.groupId,
          isAdmin: "user",
          createdAt: userData.createdAt,
          updatedAt: userData.updatedAt,
          user: userData.user,
        );
        groupMembersModel.allMembers!.add(groupMemberInstance);
        ref!.read(groupMembersProvider.notifier).updateSuccessState(groupMembersModel);
      } else {
        state = const GroupInviteMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupInviteMemberErrorState();
    }
  }
}
