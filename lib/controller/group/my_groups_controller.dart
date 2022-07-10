import 'package:buddyscripts/controller/group/state/my_groups_state.dart';
import 'package:buddyscripts/controller/pagination/group/my_groups_scroll_provider.dart';
import 'package:buddyscripts/models/group/groups_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myGroupsProvider = StateNotifierProvider<MyGroupsController,MyGroupsState>(
  (ref) => MyGroupsController(ref: ref),
);

class MyGroupsController extends StateNotifier<MyGroupsState> {
  final Ref? ref;
  MyGroupsController({this.ref}) : super(const MyGroupsInitialState());

  GroupsModel? myGroupsModel;
  int currentPage = 1;

  updateSuccessState(GroupsModel groupsModel) {
    myGroupsModel = groupsModel;
    state = MyGroupsSuccessState(myGroupsModel!);
  }

  Future fetchMyGroupList() async {
    state = const MyGroupsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groups(tab: 'mygroups')),
      );
      if (responseBody != null) {
        myGroupsModel = GroupsModel.fromJson(responseBody);
        currentPage = myGroupsModel!.meta!.currentPage!;
        state = MyGroupsSuccessState(myGroupsModel!);
      } else {
        state = const MyGroupsErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const MyGroupsErrorState();
    }
  }

  Future fetchMoreMyGroups() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groups(tab: 'mygroups', page: currentPage += 1)),
      );
      if (responseBody != null) {
        var myGroupsModelInstance = GroupsModel.fromJson(responseBody);
        myGroupsModel!.data!.addAll(myGroupsModelInstance.data!);
        state = MyGroupsSuccessState(myGroupsModel!);
        ref!.read(myGroupsScrollProvider.notifier).resetState();
      } else {
        state = const MyGroupsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreMyGroups(): $error");
      print(stackTrace);
      state = const MyGroupsErrorState();
    }
  }
}
