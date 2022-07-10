import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KFriendsLoadingIndicator extends StatelessWidget {
  final int feedItemCount;

  const KFriendsLoadingIndicator({Key? key, this.feedItemCount = 7}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        runSpacing: 15,
        spacing: 15,
        alignment: WrapAlignment.center,
        children: List.generate(feedItemCount, (index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 20),
            margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
            decoration: BoxDecoration(
              color: KColor.appBackground,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(color: AppMode.darkMode ? KColor.grey700! : KColor.grey350!, width: 0.55),
            ),
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(1.0),
                      child: Shimmer.fromColors(
                        baseColor: AppMode.darkMode ? KColor.grey900! : KColor.grey200!,
                        highlightColor: AppMode.darkMode ? KColor.grey800! : KColor.grey100!,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppMode.darkMode ? KColor.grey900 : KColor.grey200),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Shimmer.fromColors(
                        baseColor: AppMode.darkMode ? KColor.grey900! : KColor.grey200!,
                        highlightColor: AppMode.darkMode ? KColor.grey800! : KColor.grey100!,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 25,
                          child: Container(color: KColor.grey200),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }));
  }
}
