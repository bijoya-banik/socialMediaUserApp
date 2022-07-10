import 'package:buddyscripts/controller/pagination/profile/profile_videos_tab.dart';
import 'package:buddyscripts/controller/profile/state/profile_videos_state.dart';
import 'package:buddyscripts/models/profile/profile_videos_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileVideosProvider = StateNotifierProvider<ProfileVideosController,ProfileVideosState>(
  (ref) => ProfileVideosController(ref: ref),
);

class ProfileVideosController extends StateNotifier<ProfileVideosState> {
  final Ref? ref;
  ProfileVideosController({this.ref}) : super(const ProfileVideosInitialState());

  ProfileVideosModel? profileVideosModel;

  Future fetchProfileVideos(String userName) async {
    state = const ProfileVideosLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.profileDetails(userName, tab: 'videos')),
      );
      if (responseBody != null) {
        profileVideosModel = ProfileVideosModel.fromJson(responseBody);
        state = ProfileVideosSuccessState(profileVideosModel!);
      } else {
        state = const ProfileVideosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchProfileVideos(): $error");
      print(stackTrace);
      state = const ProfileVideosErrorState();
    }
  }

  Future fetchMoreProfileVideos(String userName) async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.profileDetails(userName, tab: 'videos', lastId: profileVideosModel!.videos!.last.id)),
      );
      if (responseBody != null) {
        var profileVideosModelInstance = (responseBody['videos'] as List<dynamic>).map((x) => Video.fromJson(x)).toList();
        profileVideosModel!.videos!.addAll(profileVideosModelInstance);
        state = ProfileVideosSuccessState(profileVideosModel!);
        ref!.read(profileVideosScrollProvider.notifier).resetState();
      } else {
        state = const ProfileVideosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchProfileVideos(): $error");
      print(stackTrace);
      state = const ProfileVideosErrorState();
    }
  }
}
