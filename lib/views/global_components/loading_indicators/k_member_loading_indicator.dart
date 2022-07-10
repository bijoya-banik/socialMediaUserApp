import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KMemberLoadingIndicator extends StatelessWidget {
  final int feedItemCount;

  const KMemberLoadingIndicator({this.feedItemCount = 7, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: feedItemCount,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            decoration: BoxDecoration(
              color: KColor.white,
              border: Border(bottom: BorderSide(color: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!, width: 0.55)),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 0),
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(1.0),
                    child: Shimmer.fromColors(
                      baseColor: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!,
                      highlightColor: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!,
                      child: const CircleAvatar(radius: 20.0),
                    ),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                  ),
                  Shimmer.fromColors(
                    baseColor: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!,
                    highlightColor: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      height: 25,
                      child: Container(color: AppMode.darkMode ? KColor.grey850const : KColor.grey200const),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
