import 'package:buddyscripts/controller/group/state/group_about_state.dart';
import 'package:buddyscripts/models/group/group_about_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupAboutProvider = StateNotifierProvider<GroupAboutController,GroupAboutState>(
  (ref) => GroupAboutController(ref: ref),
);

class GroupAboutController extends StateNotifier<GroupAboutState> {
  final Ref? ref;
  GroupAboutController({this.ref}) : super(const GroupAboutInitialState());

  GroupAboutModel? groupAboutModel;

  Future fetchGroupAbout(String groupName) async {
    state = const GroupAboutLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groupDetails(groupName, tab: 'about')),
      );
      if (responseBody != null) {
        groupAboutModel = GroupAboutModel.fromJson(responseBody);
        state = GroupAboutSuccessState(groupAboutModel!);
      } else {
        state = const GroupAboutErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchGroupAbout(): $error");
      print(stackTrace);
      state = const GroupAboutErrorState();
    }
  }
}
