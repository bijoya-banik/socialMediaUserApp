import 'package:buddyscripts/controller/event/event_feed_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/models/event/event_feed_model.dart';

class EventOptionsModal extends ConsumerStatefulWidget {
  final IsGoing? isGoing;
  const EventOptionsModal(this.isGoing, {Key? key}) : super(key: key);

  @override
  _EventOptionsModalState createState() => _EventOptionsModalState();
}

class _EventOptionsModalState extends ConsumerState<EventOptionsModal> {
  int selectedIndex = 0;

  List eventOptions = [
    {'icon': FontAwesome5.check_circle, 'title': 'Going'},
    {'icon': FontAwesome5.star, 'title': 'Interested'},
    {'icon': FontAwesome5.times_circle, 'title': 'Not Interested'},
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.isGoing == null
        ? 2
        : widget.isGoing?.status == 'interested'
            ? 1
            : widget.isGoing?.status == 'going'
                ? 0
                : 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KColor.appBackground,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                width: 65,
                height: 5,
                decoration: BoxDecoration(color: KColor.grey200, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25))),
          ),
          Column(
            children: List.generate(eventOptions.length, (index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 23.0,
                  backgroundColor: selectedIndex != index ? KColor.black87.withOpacity(0.1) : KColor.primary.withOpacity(0.1),
                  child: Icon(eventOptions[index]['icon'], size: 18, color: selectedIndex != index ? KColor.black87 : KColor.primary),
                ),
                title: Text(
                  eventOptions[index]['title'],
                  style: KTextStyle.bodyText1.copyWith(color: selectedIndex != index ? KColor.black87 : KColor.primary, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  Navigator.pop(context);

                  if ((widget.isGoing == null || widget.isGoing?.status == "") && selectedIndex == 2) {
                  } else {
                    ref.read(eventFeedProvider.notifier).acceptInvite(eventOptions[index]['title'].toLowerCase());
                  }
                },
                trailing: selectedIndex != index ? null : Icon(Icons.done, color: KColor.primary),
              );
            }),
          ),
        ],
      ),
    );                                      
  }
}
