import 'package:buddyscripts/models/notifications/notifications_model.dart';

abstract class NotificationsState {
  const NotificationsState();
}

class NotificationsInitialState extends NotificationsState {
  const NotificationsInitialState();
}

class NotificationsLoadingState extends NotificationsState {
  const NotificationsLoadingState();
}

class NotificationsSuccessState extends NotificationsState {
  final List<Notifications> notifications;
  const NotificationsSuccessState(this.notifications);
}

class NotificationsErrorState extends NotificationsState {
  const NotificationsErrorState();
}
