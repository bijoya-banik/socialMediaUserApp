import 'package:buddyscripts/controller/event/event_feed_controller.dart';
import 'package:buddyscripts/models/event/events_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/screens/account/events/event_details_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class EventCard extends ConsumerWidget {
  final EventDatum? eventData;
   const EventCard({Key? key, this.eventData}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  GestureDetector(
            onTap: () {
              ref.read(eventFeedProvider.notifier).fetchEventFeed(eventData!.slug!);
              Navigator.push(context, CupertinoPageRoute(builder: (context) => EventDetailsScreen()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(color: KColor.textBackground, borderRadius: const BorderRadius.all(Radius.circular(6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(8)),
                    child: Image.network(
                      API.baseUrl+eventData!.cover!,
                      height: KSize.getHeight(context, 150),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: KSize.getHeight(context, 10)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateTimeService.convert(eventData!.startTime, isLongDate: false),
                            overflow: TextOverflow.ellipsis, style: KTextStyle.subtitle2.copyWith(letterSpacing: 0.75, color: KColor.black)),
                        SizedBox(height: KSize.getHeight(context, 2.5)),
                        Text(
                          eventData!.eventName!,
                          overflow: TextOverflow.ellipsis,
                          style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.2, color: KColor.black),
                        ),
                        SizedBox(height: KSize.getHeight(context, 3.5)),
                        Text(
                          eventData!.address!,
                          overflow: TextOverflow.ellipsis,
                          style: KTextStyle.subtitle2.copyWith(fontWeight: FontWeight.w500, color: KColor.black54),
                        ),
                        SizedBox(height: KSize.getHeight(context, 7)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${eventData!.going!.length} going', style: KTextStyle.bodyText2.copyWith(color: KColor.black54)),
                            /*
                        * Interested count design code snippet
                      */
                            // SizedBox(width: KSize.getWidth(context, 5)),
                            // Icon(Icons.circle, size: 4, color: KColor.black54),
                            // SizedBox(width: KSize.getWidth(context, 5)),
                            // Text('10 Interested', style: KTextStyle.bodyText2.copyWith(color: KColor.black54)),
                          ],
                        ),
                        SizedBox(height: KSize.getHeight(context, 10)),
                        /*
                    * User event response button and share button design code snippet
                  */
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: KButton(
                        //         title: 'Interested' /* 'Going' */,
                        //         textColor: KColor.primary,
                        //         color: KColor.primary.withOpacity(0.1),
                        //         innerPadding: 10,
                        //         leadingTitleIcon: Icon(FontAwesome5.star /* FontAwesome5.check_circle */, size: 18, color: KColor.primary),
                        //         trailingTitleIcon: Icon(FontAwesome5.caret_down, size: 18, color: KColor.primary),
                        //         onPressedCallback: () {
                        //           showModalBottomSheet(
                        //               context: context,
                        //               isDismissible: true,
                        //               elevation: 5,
                        //               isScrollControlled: true,
                        //               useRootNavigator: true,
                        //               backgroundColor: KColor.white,
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                        //               ),
                        //               builder: (context) {
                        //                 return EventOptionsModal();
                        //               });
                        //         },
                        //       ),
                        //     ),
                        //     SizedBox(width: KSize.getWidth(context, 8)),
                        //     Container(
                        //       decoration: BoxDecoration(color: KColor.appBackground, borderRadius: BorderRadius.circular(6)),
                        //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        //       child: InkWell(
                        //         onTap: () {},
                        //         child: Transform(
                        //           transform: Matrix4.rotationY(Math.pi),
                        //           alignment: Alignment.center,
                        //           child: Icon(CupertinoIcons.reply, color: KColor.black87),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: KSize.getHeight(context, 5)),
                ],
              ),
            ),
          );
  }
}
