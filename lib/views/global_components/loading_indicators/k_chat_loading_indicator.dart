import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KChatLoadingIndicator extends StatelessWidget {
  final int feedItemCount;

  const KChatLoadingIndicator({this.feedItemCount = 3, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: feedItemCount,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(top: 20, bottom: 30),
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: KColor.white,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(color: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!, width: 0.55),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 0),
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: index % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: index % 2 == 0 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: <Widget>[
                      Shimmer.fromColors(
                        baseColor: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!,
                        highlightColor: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!,
                        child: SizedBox(
                          width: 100,
                          height: 22,
                          child: Container(
                            color: AppMode.darkMode ? KColor.grey850const : KColor.grey200const,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: Shimmer.fromColors(
                          baseColor: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!,
                          highlightColor: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!,
                          child: SizedBox(
                            width: 50,
                            height: 12,
                            child: Container(
                              color: AppMode.darkMode ? KColor.grey800const : KColor.grey100const,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
