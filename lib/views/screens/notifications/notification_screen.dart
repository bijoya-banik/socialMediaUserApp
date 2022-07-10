import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/friends/friend_requests_controller.dart';
import 'package:buddyscripts/controller/friends/state/friend_requests_state.dart';
import 'package:buddyscripts/controller/notifications/notification_controller.dart';
import 'package:buddyscripts/controller/notifications/state/notification_state.dart';
import 'package:buddyscripts/controller/pagination/notification/notification_screen.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_conversations_loading_indicator.dart';
import 'package:buddyscripts/views/screens/account/components/friend_requests_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/screens/notifications/components/notification_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  final bool isLeading;
  const NotificationScreen({Key? key, this.isLeading = false}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  int _sliding = 0;
  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsProvider);
    final friendRequestsState = ref.watch(friendRequestsProvider);

    ref.listen(notificationScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        _sliding == 0
            ? ref.read(notificationsProvider.notifier).fetchMoreNotifications()
            : ref.read(friendRequestsProvider.notifier).fetchMoreFriendRequests();
      }
    });
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'Notifications', automaticallyImplyLeading: false, hasLeading: widget.isLeading),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: ref.read(notificationScrollProvider.notifier).controller,
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: () {
            return _sliding == 0
                ? ref.read(notificationsProvider.notifier).fetchNotifications(reload: false)
                : ref.read(friendRequestsProvider.notifier).fetchFriendRequests();
          }),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: CupertinoSlidingSegmentedControl(
                  children: {
                    0: SizedBox(
                        height: KSize.getHeight(context, 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'Activity',
                                style: KTextStyle.subtitle1.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: _sliding == 0 ? KColor.whiteConst : KColor.grey,
                                ),
                              ),
                            ),
                            if ((ref.read(userProvider.notifier).userData?.notiCount?.totalNoti)! > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                decoration: BoxDecoration(color: KColor.red, shape: BoxShape.circle),
                                child: Text(
                                  (ref.read(userProvider.notifier).userData?.notiCount?.totalNoti)! > 9
                                      ? "9+"
                                      : (ref.read(userProvider.notifier).userData?.notiCount?.totalNoti)!.toString(),
                                  textAlign: TextAlign.center,
                                  style: KTextStyle.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: KColor.whiteConst,
                                  ),
                                ),
                              ),
                          ],
                        )),
                    1: SizedBox(
                        height: KSize.getHeight(context, 40),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Friend Requests',
                                  style: KTextStyle.subtitle1.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: _sliding == 1 ? KColor.whiteConst : KColor.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              if ((ref.read(userProvider.notifier).userData?.user?.friendCount)! > 0)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                    decoration: BoxDecoration(color: KColor.red, shape: BoxShape.circle),
                                    child: Text(
                                      (ref.read(userProvider.notifier).userData?.user?.friendCount)! > 9
                                          ? "9+"
                                          : (ref.read(userProvider.notifier).userData?.user?.friendCount)!.toString(),
                                      textAlign: TextAlign.center,
                                      style: KTextStyle.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: KColor.whiteConst,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )),
                  },
                  thumbColor: KColor.primary,
                  padding: const EdgeInsets.all(6),
                  backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.whiteConst,
                  groupValue: _sliding,
                  onValueChanged: (dynamic newValue) {
                    setState(() {
                      _sliding = newValue;
                    });
                    if (_sliding == 0) {
                      ref.read(notificationsProvider.notifier).fetchNotifications(reload: false);
                    }

                    ref.read(friendRequestsProvider.notifier).fetchFriendRequests();

                    if ((ref.read(userProvider.notifier).userData?.user!.friendCount)! > 0) {
                      ref.read(userProvider.notifier).updateFriendReq();
                    }
                    ref.read(userProvider.notifier).updateFriendRequestCount();
                  }),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              sliver: _sliding == 0
                  ? notificationsState is NotificationsSuccessState
                      ? notificationsState.notifications.isEmpty
                          ? SliverToBoxAdapter(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * .50,
                                child: const Center(
                                    child: KContentUnvailableComponent(
                                  message: "No notification yet!",
                                )),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return NotificationCard(notificationsState.notifications[index]);
                                },
                                childCount: notificationsState.notifications.length,
                              ),
                            )
                      : const SliverToBoxAdapter(child: KConversationLoadingIndicator())
                  : friendRequestsState is FriendRequestsSuccessState
                      ? friendRequestsState.friendRequestsModel.data!.isEmpty
                          ? SliverToBoxAdapter(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * .50,
                                child: const Center(
                                    child: KContentUnvailableComponent(
                                  message: "No pending requests!",
                                )),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return FriendRequestsCard(friendRequestsState.friendRequestsModel.data![index]);
                                },
                                childCount: friendRequestsState.friendRequestsModel.data!.length,
                              ),
                            )
                      : const SliverToBoxAdapter(child: KConversationLoadingIndicator())),
        ],
      ),
    );
  }
}
