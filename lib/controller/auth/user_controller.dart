import 'dart:convert';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/profile/my_profile_feed_controller.dart';
import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/startup/init_data_controller.dart';
import 'package:buddyscripts/models/auth/user_model.dart';
import 'package:buddyscripts/models/profile/profile_feed_model.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/services/socket_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/k_bottom_navigation_bar.dart';
import 'package:buddyscripts/views/screens/account/settings/change_email/verify_email_screen.dart';
import 'package:buddyscripts/views/screens/auth/login_screen.dart';
import 'package:buddyscripts/views/screens/auth/reset_password_screen.dart';
import 'package:buddyscripts/views/screens/auth/verify_account_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

final userProvider = StateNotifierProvider<UserController, UserState>((ref) => UserController(ref: ref));

class UserController extends StateNotifier<UserState> {
  final Ref? ref;
  UserModel? userData;

  UserController({this.ref}) : super(const UserInitialState());

  refreshState() {
    print("userData updated");
    state = UserSuccessState(userData!);
  }

  updateMessageSeen() {
    userData?.msgCount?.totalUnseen = 0;
    refreshState();
  }

  updateNotificationCount() {
    userData?.notiCount?.totalNoti = 0;
    refreshState();
  }

  increaseNotificationCount() {
    if (userData?.notiCount?.totalNoti == null) {
      userData!.notiCount?.totalNoti = 0;
    }
    userData?.notiCount?.totalNoti = (userData?.notiCount?.totalNoti)! + 1;
    refreshState();
  }

  decreaseNotificationCount() {
    if (userData?.notiCount!.totalNoti == null || (userData?.notiCount?.totalNoti)! <= 0) {
      userData!.notiCount?.totalNoti = 0;
    } else {
      userData?.notiCount?.totalNoti = (userData?.notiCount?.totalNoti)! - 1;
    }

    refreshState();
  }

  increaseMessageCount() {
    if (userData?.msgCount?.totalUnseen == null) {
      userData?.msgCount?.totalUnseen == 0;
    }

    if ((userData?.msgCount?.totalUnseen)! > 0) {
      userData?.msgCount?.totalUnseen = (userData?.msgCount?.totalUnseen)! + 1;
    }

    refreshState();
  }

  decreaseMessageCount() {
    if (userData?.msgCount?.totalUnseen == null) {
      userData?.msgCount?.totalUnseen == 0;
    }

    if ((userData?.msgCount?.totalUnseen)! > 0) {
      userData?.msgCount?.totalUnseen = (userData?.msgCount?.totalUnseen)! - 1;
    }

    refreshState();
  }

  increaseFriendRequestCount() {
    userData?.user?.friendCount = (userData?.user?.friendCount)! + 1;
    refreshState();
  }

  updateFriendRequestCount() {
    userData?.user?.friendCount = 0;

    refreshState();
  }

