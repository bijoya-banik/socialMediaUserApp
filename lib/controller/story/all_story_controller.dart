import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/story/state/all_story_state.dart';
import 'package:buddyscripts/controller/story/story_controller.dart';
import 'package:buddyscripts/models/story/all_story_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/screens/story/models/story_model.dart';
import 'package:buddyscripts/views/screens/story/models/story_user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final allstoryProvider = StateNotifierProvider<AllStoryController, AllStoryState>(
  (ref) => AllStoryController(ref: ref),
);

class AllStoryController extends StateNotifier<AllStoryState> {
  final Ref? ref;
  AllStoryController({this.ref}) : super(const AllStoryInitialState());

  List<AllStoryModel> allStoryModel = [];
  final List<UserWithStory>? usersStoryDetails = [];

  Future fetchAllStory() async {
    allStoryModel.clear();
    usersStoryDetails!.clear();
    state = const AllStoryLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.getAllStory),
      );
      if (responseBody != null) {
        allStoryModel = (responseBody as List<dynamic>).map((x) => AllStoryModel.fromJson(x)).toList();

        state = AllStorySuccessState(allStoryModel);

        for (int i = 0; i < allStoryModel.length; i++) {
          List<Story> stories = [];

          for (int j = 0; j < allStoryModel[i].data!.length; j++) {
            MediaType media;
            if (allStoryModel[i].data![j].type == "image") {
              media = MediaType.image;
            } else if (allStoryModel[i].data![j].type == "video") {
              media = MediaType.video;
            } else {
              media = MediaType.text;
            }
            stories.add(Story(
                storyId: allStoryModel[i].data?[j].id,
                url: allStoryModel[i].data![j].data!,
                bgColor: allStoryModel[i].data![j].bgColor ?? '',
                media: media,
                duration: const Duration(seconds: 3),
                createTime: allStoryModel[i].data![j].createdAt,
                user: StoryUser(
                  name: allStoryModel[i].firstName.toString() + allStoryModel[i].lastName.toString(),
                  profileImageUrl: allStoryModel[i].profilePic.toString(),
                  username: allStoryModel[i].username.toString(),
                )));
          }

          usersStoryDetails?.add(UserWithStory(
            userId: allStoryModel[i].id,
            name: allStoryModel[i].firstName.toString() + " " + allStoryModel[i].lastName.toString(),
            createdAt: allStoryModel[i].createdAt.toString(),
            profileImageUrl: allStoryModel[i].profilePic.toString(),
            story: stories,
            username: allStoryModel[i].username.toString(),
          ));
        }
      } else {
        state = const AllStoryErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchStory(): $error");
      print(stackTrace);
      state = const AllStoryErrorState();
    }
  }

  Future deleteStory(Story story, AnimationController animBarController, int index) async {
    dynamic responseBody;

    var requestBody = {'id': story.storyId, 'user_id': getIntAsync(USER_ID), 'fileLoc': story.media == MediaType.text ? null : story.url};

    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.deleteStoryFeed, requestBody),
      );
      if (responseBody != null) {
        int userIndex = allStoryModel.indexWhere(((element) => element.id == getIntAsync(USER_ID)));
        print(index);
        print("index");
        // if (allStoryModel[userIndex].data.last.id == story.storyId) {
        //   allStoryModel.removeWhere((element) => element.id == getIntAsync(USER_ID));
        // }
        if (allStoryModel[userIndex].data!.length == 1) {
          allStoryModel.removeWhere((element) => element.id == getIntAsync(USER_ID));
        } else {
          print("allStoryModel[userIndex].data.length");
          print(allStoryModel[userIndex].data!.length);
          // allStoryModel[userIndex].data.removeWhere((element) => element.id == story.storyId);
          allStoryModel[userIndex].data!.removeAt(index);

          print("allStoryModel[userIndex].data.length");
          print(allStoryModel[userIndex].data!.length);
        }

        state = AllStorySuccessState(allStoryModel);
        //allStoryModel.clear();
        usersStoryDetails!.clear();
        for (int i = 0; i < allStoryModel.length; i++) {
          List<Story> stories = [];

          for (int j = 0; j < allStoryModel[i].data!.length; j++) {
            MediaType media;
            if (allStoryModel[i].data![j].type == "image") {
              media = MediaType.image;
            } else if (allStoryModel[i].data![j].type == "video") {
              media = MediaType.video;
            } else {
              media = MediaType.text;
            }
            stories.add(Story(
                storyId: allStoryModel[i].data![j].id,
                url: allStoryModel[i].data![j].data.toString(),
                bgColor: allStoryModel[i].data![j].bgColor,
                media: media,
                duration: const Duration(seconds: 3),
                createTime: allStoryModel[i].data![j].createdAt,
                user: StoryUser(
                  name: allStoryModel[i].firstName.toString() + allStoryModel[i].lastName.toString(),
                  profileImageUrl: allStoryModel[i].profilePic.toString(),
                  username: allStoryModel[i].username.toString(),
                )));
          }

          usersStoryDetails?.add(UserWithStory(
            userId: allStoryModel[i].id,
            name: allStoryModel[i].firstName.toString() + " " + allStoryModel[i].lastName.toString(),
            createdAt: allStoryModel[i].createdAt.toString(),
            profileImageUrl: allStoryModel[i].profilePic.toString(),
            story: stories,
            username: allStoryModel[i].username.toString(),
          ));
        }
        String? mediaText;

        if (usersStoryDetails!.isNotEmpty) {
          if (usersStoryDetails?[0].story![0].media == MediaType.image) {
            mediaText = "image";
          } else if (usersStoryDetails?[0].story![0].media == MediaType.video) {
            mediaText = "video";
          } else {
            mediaText = "text";
          }
        }

        int userDataIndex = allStoryModel.indexWhere(((element) => element.id == getIntAsync(USER_ID)));

        if (userDataIndex == -1) {
          ref!.read(storyProvider.notifier).storyModel.removeAt(1);
        } else {
          ref!.read(storyProvider.notifier).storyModel[1].data = usersStoryDetails![0].story![0].url;
          ref!.read(storyProvider.notifier).storyModel[1].type = mediaText;
        }

        ref!.read(storyProvider.notifier).updateSuccessState(ref!.read(storyProvider.notifier).storyModel);
      } else {
        print("error");
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }

    int userIndex = allStoryModel.indexWhere(((element) => element.id == getIntAsync(USER_ID)));
    NavigationService.popNavigate();
    if (userIndex == -1) {
      NavigationService.popNavigate();
    } else {
      animBarController.reset();
      animBarController.forward();
    }
  }
}
