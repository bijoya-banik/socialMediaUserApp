import 'package:buddyscripts/controller/pagination/group/group_feed_tab.dart';
import 'package:buddyscripts/controller/group/state/group_feed_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/group/group_feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupFeedProvider = StateNotifierProvider<GroupFeedController,GroupFeedState>(
  (ref) => GroupFeedController(ref: ref),
);

class GroupFeedController extends StateNotifier<GroupFeedState> {
  final Ref? ref;
  GroupFeedController({this.ref}) : super(const GroupFeedInitialState());

  GroupFeedModel? groupFeedList;

  updateSuccessState(List<FeedModel> feedList) {
    if (groupFeedList != null) {
      groupFeedList!.feedData = feedList;
    state = GroupFeedSuccessState(groupFeedList!);
    }
  }

  updateGroupDetails(BasicOverView groupDetails) {
    if (groupFeedList != null) groupFeedList!.basicOverView = groupDetails;
    state = GroupFeedSuccessState(groupFeedList!);
  }

  Future fetchGroupFeed(String groupName) async {
    state = const GroupFeedLoadingState();

    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.groupDetails(groupName)));

      if (responseBody != null) {
        groupFeedList = GroupFeedModel.fromJson(responseBody);
        state = GroupFeedSuccessState(groupFeedList!);
      } else {
        state = const GroupFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupFeedErrorState();
    }
  }

  Future fetchMoreGroupFeed(String groupName) async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
          await Network.getRequest(API.groupDetails(groupName, lastId: groupFeedList!.feedData!.isEmpty ? "" : groupFeedList!.feedData!.last.id)));

      if (responseBody != null) {
        var groupFeedModelInstance = (responseBody['feedData'] as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();
        groupFeedList!.feedData!.addAll(groupFeedModelInstance);
        state = GroupFeedSuccessState(groupFeedList!);
        ref!.read(groupFeedScrollProvider.notifier).resetState();
      } else {
        state = const GroupFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupFeedErrorState();
    }
  }
}
