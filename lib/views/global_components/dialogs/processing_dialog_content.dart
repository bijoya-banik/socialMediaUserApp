import 'package:buddyscripts/views/global_components/loading_indicators/k_loading_indicator.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';

class ProcessingDialogContent extends StatelessWidget {
  final String text;
  const ProcessingDialogContent(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: KColor.textBackground,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const KLoadingIndicator(),
            Container(
              margin: const EdgeInsets.only(left: 12),
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: KTextStyle.subtitle2.copyWith(color: KColor.black87),
              ),
            )
          ],
        ));
  }
}
