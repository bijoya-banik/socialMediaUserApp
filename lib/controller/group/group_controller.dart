import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/group/discover_groups_controller.dart';
import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/controller/group/joined_groups_controller.dart';
import 'package:buddyscripts/controller/group/my_groups_controller.dart';
import 'package:buddyscripts/controller/group/state/group_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/group/group_feed_model.dart';
import 'package:buddyscripts/models/group/groups_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

enum GroupType { MYGROUP, JOINED, DISCOVER }

final groupProvider = StateNotifierProvider<GroupController,GroupState>(
  (ref) => GroupController(ref: ref),
);

class GroupController extends StateNotifier<GroupState> {
  final Ref? ref;
  GroupController({this.ref}) : super(const GroupInitialState());

  Future createGroup({groupName, about, privacy, categoryName}) async {
    state = const GroupLoadingState();

    dynamic responseBody;
    var requestBody = {
      'group_name': groupName,
      'about': about,
      'group_privacy': privacy == 'Public' ? 'PUBLIC' : 'ONLY ME',
      // 'category_name': categoryName,
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.createGroup, requestBody, requireToken: true));

      if (responseBody != null) {
        state = const CreateGroupSuccessState();
        GroupDatum groupModelInstance = GroupDatum.fromJson(responseBody);
        GroupsModel? groupModel = ref!.read(myGroupsProvider.notifier).myGroupsModel;
        groupModel!.data!.insert(0, groupModelInstance);
        ref!.read(myGroupsProvider.notifier).updateSuccessState(groupModel);
        NavigationService.popNavigate();
      } else {
        state = const CreateGroupErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CreateGroupErrorState();
    }
  }

  Future uploadGroupPicture({image, type = 'profile_pic', groupId}) async {
    dynamic responseBody;

    Map<String, String> requestBody = {'uploadType': type, 'group_id': groupId.toString()};
    try {
      KDialog.kShowDialog(
        NavigationService.navigatorKey.currentContext,
        const ProcessingDialogContent("Uploading..."),
        barrierDismissible: false,
      );
      responseBody = await Network.handleResponse(
        await Network.multiPartRequest(API.updateGroupPic, 'POST', body: requestBody, files: image, filedName: 'file'),
      );
      if (responseBody != null) {
        BasicOverView? basicOverViewInstance = ref!.read(groupFeedProvider.notifier).groupFeedList!.basicOverView;
        if (type == 'profile_pic') {
          basicOverViewInstance!.profilePic = responseBody['picture'];
        } else {
          basicOverViewInstance!.cover = responseBody['picture'];
        }

        ref!.read(groupFeedProvider.notifier).updateGroupDetails(basicOverViewInstance);
        NavigationService.popNavigate();
      } else {
        state = const GroupErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupErrorState();
    }
  }

  Future editGroup({groupData, groupName, about, privacy, categoryName, city, country, address}) async {
    state = const GroupLoadingState();

    dynamic responseBody;
    var requestBody = {
      'id': groupData.id,
      'group_name': groupName,
      'about': about,
      'group_privacy': privacy == 'Public' ? 'PUBLIC' : 'ONLY ME',
      'category_name': categoryName,
      'city': city,
      'country': country,
      'address': address,
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.editGroup, requestBody, requireToken: true));
      if (responseBody != null) {
        state = const EditGroupSuccessState();

        BasicOverView? groupOverview = ref!.read(groupFeedProvider.notifier).groupFeedList!.basicOverView;

        groupOverview!.groupName = groupName;
        groupOverview.about = about;
        groupOverview.categoryName = categoryName;
        groupOverview.country = country;
        groupOverview.city = city;
        groupOverview.address = address;
        groupOverview.groupPrivacy = privacy;

        ref!.read(groupFeedProvider.notifier).updateGroupDetails(groupOverview);

        List<GroupDatum> groupModelInstance = [
          GroupDatum(
              id: groupData.id,
              groupName: groupName,
              slug: groupData.slug,
              profilePic: groupData.profilePic,
              cover: groupData.cover,
              about: about,
              country: country == "" ? null : country,
              city: city == "" ? null : city,
              address: address == "" ? null : address,
              groupPrivacy: privacy,
              totalMembers: groupData.totalMembers,
              categoryName: categoryName)
        ];

        GroupsModel? groupModel = ref!.read(myGroupsProvider.notifier).myGroupsModel;
        final index = groupModel!.data!.indexWhere((element) => element.id == groupData.id);
        groupModel.data!.replaceRange(index, index + 1, groupModelInstance);
        ref!.read(myGroupsProvider.notifier).updateSuccessState(groupModel);

        final List<FeedModel>? groupFeedList = ref!.read(groupFeedProvider.notifier).groupFeedList!.feedData;
        for (var element in groupFeedList!) {
          element.name = groupName;
        }
        ref!.read(groupFeedProvider.notifier).updateSuccessState(groupFeedList);

        NavigationService.popNavigate();
      } else {
        state = const EditGroupErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const EditGroupErrorState();
    }
  }

  Future deleteGroup(int groupId) async {
    dynamic responseBody;

    var requestBody = {'group_id': groupId};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deleteGroup, requestBody));

      if (responseBody != null) {
        GroupsModel? groupModel = ref!.read(myGroupsProvider.notifier).myGroupsModel;
        groupModel!.data!.removeWhere((element) => element.id == groupId);
        NavigationService.popNavigate();
        ref!.read(myGroupsProvider.notifier).updateSuccessState(groupModel);
      } else {
        state = const DeleteGroupErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const DeleteGroupErrorState();
    }
  }

  Future joinGroup({BasicOverView? groupData, groupType}) async {
    state = const GroupLoadingState();
    dynamic responseBody;

    var requestBody = {'group_id': groupData!.id};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.joinGroup, requestBody));

      if (responseBody != null) {
        state = const JoinGroupSuccessState();

        if (groupData.groupPrivacy == "ONLY ME") {
          IsRequested groupIsMemberInstance = IsRequested.fromJson(responseBody);
          BasicOverView groupBasicOverview = BasicOverView(
            id: groupData.id,
            groupName: groupData.groupName,
            slug: groupData.slug,
            profilePic: groupData.profilePic,
            cover: groupData.cover,
            about: groupData.about,
            country: groupData.country,
            city: groupData.city,
            address: groupData.address,
            groupPrivacy: groupData.groupPrivacy,
            totalMembers: groupData.totalMembers,
            categoryName: groupData.categoryName,
            isMember: null,
            isRequested: groupIsMemberInstance,
            meta: groupData.meta,
          );
          ref!.read(groupFeedProvider.notifier).updateGroupDetails(groupBasicOverview);
        } else {
          GroupsModel? discoveredGroupsModel = ref!.read(discoverGroupsProvider.notifier).discoverGroupsModel;
          if (discoveredGroupsModel != null) discoveredGroupsModel.data!.removeWhere((element) => element.id == groupData.id);
          ref!.read(discoverGroupsProvider.notifier).updateSuccessState(discoveredGroupsModel!);

          GroupsModel? joinedGroupsModel = ref!.read(joinedGroupsProvider.notifier).joinedGroupsModel;

          GroupDatum groupDataInstance = GroupDatum(
              id: groupData.id,
              groupName: groupData.groupName,
              slug: groupData.slug,
              profilePic: groupData.profilePic,
              cover: groupData.cover,
              about: groupData.about,
              country: groupData.country,
              city: groupData.city,
              address: groupData.address,
              groupPrivacy: groupData.groupPrivacy,
              totalMembers: groupData.totalMembers! + 1,
              categoryName: groupData.categoryName);

          if (joinedGroupsModel != null) joinedGroupsModel.data!.insert(0, groupDataInstance);
          ref!.read(joinedGroupsProvider.notifier).updateSuccessState(joinedGroupsModel!);

          IsMember groupIsMemberInstance = IsMember.fromJson(responseBody);
          BasicOverView groupBasicOverview = BasicOverView(
            id: groupData.id,
            groupName: groupData.groupName,
            slug: groupData.slug,
            profilePic: groupData.profilePic,
            cover: groupData.cover,
            about: groupData.about,
            country: groupData.country,
            city: groupData.city,
            address: groupData.address,
            groupPrivacy: groupData.groupPrivacy,
            totalMembers: groupData.totalMembers! + 1,
            categoryName: groupData.categoryName,
            isMember: groupIsMemberInstance,
            meta: groupData.meta,
          );
          ref!.read(groupFeedProvider.notifier).updateGroupDetails(groupBasicOverview);
        }
      } else {
        state = const JoinGroupErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const JoinGroupErrorState();
    }
  }

  Future leaveGroup({groupData, groupType}) async {
    state = const GroupLoadingState();
    dynamic responseBody;

    var requestBody = {'group_id': groupData.id};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.leaveGroup, requestBody));

      if (responseBody != null) {
        state = const LeaveGroupSuccessState();

        if (groupType == GroupType.MYGROUP) {
          GroupsModel? myGroupsModel = ref!.read(myGroupsProvider.notifier).myGroupsModel;
          if (myGroupsModel != null) myGroupsModel.data!.removeWhere((element) => element.id == groupData.id);
          ref!.read(myGroupsProvider.notifier).updateSuccessState(myGroupsModel!);
        } else {
          GroupsModel? joinedGroupsModel = ref!.read(joinedGroupsProvider.notifier).joinedGroupsModel;
          if (joinedGroupsModel != null) joinedGroupsModel.data!.removeWhere((element) => element.id == groupData.id);
          ref!.read(joinedGroupsProvider.notifier).updateSuccessState(joinedGroupsModel!);
        }

        GroupsModel? discoveredGroupsModel = ref!.read(discoverGroupsProvider.notifier).discoverGroupsModel;

        GroupDatum discoveredGroupDataInstance = GroupDatum(
            id: groupData.id,
            groupName: groupData.groupName,
            slug: groupData.slug,
            profilePic: groupData.profilePic,
            cover: groupData.cover,
            about: groupData.about,
            country: groupData.country,
            city: groupData.city,
            address: groupData.address,
            groupPrivacy: groupData.groupPrivacy,
            totalMembers: groupData.totalMembers - 1,
            categoryName: groupData.categoryName);

        if (discoveredGroupsModel != null) discoveredGroupsModel.data!.insert(0, discoveredGroupDataInstance);
        ref!.read(discoverGroupsProvider.notifier).updateSuccessState(discoveredGroupsModel!);

        BasicOverView groupBasicOverview = BasicOverView(
          id: groupData.id,
          groupName: groupData.groupName,
          slug: groupData.slug,
          profilePic: groupData.profilePic,
          cover: groupData.cover,
          about: groupData.about,
          country: groupData.country,
          city: groupData.city,
          address: groupData.address,
          groupPrivacy: groupData.groupPrivacy,
          totalMembers: groupData.totalMembers - 1,
          categoryName: groupData.categoryName,
          meta: groupData.meta,
        );
        ref!.read(groupFeedProvider.notifier).updateGroupDetails(groupBasicOverview);
      } else {
        state = const LeaveGroupErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const LeaveGroupErrorState();
    }
  }

  Future cancelRequest({groupData, groupType}) async {
    state = const GroupLoadingState();
    dynamic responseBody;

    var requestBody = {'group_id': groupData.id, 'user_id': getIntAsync(USER_ID)};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.cancelRequest, requestBody));

      if (responseBody != null) {
        BasicOverView groupBasicOverview = BasicOverView(
          id: groupData.id,
          groupName: groupData.groupName,
          slug: groupData.slug,
          profilePic: groupData.profilePic,
          cover: groupData.cover,
          about: groupData.about,
          country: groupData.country,
          city: groupData.city,
          address: groupData.address,
          groupPrivacy: groupData.groupPrivacy,
          totalMembers: groupData.totalMembers,
          categoryName: groupData.categoryName,
          isMember: null,
          isRequested: null,
          meta: groupData.meta,
        );
        ref!.read(groupFeedProvider.notifier).updateGroupDetails(groupBasicOverview);
        state = const LeaveGroupSuccessState();
      } else {
        state = const LeaveGroupErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const LeaveGroupErrorState();
    }
  }
}
