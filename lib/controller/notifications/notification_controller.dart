import 'package:buddyscripts/models/notifications/notifications_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/notification_state.dart';

final notificationsProvider = StateNotifierProvider<NotificationsController,NotificationsState>(
  (ref) => NotificationsController(ref: ref),
);

class NotificationsController extends StateNotifier<NotificationsState> {
  final Ref? ref;

  NotificationsController({this.ref}) : super(const NotificationsInitialState());

  NotificationsModel? notificationsModel;
  List<Notifications> notifications = [];

  Future fetchNotifications({bool reload = true}) async {
    if (reload || notifications.isEmpty) state = const NotificationsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.notifications),
      );
      if (responseBody != null) {
        notificationsModel = NotificationsModel.fromJson(responseBody);
        notifications = notificationsModel!.data!;
        state = NotificationsSuccessState(notifications);
      } else {
        state = const NotificationsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchNotifications(): $error");
      print(stackTrace);
      state = const NotificationsErrorState();
    }
  }

  Future fetchMoreNotifications() async {
    if (notifications.isEmpty) state = const NotificationsLoadingState();
    dynamic responseBody;
    if (notificationsModel!.meta!.nextPageUrl != null) {
      try {
        responseBody = await Network.handleResponse(
          await Network.getRequest(API.notifications + notificationsModel!.meta!.nextPageUrl!),
        );
        if (responseBody != null) {
          NotificationsModel _notificationsModel = NotificationsModel.fromJson(responseBody);
          notificationsModel!.meta = _notificationsModel.meta;
          state = NotificationsSuccessState(notifications..addAll(_notificationsModel.data!));
        } else {
          state = const NotificationsErrorState();
        }
      } catch (error, stackTrace) {
        print("fetchNotifications(): $error");
        print(stackTrace);
        state = const NotificationsErrorState();
      }
    } else {
      //toast("You have reached the end");
    }
  }

  Future markNotificationSeen( notificationId) async {
    dynamic responseBody;
    var requestBody = {'id': notificationId};

    Notifications notification = notifications[notifications.indexWhere((element) => element.id == notificationId)];

    if (notification.seen == 0) {
      try {
        responseBody = await Network.handleResponse(
          await Network.postRequest(API.markNotificationSeen, requestBody),
        );
        if (responseBody != null) {
          notification.seen = 1;
          state = NotificationsSuccessState(notifications);
        } else {
          state = const NotificationsErrorState();
        }
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        state = const NotificationsErrorState();
      }
    }
  }

  Future markNotificationUnSeen(int notificationId) async {
    dynamic responseBody;
    var requestBody = {'id': notificationId};

    Notifications notification = notifications[notifications.indexWhere((element) => element.id == notificationId)];

    if (notification.seen == 1) {
      try {
        responseBody = await Network.handleResponse(
          await Network.postRequest(API.markNotificationUnSeen, requestBody),
        );
        if (responseBody != null) {
          notification.seen = 0;
          state = NotificationsSuccessState(notifications);
        } else {
          state = const NotificationsErrorState();
        }
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        state = const NotificationsErrorState();
      }
    }
  }

  Future deleteNotification(notificationId) async {
    dynamic responseBody;
    var requestBody = {
      'id': notificationId,
    };

    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.deleteNotification, requestBody),
      );
      if (responseBody != null) {
        notifications.removeWhere((element) => element.id == notificationId);
        state = NotificationsSuccessState(notifications);
      } else {
        state = const NotificationsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const NotificationsErrorState();
    }
  }
}
