import 'package:buddyscripts/controller/group/state/joined_groups_state.dart';
import 'package:buddyscripts/controller/pagination/group/joined_groups_scroll_provider.dart';
import 'package:buddyscripts/models/group/groups_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final joinedGroupsProvider = StateNotifierProvider<JoinedGroupsController,JoinedGroupsState>(
  (ref) => JoinedGroupsController(ref: ref),
);

class JoinedGroupsController extends StateNotifier<JoinedGroupsState> {
  final Ref? ref;
  JoinedGroupsController({this.ref}) : super(const JoinedGroupsInitialState());

  GroupsModel? joinedGroupsModel;
  int currentPage = 1;

  updateSuccessState(GroupsModel groupsModel) {
    joinedGroupsModel = groupsModel;
    state = JoinedGroupsSuccessState(joinedGroupsModel!);
  }

  Future fetchJoinedGroupList() async {
    state = const JoinedGroupsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groups(tab: 'joinedGroups')),
      );
      if (responseBody != null) {
        joinedGroupsModel = GroupsModel.fromJson(responseBody);
        currentPage = joinedGroupsModel!.meta!.currentPage!;
        state = JoinedGroupsSuccessState(joinedGroupsModel!);
      } else {
        state = const JoinedGroupsErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const JoinedGroupsErrorState();
    }
  }

  Future fetchMoreJoinedGroups() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groups(tab: 'joinedGroups', page: currentPage += 1)),
      );
      if (responseBody != null) {
        var joinedGroupsModelInstance = GroupsModel.fromJson(responseBody);
        joinedGroupsModel!.data!.addAll(joinedGroupsModelInstance.data!);
        state = JoinedGroupsSuccessState(joinedGroupsModel!);
        ref!.read(joinedGroupsScrollProvider.notifier).resetState();
      } else {
        state = const JoinedGroupsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreJoinedGroups(): $error");
      print(stackTrace);
      state = const JoinedGroupsErrorState();
    }
  }
}
