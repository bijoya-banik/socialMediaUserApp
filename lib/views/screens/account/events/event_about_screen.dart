import 'package:buddyscripts/controller/event/event_about_controller.dart';
import 'package:buddyscripts/controller/event/state/event_about_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class EventAboutScreen extends ConsumerWidget {
  const EventAboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAboutState = ref.watch(eventAboutProvider);
    final eventAboutData = eventAboutState is EventAboutSuccessState ? eventAboutState.eventAboutModel : null;
    return CupertinoPageScaffold(
      backgroundColor: KColor.white,
      navigationBar: eventAboutState is EventAboutSuccessState
          ? KCupertinoNavBar(
              title: eventAboutData!.basicOverView!.eventName,
              automaticallyImplyLeading: false,
              hasLeading: true,
            )
          : null,
      child: eventAboutState is EventAboutSuccessState
          ? CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(
                    onRefresh: () => ref.read(eventAboutProvider.notifier).fetchEventAbout(eventAboutData!.basicOverView!.slug!)),
                SliverToBoxAdapter(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                          SizedBox(height: KSize.getHeight(context, 15)),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: Icon(Icons.location_pin, color: KColor.black87),
                            title: Text(eventAboutData!.basicOverView!.address ?? '', style: KTextStyle.subtitle1.copyWith(color: KColor.black87)),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: Icon(Icons.people, color: KColor.black87),
                            title: Row(
                              children: [
                                Text('${eventAboutData.basicOverView!.going!.length} Going',
                                    style: KTextStyle.subtitle1.copyWith(color: KColor.black87)),
                                SizedBox(width: KSize.getWidth(context, 5)),
                                Icon(Icons.circle, size: 5, color: KColor.black87),
                                SizedBox(width: KSize.getWidth(context, 5)),
                                Text('${eventAboutData.basicOverView!.interested!.length} Interested',
                                    style: KTextStyle.subtitle1.copyWith(color: KColor.black87)),
                              ],
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: Icon(Icons.info_outlined, color: KColor.black87),
                            title: Text(
                              eventAboutData.basicOverView!.about ?? '',
                              style: KTextStyle.bodyText3.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
              ],
            )
          : const Center(child: CupertinoActivityIndicator()),
    );
  }
}
