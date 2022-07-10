import 'dart:io';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/event/event_feed_controller.dart';
import 'package:buddyscripts/controller/event/state/my_events_state.dart';
import 'package:buddyscripts/controller/pagination/event/my_events_tab.dart';
import 'package:buddyscripts/models/event/events_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

final myEventsProvider = StateNotifierProvider<MyEventsController,MyEventsState>(
  (ref) => MyEventsController(ref: ref),
);

class MyEventsController extends StateNotifier<MyEventsState> {
  final Ref? ref;
  MyEventsController({this.ref}) : super(const MyEventsInitialState());

  EventsModel? myEventsModel;
  int currentPage = 1;
List<File>? files =[];
  Future createEvent({String? eventName, address, startTime, endTime, about, cover}) async {
    state = const MyEventsLoadingState();

    cover ??= files;
    dynamic responseBody;
    // var requestBody = {
    Map<String, String> requestBody = {
      'event_name': eventName!,
      'address': address,
      'start_time': startTime,
     // DateFormat('yyyy-MM-DD HH:mm:ss').format(DateTime.parse(startTime).toLocal()),
      //DateTimeService.convert(dateTime) startTime,
      'end_time':  endTime,
     // DateFormat('yyyy-MM-DD HH:mm:ss').format(DateTime.parse(endTime).toLocal()),
      // endTime,
      'about': about,
      'user_id': getIntAsync(USER_ID).toString(),
    };

    try {
      responseBody = await Network.handleResponse(
        //await Network.postRequest(API.createEvent, requestBody)
        await Network.multiPartRequest(API.createEvent,
         'POST', body: requestBody, files: cover, filedName: 'file'),
      );
      if (responseBody != null) {
        await fetchMyEvents(isLoading: false);
        toast("Event successfully created", bgColor: KColor.green);
      } else {
        print("createEvent() responseBody null");
        state = const MyEventsErrorState();
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      state = const MyEventsErrorState();
    }
  }

  Future editEvent({String? eventName, address, startTime, endTime, about, id}) async {
    state = const MyEventsLoadingState();
    dynamic responseBody;
    var requestBody = {
      'id': id,
      'event_name': eventName,
      'address': address,
      'start_time': startTime,
      'end_time': endTime,
      'about': about,
      'user_id': getIntAsync(USER_ID),
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.editEvent, requestBody));
      if (responseBody != null) {
        ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView?.eventName = eventName;
        ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView?.startTime = DateTime.parse(responseBody['start_time']);
        ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView?.endTime = DateTime.parse(responseBody['end_time']);
        ref!.read(eventFeedProvider.notifier).updateBasicOverviewSuccessState((ref!.read(eventFeedProvider.notifier).eventFeedList?.basicOverView)!);
        await fetchMyEvents(isLoading: false);

        toast("Event successfully updated", bgColor: KColor.green);
      } else {
        print("editEvent() responseBody null");
        state = const MyEventsErrorState();
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      state = const MyEventsErrorState();
    }
  }

  Future fetchMyEvents({bool isLoading = true}) async {
    if (isLoading) state = const MyEventsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.events(tab: 'my')),
      );
      if (responseBody != null) {
        myEventsModel = EventsModel.fromJson(responseBody);
        currentPage = myEventsModel?.meta?.currentPage;
        state = MyEventsSuccessState(myEventsModel!);
      } else {
        state = const MyEventsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMyEvents(): $error");
      print(stackTrace);
      state = const MyEventsErrorState();
    }
  }

  Future fetchMoreMyEvents() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.events(tab: 'my', page: currentPage += 1)),
      );
      if (responseBody != null) {
        var myEventsModelInstance = EventsModel.fromJson(responseBody);
        myEventsModel?.data?.addAll(myEventsModelInstance.data!);
        state = MyEventsSuccessState(myEventsModel!);
        ref!.read(myEventsScrollProvider.notifier).resetState();
      } else {
        state = const MyEventsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreMyEvents(): $error");
      print(stackTrace);
      state = const MyEventsErrorState();
    }
  }

  Future deleteEvent(int eventId) async {
    dynamic responseBody;

    var requestBody = {
      'event_id': eventId,
      'user_id': getIntAsync(USER_ID),
    };

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deleteEvent, requestBody));

      if (responseBody != null) {
        myEventsModel?.data!.removeWhere((element) => element.id == eventId);
        state = MyEventsSuccessState(myEventsModel!);
        NavigationService.popNavigate();
      } else {
        state = const MyEventsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const MyEventsErrorState();
    }
  }
}
