import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class SwipeText extends StatefulWidget {
  const SwipeText({Key? key}) : super(key: key);

  @override
  _SwipeTextState createState() => _SwipeTextState();
}

class _SwipeTextState extends State<SwipeText> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Swipe To Example')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ///SwipeToRight Example
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SwipeTo(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: const Text('Hey You! Swipe me right 👉🏿'),
                    ),
                  ),
                  onRightSwipe: () {
                    _displayInputBottomSheet(true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSwipeReply({bool? isRightSwipe, String? reply}) {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(reply ?? '', textAlign: TextAlign.center),
        backgroundColor: isRightSwipe! ? Colors.red.shade600 : Colors.green.shade600,
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  void _displayInputBottomSheet(bool isRightSwipe) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              onSubmitted: (value) => _handleSwipeReply(isRightSwipe: isRightSwipe ? true : false, reply: value),
              style: KTextStyle.bodyText1.copyWith(color: KColor.black),
              decoration: const InputDecoration(
                labelText: 'Reply',
                hintText: 'enter reply here',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
            ),
          ),
        );
      },
    );
  }
}
