import 'package:buddyscripts/controller/group/state/group_videos_state.dart';
import 'package:buddyscripts/models/group/group_videos_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupVideosProvider = StateNotifierProvider<GroupVideosController,GroupVideosState>(
  (ref) => GroupVideosController(ref: ref),
);

class GroupVideosController extends StateNotifier<GroupVideosState> {
  final Ref? ref;
  GroupVideosController({this.ref}) : super(const GroupVideosInitialState());

  GroupVideosModel? groupVideosModel;

  Future fetchGroupVideos(String groupName) async {
    state = const GroupVideosLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groupDetails(groupName, tab: 'videos')),
      );
      if (responseBody != null) {
        groupVideosModel = GroupVideosModel.fromJson(responseBody);
        state = GroupVideosSuccessState(groupVideosModel!);
      } else {
        state = const GroupVideosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchGroupVideos(): $error");
      print(stackTrace);
      state = const GroupVideosErrorState();
    }
  }
}
