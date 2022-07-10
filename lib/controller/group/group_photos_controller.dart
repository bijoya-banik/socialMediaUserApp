import 'package:buddyscripts/controller/group/state/group_photos_state.dart';
import 'package:buddyscripts/models/group/group_photos_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupPhotosProvider = StateNotifierProvider<GroupPhotosController,GroupPhotosState>(
  (ref) => GroupPhotosController(ref: ref),
);

class GroupPhotosController extends StateNotifier<GroupPhotosState> {
  final Ref? ref;
  GroupPhotosController({this.ref}) : super(const GroupPhotosInitialState());

  GroupPhotosModel? groupPhotosModel;

  Future fetchGroupPhotos(String groupName) async {
    state = const GroupPhotosLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.groupDetails(groupName, tab: 'photos')),
      );
      if (responseBody != null) {
        groupPhotosModel = GroupPhotosModel.fromJson(responseBody);
        state = GroupPhotosSuccessState(groupPhotosModel!);
      } else {
        state = const GroupPhotosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchGroupPhotos(): $error");
      print(stackTrace);
      state = const GroupPhotosErrorState();
    }
  }
}
