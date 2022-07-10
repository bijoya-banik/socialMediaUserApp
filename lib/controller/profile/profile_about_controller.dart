import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/models/auth/user_model.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileAboutProvider = StateNotifierProvider<ProfileAboutController,ProfileAboutState>(
  (ref) => ProfileAboutController(ref: ref),
);

class ProfileAboutController extends StateNotifier<ProfileAboutState> {
  final Ref? ref;
  ProfileAboutController({this.ref}) : super(const ProfileAboutInitialState());

  ProfileOverviewModel? profileOverviewModel;
  ProfileOverviewModel? myProfileOverviewModel;

  updateSuccessState(profileOverviewData) {
    state = ProfileAboutSuccessState(profileOverviewData);
  }

  Future fetchProfileAbout(String userName) async {
    state = const ProfileAboutLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.profileDetails(userName, tab: 'about')),
      );
      if (responseBody != null) {
        profileOverviewModel = ProfileOverviewModel.fromJson(responseBody);
        final UserModel myUserData = ref!.read(userProvider.notifier).userData!;
        if (userName == myUserData.user!.username) myProfileOverviewModel = profileOverviewModel;
        state = ProfileAboutSuccessState(profileOverviewModel!);
      } else {
        state = const ProfileAboutErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchProfileFeed(): $error");
      print(stackTrace);
      state = const ProfileAboutErrorState();
    }
  }
}
