import 'package:buddyscripts/controller/pagination/profile/profile_photos_tab.dart';
import 'package:buddyscripts/controller/profile/state/profile_photos_state.dart';
import 'package:buddyscripts/models/profile/profile_photos_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profilePhotosProvider = StateNotifierProvider<ProfilePhotosController,ProfilePhotosState>(
  (ref) => ProfilePhotosController(ref: ref),
);

class ProfilePhotosController extends StateNotifier<ProfilePhotosState> {
  final Ref? ref;
  ProfilePhotosController({this.ref}) : super(const ProfilePhotosInitialState());

  ProfilePhotosModel? profilePhotosModel;

  Future fetchProfilePhotos(String userName) async {
    state = const ProfilePhotosLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.profileDetails(userName, tab: 'photos')),
      );
      if (responseBody != null) {
        profilePhotosModel = ProfilePhotosModel.fromJson(responseBody);
        state = ProfilePhotosSuccessState(profilePhotosModel!);
      } else {
        state = const ProfilePhotosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchProfilePhotos(): $error");
      print(stackTrace);
      state = const ProfilePhotosErrorState();
    }
  }

  Future fetchMoreProfilePhotos(String userName) async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.profileDetails(userName, tab: 'photos', lastId: profilePhotosModel!.photos!.last.id)),
      );
      if (responseBody != null) {
        var profilePhotosModelInstance = (responseBody['photos'] as List<dynamic>).map((x) => Photo.fromJson(x)).toList();
        profilePhotosModel!.photos!.addAll(profilePhotosModelInstance);
        state = ProfilePhotosSuccessState(profilePhotosModel!);
        ref!.read(profilePhotosScrollProvider.notifier).resetState();
      } else {
        state = const ProfilePhotosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchProfilePhotos(): $error");
      print(stackTrace);
      state = const ProfilePhotosErrorState();
    }
  }
}
