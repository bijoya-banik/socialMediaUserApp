// ignore_for_file: unnecessary_null_comparison

import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/event/discover_events_controller.dart';
import 'package:buddyscripts/controller/event/going_events_controller.dart';
import 'package:buddyscripts/controller/event/interested_events_controller.dart';
import 'package:buddyscripts/controller/pagination/event/event_feed_tab.dart';
import 'package:buddyscripts/controller/event/state/event_feed_state.dart';
import 'package:buddyscripts/models/event/event_feed_model.dart';
import 'package:buddyscripts/models/event/events_model.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:collection/collection.dart';

final eventFeedProvider = StateNotifierProvider<EventFeedController, EventFeedState>(
  (ref) => EventFeedController(ref: ref),
);

class EventFeedController extends StateNotifier<EventFeedState> {
  final Ref? ref;
  EventFeedController({this.ref}) : super(const EventFeedInitialState());

  EventFeedModel? eventFeedList;

  updateSuccessState(List<FeedModel> feedList) {
    eventFeedList?.feedData = feedList;
    state = EventFeedSuccessState(eventFeedList!);
  }

  updateBasicOverviewSuccessState(BasicOverView basicOverView) {
    eventFeedList?.basicOverView = basicOverView;
    state = EventFeedSuccessState(eventFeedList!);
  }

  updateGoingSuccessState(IsGoing going) {
    eventFeedList?.isGoing = going;
    state = EventFeedSuccessState(eventFeedList!);
  }

