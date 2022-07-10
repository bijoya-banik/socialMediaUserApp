import 'package:buddyscripts/models/event/invite/invite_member_model.dart';
import 'package:buddyscripts/models/event/invite/search_result_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'state/invite_member_state.dart';

final inviteMemberProvider = StateNotifierProvider<InviteMemberController,InviteMemberState>(
  (ref) => InviteMemberController(ref: ref),
);

class InviteMemberController extends StateNotifier<InviteMemberState> {
  final Ref? ref;
  InviteMemberController({this.ref}) : super(const InviteMemberInitialState());

  InviteMemberModel? inviteMemberModel;
  List<InviteMemberSearchResultModel>? inviteMemberSearchResultModel = [];

  Future fetchInvitedAndSuggestedMembers(String? eventName, {bool loading = true}) async {
    if (loading) state = const InviteMemberLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.eventDetails(eventName!, tab: 'invite')),
      );
      if (responseBody != null) {
        inviteMemberModel = InviteMemberModel.fromJson(responseBody);
        state = InviteMemberSuccessState(inviteMemberModel!);
      } else {
        state = const InviteMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const InviteMemberErrorState();
    }
  }

  Future fetchMembers({int? id, String? searchedString}) async {
    state = const InviteMemberLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.searchMember + "?event_id=$id&str=$searchedString"),
      );
      if (responseBody != null) {
        inviteMemberSearchResultModel = (responseBody as List<dynamic>).map((e) => InviteMemberSearchResultModel.fromJson(e)).toList();
        state = InviteMemberSearchResultSuccessState(inviteMemberSearchResultModel!);
      } else {
        state = const InviteMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const InviteMemberErrorState();
    }
  }

  Future inviteMember({int? userId, bool suggested = false}) async {
    // state = InviteMemberLoadingState();
    dynamic responseBody;
    var requestBody = {
      'event_id': inviteMemberModel?.basicOverView?.id,
      'user_id': userId,
    };
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.addMember, requestBody),
      );
      if (responseBody != null) {
        if (suggested) {
          fetchInvitedAndSuggestedMembers(inviteMemberModel?.basicOverView?.slug, loading: !suggested);
        } else {
          inviteMemberSearchResultModel![inviteMemberSearchResultModel!.indexWhere((element) => element.friendId == userId)].status = "invited";
          state = InviteMemberSearchResultSuccessState(inviteMemberSearchResultModel!);
        }

        toast("Invitation sent succussfully", bgColor: KColor.green);
      } else {
        state = const InviteMemberErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const InviteMemberErrorState();
    }
  }

  // Future acceptInvite(String status) async {
  //   var responseBody;
  //   var requestBody = {
  //     'event_id': ref.read(eventFeedProvider).eventFeedList.basicOverView.id,
  //     'user_id': getIntAsync(USER_ID),
  //     'status': status == 'not interested' ? "" : status,
  //   };
  //   try {
  //     responseBody = await Network.handleResponse(
  //       await Network.postRequest(API.acceptInvite, requestBody),
  //     );
  //     if (responseBody != null) {
  //       ref.read(eventFeedProvider).eventFeedList.isGoing.status = requestBody['status'];

  //       ref.read(eventFeedProvider).updateGoingSuccessState(ref.read(eventFeedProvider).eventFeedList.isGoing);
  //       // ref.read(eventFeedProvider).fetchEventFeed(
  //       //   ref.read(eventFeedProvider).eventFeedList.basicOverView.slug);
  //     } else {
  //       state = InviteMemberErrorState();
  //     }
  //   } catch (error, stackTrace) {
  //     print(error);
  //     print(stackTrace);
  //     state = InviteMemberErrorState();
  //   }
  // }
}