  Future fetchUserData() async {
    state = const UserLoadingState();
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.getUser));

      if (responseBody != null) {
        userData = UserModel.fromJson(responseBody);
        setValue(USER_ID, userData?.user!.id);
        state = UserSuccessState(userData!);
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future fetchOnline() async {
    // ignore: unused_local_variable
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.fetchOnline));
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future fetchseen() async {
    // ignore: unused_local_variable
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.fetchOnline));
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future updateUserData(
      {firstName, lastName, nickName, phone, website, birthDate, about, country, city, hometown, gender, workData, isWorkUpdate = false}) async {
    RegExp regExp = RegExp(r'(?:(?:https?|ftp|www):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

    // print('website =  $website');
    // website = website ?? "";

    if ((website != null && website != "") && (!(regExp.hasMatch(website)))) {
      toast("Plesae enter a valid url", bgColor: KColor.red);
    } else {
      ProfileOverviewModel? basicProfileData = ref!.read(profileAboutProvider.notifier).myProfileOverviewModel;
      ProfileFeedModel? myProfileData = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList;
      dynamic responseBody;
      var requestBody = {
        if (!isWorkUpdate) 'first_name': firstName ?? basicProfileData?.basicOverView?.firstName,
        if (!isWorkUpdate) 'last_name': lastName ?? basicProfileData?.basicOverView?.lastName,
        if (!isWorkUpdate) 'nick_name': nickName ?? basicProfileData?.basicOverView?.nickName,
        if (!isWorkUpdate) 'phone': phone ?? basicProfileData?.basicOverView?.phone,
        if (!isWorkUpdate) 'website': website ?? basicProfileData?.basicOverView?.website,
        if (!isWorkUpdate)
          'birth_date': birthDate == null || birthDate == ''
              ? (basicProfileData?.basicOverView?.birthDate == null ? null : DateTimeService.convert(basicProfileData?.basicOverView?.birthDate))
              : DateTimeService.convert(birthDate),
        if (!isWorkUpdate) 'about': about ?? basicProfileData?.basicOverView?.about,
        if (!isWorkUpdate) 'country': country ?? basicProfileData?.basicOverView?.country,
        if (!isWorkUpdate) 'current_city': city ?? basicProfileData?.basicOverView?.currentCity,
        if (!isWorkUpdate) 'home_town': hometown ?? basicProfileData?.basicOverView?.homeTown,
        if (!isWorkUpdate) 'gender': gender ?? basicProfileData?.basicOverView?.gender,
        if (isWorkUpdate) 'work_data': workData == null ? json.encode(basicProfileData?.basicOverView?.workData) : json.encode(workData),
      };

      try {
        responseBody = await Network.handleResponse(await Network.postRequest(API.updateBasicProfile, requestBody));
        if (responseBody != null) {
          if (!isWorkUpdate) {
            userData?.user?.firstName = firstName ?? basicProfileData?.basicOverView?.firstName;
            userData?.user?.lastName = lastName ?? basicProfileData?.basicOverView?.lastName;
            state = UserSuccessState(userData!);

            basicProfileData?.basicOverView?.firstName = firstName ?? basicProfileData.basicOverView?.firstName;
            basicProfileData?.basicOverView?.lastName = lastName ?? basicProfileData.basicOverView?.lastName;
            basicProfileData?.basicOverView?.website = website ?? basicProfileData.basicOverView?.website;
            basicProfileData?.basicOverView?.birthDate = birthDate == null || birthDate == '' ? null : DateTimeService.convert(birthDate);
            basicProfileData?.basicOverView?.about = about ?? basicProfileData.basicOverView?.about;
            basicProfileData?.basicOverView?.country = country ?? basicProfileData.basicOverView?.country;
            basicProfileData?.basicOverView?.currentCity = city ?? basicProfileData.basicOverView?.currentCity;
            basicProfileData?.basicOverView?.homeTown = hometown ?? basicProfileData.basicOverView?.homeTown;
            basicProfileData?.basicOverView?.gender = gender ?? basicProfileData.basicOverView?.gender;
          } else {
            basicProfileData?.basicOverView?.workData = workData ?? basicProfileData.basicOverView?.workData;
          }

          ref!.read(profileAboutProvider.notifier).updateSuccessState(basicProfileData);

          // ignore: unnecessary_null_comparison
          if (myProfileData != null) {
            if (!isWorkUpdate) {
              myProfileData.basicOverView?.firstName = firstName ?? basicProfileData?.basicOverView?.firstName;
              myProfileData.basicOverView?.lastName = lastName ?? basicProfileData?.basicOverView?.lastName;
              myProfileData.basicOverView?.nickName = nickName ?? basicProfileData?.basicOverView?.nickName;
              myProfileData.basicOverView?.phone = phone ?? basicProfileData?.basicOverView?.phone;
              myProfileData.basicOverView?.website = website ?? basicProfileData?.basicOverView?.website;
              myProfileData.basicOverView?.birthDate = birthDate == null || birthDate == '' ? null : DateTimeService.convert(birthDate);
              myProfileData.basicOverView?.about = about ?? basicProfileData?.basicOverView?.about;
              myProfileData.basicOverView?.country = country ?? basicProfileData?.basicOverView?.country;
              myProfileData.basicOverView?.currentCity = city ?? basicProfileData?.basicOverView?.currentCity;
              myProfileData.basicOverView?.homeTown = hometown ?? basicProfileData?.basicOverView?.homeTown;
              myProfileData.basicOverView?.gender = gender ?? basicProfileData?.basicOverView?.gender;
            } else {
              myProfileData.basicOverView?.workData = workData ?? basicProfileData?.basicOverView?.workData;
            }

            ref!.read(myProfileFeedProvider.notifier).updateBasicInfoState(myProfileData);
          }

          NavigationService.popNavigate();
          toast("Profile updated successfully", bgColor: KColor.green);
        } else {
          state = const ErrorState();
        }
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        state = const ErrorState();
      }
    }
  }

  Future uploadUserPicture({image, type = 'profile_pic'}) async {
    dynamic responseBody;

    Map<String, String> requestBody = {'uploadType': type};
    try {
      KDialog.kShowDialog(
        NavigationService.navigatorKey.currentContext,
        const ProcessingDialogContent("Uploading..."),
        barrierDismissible: false,
      );
      responseBody = await Network.handleResponse(
        await Network.multiPartRequest(API.updateUserPic, 'POST', body: requestBody, files: image, filedName: 'file'),
      );
      if (responseBody != null) {
        ProfileOverviewModel? basicProfileData = ref!.read(profileAboutProvider.notifier).profileOverviewModel;
        ProfileFeedModel? myProfileData = ref!.read(myProfileFeedProvider.notifier).myProfileFeedList;

        // ignore: unnecessary_null_comparison
        if (basicProfileData != null) {
          if (type == 'profile_pic') {
            basicProfileData.basicOverView?.profilePic = responseBody['picture'];
          } else {
            basicProfileData.basicOverView?.cover = responseBody['picture'];
          }
          ref!.read(profileAboutProvider.notifier).updateSuccessState(basicProfileData);
        }

        if (type == 'profile_pic') {
          myProfileData?.basicOverView?.profilePic = responseBody['picture'];
        } else {
          myProfileData?.basicOverView?.cover = responseBody['picture'];
        }
        ref!.read(myProfileFeedProvider.notifier).updateBasicInfoState(myProfileData);

        if (type == 'profile_pic') userData?.user?.profilePic = responseBody['picture'];
        state = UserSuccessState(userData!);
        toast("Profile picture updated successfully", bgColor:KColor.green);
        NavigationService.popNavigate();
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future register({String? firstName, lastName, email, password, fbHandle, birthdate, gender, agree}) async {
    var re = RegExp(r'(?<=https://www.facebook.com)|(?<=http://www.facebook.com)');
    if (fbHandle.isNotEmpty && !(re.hasMatch(fbHandle))) {
      toast("Please enter valid url", bgColor: KColor.red);
    } else {
      state = const UserLoadingState();

      dynamic responseBody;

      var requestBody = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email.trim(),
        'password': password.trim(),
        'password_confirmation': password.trim(),
        'agree': agree,
        if (gender != "Select Gender") 'gender': gender,
      };

      try {
        responseBody = await Network.handleResponse(await Network.postRequest(API.register, requestBody));
        if (responseBody != null) {
          state = const RegisterSuccessState();
          NavigationService.navigateToReplacement(
            CupertinoPageRoute(builder: (context) => const LoginScreen()
            
          ));
          // NavigationService.navigateTo(
          //     CupertinoPageRoute(builder: (context) => VerifyAccountScreen(email: email, verificationType: VerificationType.REGISTRATION)));
        } else {
          state = const ErrorState();
        }
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        state = const ErrorState();
      }
    }
  }

  Future login(String email, password, fcmToken) async {
    state = const UserLoadingState();
    dynamic responseBody;
    var requestBody = {
      'email': email.trim(),
      'password': password.trim(),
      'appToken': fcmToken,
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.login, requestBody, requireToken: false));

      if (responseBody != null) {
print("djkhd hdjh jhdegfjhdgffrggggggggggggg"); 
        print(responseBody['token']);
        if (responseBody['token'] != null) {
          state = const LoginSuccessState();
          setValue(LOGGED_IN, true);
          setValue(TOKEN, responseBody['token']);
          // ignore: unnecessary_null_comparison
          if (SocketService().socket != null) {
            print('SocketService().socket != null');
            SocketService().socket?.disconnect();
            SocketService().socket?.clearListeners();
          }
          SocketService().isFirstConnect = true;
          SocketService().isFromLogin = true;

          ref!.read(initDataProvider.notifier).fetchData();

          NavigationService.navigateToReplacement(SlideLeftRoute(page: const KBottomNavigationBar()));
        } else {
          state = const UserUnverifiedState();
        }
      } else {
        state = const ErrorState();
        state = const UserInitialState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
      state = const UserInitialState();
    }
  }

  Future sendPasswordResetMail(String email) async {
    state = const UserLoadingState();
    dynamic responseBody;
    var requestBody = {
      'email': email.trim(),
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.sendPasswordResetToken, requestBody, requireToken: false));

      if (responseBody != null) {
        state = const VerificationMailSentSuccessState();
        NavigationService.navigateToReplacement(
            CupertinoPageRoute(builder: (context) => VerifyAccountScreen(email: email, verificationType: VerificationType.PASSWORD)));
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future sendResetToken(String email, {routeFromLogin = false}) async {
    dynamic responseBody;
    var requestBody = {
      'email': email,
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.sendResetToken, requestBody, requireToken: false));
      if (responseBody != null) {
        toast("Code has been sent", bgColor: KColor.green);
        if (routeFromLogin) {
          NavigationService.navigateTo(
              CupertinoPageRoute(builder: (context) => VerifyAccountScreen(email: email, verificationType: VerificationType.REGISTRATION)));
        }
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future feedSettings(feed) async {
    print(feed);
    state = const UserLoadingState();
    dynamic responseBody;
    var requestBody = {'default_feed': feed ? "personal" : "world"};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.profileSettingDefaultFeedUpdate, requestBody));

      if (responseBody != null) {
        userData?.user?.defaultFeed = feed ? "personal" : "world";
        state = UserSuccessState(userData!);
        NavigationService.popNavigate();
      } else {
        state = UserSuccessState(userData!);
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = UserSuccessState(userData!);
    }
  }

  Future verifyCode(String verificationCode, String email) async {
    state = const UserLoadingState();

    dynamic responseBody;
    var requestBody = {
      'email': email,
      'verificationCode': verificationCode,
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.verifyCode, requestBody, requireToken: false));
      if (responseBody != null) {
        state = const VerificationSuccessState();

        NavigationService.navigateToReplacement(CupertinoPageRoute(builder: (_) => ResetPasswordScreen(email: email)));
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future verifyRegistration(String verificationCode, String email) async {
    state = const UserLoadingState();
    dynamic responseBody;
    var requestBody = {
      'email': email,
      'verificationCode': verificationCode,
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.verifyEmail, requestBody, requireToken: false));
      if (responseBody != null) {
        state = const VerificationSuccessState();
        toast(responseBody['msg'], bgColor: KColor.green);
        NavigationService.navigateToReplacement(CupertinoPageRoute(builder: (_) => const LoginScreen()));
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future verifyUpdateEmail(String verificationCode, String email) async {
    state = const UserLoadingState();

    dynamic responseBody;
    var requestBody = {
      'email': email,
      'token': verificationCode,
    };
    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.verifyUpdateEmail, requestBody));
      if (responseBody != null) {
        userData?.user?.email = email;
        state = UserSuccessState(userData!);
        toast('Email changed successfully', bgColor: KColor.green);
        NavigationService.navigateToReplacement(CupertinoPageRoute(builder: (_) => const KBottomNavigationBar(index: 3)));
      } else {
        toast(responseBody['msg'], bgColor: KColor.red);
      }
      state = const ErrorState();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future resetPassword(String? email, password, verificationCode) async {
    state = const UserLoadingState();

    dynamic responseBody;
    var requestBody = {
      'email': email!.trim(),
      'password': password.trim(),
      'verificationCode': verificationCode.toString(),
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.passwordReset, requestBody, requireToken: false));

      if (responseBody != null) {
        state = const VerificationSuccessState();

        NavigationService.navigateToReplacement(CupertinoPageRoute(builder: (_) => const LoginScreen()));
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future changeEmail(String email) async {
    state = const UserLoadingState();

    dynamic responseBody;
    var requestBody = {
      'email': email.trim(),
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.changeEmail, requestBody));

      if (responseBody != null) {
        state = UserSuccessState(userData!);

        NavigationService.navigateToReplacement(CupertinoPageRoute(builder: (context) => VerifyEmailScreen(email: email)));
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future changePassword(oldPassword, password, passwordConfirmation) async {
    state = const UserLoadingState();

    dynamic responseBody;
    var requestBody = {
      'old_password': oldPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.changePassword, requestBody, requireToken: true));

      if (responseBody != null) {
        state = UserSuccessState(userData!);
        toast('Password changed successfully!', bgColor: KColor.green);
        NavigationService.popNavigate();
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future logout() async {
    state = const UserLoadingState();
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.logout));
      if (responseBody != null) {
        // setValue(LOGGED_IN, false);
        // SocketService().socket.disconnect();
        // state = LogoutSuccessState();
        // NavigationService.navigateToReplacement(CupertinoPageRoute(builder: (_) => LoginScreen()));
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
    setValue(LOGGED_IN, false);
    socketTimer?.cancel();
    // SocketService().disconnectSocket();
    state = const LogoutSuccessState();
    NavigationService.navigateToReplacement(CupertinoPageRoute(builder: (_) => const LoginScreen()));
  }

  Future deleteAccount() async {
    state = const UserLoadingState();
    dynamic responseBody;
    var requestBody = {'id': getIntAsync(USER_ID)};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deleteAccount, requestBody));
      if (responseBody != null) {
        toast('Your account has been deleted succesfully!', bgColor: KColor.green);
        setValue(LOGGED_IN, false);
        SocketService().disconnectSocket();
        state = const LogoutSuccessState();
        NavigationService.navigateToReplacement(CupertinoPageRoute(builder: (_) => const LoginScreen()));
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }

  Future updateFriendReq() async {
    state = const UserLoadingState();
    dynamic responseBody;
    var requestBody = {};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.updateFriendReq, requestBody));
      if (responseBody != null) {
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ErrorState();
    }
  }
}