  Future fetchEventFeed(String userName) async {
    state = const EventFeedLoadingState();

    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.eventDetails(userName)));

      if (responseBody != null) {
        eventFeedList = EventFeedModel.fromJson(responseBody);
        state = EventFeedSuccessState(eventFeedList!);
      } else {
        state = const EventFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const EventFeedErrorState();
    }
  }

  Future fetchMoreEventFeed(String userName) async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
          await Network.getRequest(API.eventDetails(userName, lastId: eventFeedList!.feedData!.isEmpty ? "" : eventFeedList?.feedData?.last.id)));

      if (responseBody != null) {
        var eventFeedModelInstance = (responseBody['feedData'] as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();

        eventFeedList?.feedData?.addAll(eventFeedModelInstance);

        state = EventFeedSuccessState(eventFeedList!);
        ref!.read(eventFeedScrollProvider.notifier).resetState();
      } else {
        state = const EventFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const EventFeedErrorState();
    }
  }

  Future uploadEventCover({image, eventId}) async {
    dynamic responseBody;

    Map<String, String> requestBody = {'uploadType': 'cover', 'page_id': eventId.toString()};
    try {
      KDialog.kShowDialog(
        NavigationService.navigatorKey.currentContext,
        const ProcessingDialogContent("Uploading..."),
        barrierDismissible: false,
      );
      responseBody = await Network.handleResponse(
        await Network.multiPartRequest(API.updateEventPic, 'POST', body: requestBody, files: image, filedName: 'file'),
      );
      if (responseBody != null) {
        eventFeedList?.basicOverView?.cover = responseBody['picture'];
        state = EventFeedSuccessState(eventFeedList!);

        NavigationService.popNavigate();
      } else {
        state = const EventFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const EventFeedErrorState();
    }
  }

  Future acceptInvite(String status) async {
    var prevStatus = eventFeedList?.isGoing == null ? "" : eventFeedList!.isGoing?.status;
    dynamic responseBody;
    var requestBody = {
      'event_id': ref!.read(eventFeedProvider.notifier).eventFeedList!.basicOverView?.id,
      'user_id': getIntAsync(USER_ID),
      'status': status == 'not interested' ? prevStatus : status,
    };

    if (eventFeedList?.isGoing == null) {
      eventFeedList!.isGoing = IsGoing(
        userId: getIntAsync(USER_ID),
        eventId: ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView?.id,
        status: "",
      );
    }

    if (status == 'not interested') {
      eventFeedList?.isGoing = null;
    } else {
      eventFeedList?.isGoing?.status = requestBody['status'].toString();
    }

    state = EventFeedSuccessState(eventFeedList!);
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.acceptInvite, requestBody),
      );
      if (responseBody != null) {
        print(responseBody['isGoing']);

        if (responseBody['isGoing'] == null) {
          eventFeedList?.isGoing = IsGoing(
            userId: getIntAsync(USER_ID),
            eventId: ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView?.id,
            status: "",
          );
        } else {
          //    eventFeedList.isGoing = IsGoing(
          // userId: getIntAsync(USER_ID),
          // eventId: ref.read(eventFeedProvider.notifier).eventFeedList.basicOverView.id,
          // status: requestBody['status']);
          eventFeedList?.isGoing?.status = requestBody['status'].toString();
        }

        state = EventFeedSuccessState(eventFeedList!);

        //  if(noti==false){
        if (ref!.read(goingEventsProvider.notifier).goingEventsModel != null &&
            ref!.read(interestedEventsProvider.notifier).interestedEventsModel != null &&
            ref!.read(discoverEventsProvider.notifier).discoverEventsModel != null) {
          EventDatum? event;

          if (event != null) {
            if (prevStatus == "going") {
              if (ref!.read(goingEventsProvider.notifier).goingEventsModel!.data!.isNotEmpty) {
                event = ref!
                    .read(goingEventsProvider.notifier)
                    .goingEventsModel!
                    .data!
                    .firstWhereOrNull((element) => element.id == ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView?.id);
                ref!
                    .read(goingEventsProvider.notifier)
                    .goingEventsModel!
                    .data!
                    .removeWhere((element) => element.id == ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView?.id);
              }

              ref!.read(goingEventsProvider.notifier).updateSuccessState(ref!.read(goingEventsProvider.notifier).goingEventsModel!.data);
            } else if (prevStatus == "interested") {
              if (ref!.read(interestedEventsProvider.notifier).interestedEventsModel!.data!.isNotEmpty) {
                event = ref!
                    .read(interestedEventsProvider.notifier)
                    .interestedEventsModel!
                    .data!
                    .firstWhereOrNull((element) => element.id == ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView?.id);

                ref!
                    .read(interestedEventsProvider.notifier)
                    .interestedEventsModel!
                    .data!
                    .removeWhere((element) => element.id == ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView?.id);

                ref!
                    .read(interestedEventsProvider.notifier)
                    .updateSuccessState(ref!.read(interestedEventsProvider.notifier).interestedEventsModel!.data);
              }
            } else {
              if (ref!.read(discoverEventsProvider.notifier).discoverEventsModel!.data!.isNotEmpty) {
                event = ref!
                    .read(discoverEventsProvider.notifier)
                    .discoverEventsModel!
                    .data!
                    .firstWhereOrNull((element) => element.id == ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView!.id);

                ref!
                    .read(discoverEventsProvider.notifier)
                    .discoverEventsModel!
                    .data!
                    .removeWhere((element) => element.id == ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView!.id);

                ref!.read(discoverEventsProvider.notifier).updateSuccessState(ref!.read(discoverEventsProvider.notifier).discoverEventsModel!.data);
              }
            }

            if (status == "going") {
              if (ref!.read(goingEventsProvider.notifier).goingEventsModel!.data!.isNotEmpty) {
                ref!.read(goingEventsProvider.notifier).goingEventsModel?.data?.insert(0, event!);

                ref!.read(goingEventsProvider.notifier).updateSuccessState(ref!.read(goingEventsProvider.notifier).goingEventsModel!.data);
              }
            } else if (status == "interested") {
              if (ref!.read(interestedEventsProvider.notifier).interestedEventsModel!.data!.isNotEmpty) {
                ref!.read(interestedEventsProvider.notifier).interestedEventsModel?.data?.insert(0, event!);

                ref!
                    .read(interestedEventsProvider.notifier)
                    .updateSuccessState(ref!.read(interestedEventsProvider.notifier).interestedEventsModel!.data);
              }
            } else {
              if (ref!.read(discoverEventsProvider.notifier).discoverEventsModel!.data!.isNotEmpty) {
                ref!.read(discoverEventsProvider.notifier).discoverEventsModel?.data?.insert(0, event!);

                ref!.read(discoverEventsProvider.notifier).updateSuccessState(ref!.read(discoverEventsProvider.notifier).discoverEventsModel?.data);
              }
            }
          }
        }
      } else {
        eventFeedList?.isGoing?.status = prevStatus;
        state = EventFeedSuccessState(eventFeedList!);
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      eventFeedList?.isGoing?.status = prevStatus;
      state = EventFeedSuccessState(eventFeedList!);
    }
  }
}
