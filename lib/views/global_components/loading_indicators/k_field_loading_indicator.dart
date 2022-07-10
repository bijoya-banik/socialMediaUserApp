import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:shimmer/shimmer.dart';

class KFieldLoadingIndicator extends StatefulWidget {
  const KFieldLoadingIndicator({Key? key}) : super(key: key);

  @override
  _KFieldLoadingIndicatorState createState() => _KFieldLoadingIndicatorState();
}

class _KFieldLoadingIndicatorState extends State<KFieldLoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Shimmer.fromColors(
        baseColor: AppMode.darkMode ? KColor.grey900! : KColor.grey300!,
        highlightColor: AppMode.darkMode ? KColor.grey800! : KColor.grey100!,
        enabled: true,
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: KColor.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
