import 'package:buddyscripts/controller/group/state/discover_groups_state.dart';
import 'package:buddyscripts/controller/pagination/group/discover_groups_scroll_provider.dart';
import 'package:buddyscripts/models/group/groups_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final discoverGroupsProvider = StateNotifierProvider<DiscoverGroupsController,DiscoverGroupsState>(
  (ref) => DiscoverGroupsController(ref: ref),
);

class DiscoverGroupsController extends StateNotifier<DiscoverGroupsState> {
  final Ref? ref;
  DiscoverGroupsController({this.ref}) : super(const DiscoverGroupsInitialState());

  GroupsModel? discoverGroupsModel;
  int currentPage = 1;

  updateSuccessState(GroupsModel groupsModel) {
    discoverGroupsModel = groupsModel;
    state = DiscoverGroupsSuccessState(discoverGroupsModel!);
  }

  Future fetchDiscoverGroupList() async {
    state = const DiscoverGroupsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groups(tab: 'discover')),
      );
      if (responseBody != null) {
        discoverGroupsModel = GroupsModel.fromJson(responseBody);
        currentPage = discoverGroupsModel!.meta!.currentPage!;
        state = DiscoverGroupsSuccessState(discoverGroupsModel!);
      } else {
        state = const DiscoverGroupsErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const DiscoverGroupsErrorState();
    }
  }

  Future fetchMoreDiscoverGroups() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groups(tab: 'discover', page: currentPage += 1)),
      );
      if (responseBody != null) {
        var discoverGroupsModelInstance = GroupsModel.fromJson(responseBody);
        discoverGroupsModel!.data!.addAll(discoverGroupsModelInstance.data!);
        state = DiscoverGroupsSuccessState(discoverGroupsModel!);
        ref!.read(discoverGroupsScrollProvider.notifier).resetState();
      } else {
        state = const DiscoverGroupsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreDiscoverGroups(): $error");
      print(stackTrace);
      state = const DiscoverGroupsErrorState();
    }
  }
}
