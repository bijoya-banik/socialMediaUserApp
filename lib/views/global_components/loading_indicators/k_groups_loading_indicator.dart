import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KGroupsLoadingIndicator extends StatelessWidget {
  final int feedItemCount;

  const KGroupsLoadingIndicator({Key? key, this.feedItemCount = 7}) : super(key: key);

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
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppMode.darkMode ? KColor.appBackground : KColor.white,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(color: AppMode.darkMode ? KColor.grey700! : KColor.grey200!, width: 0.55),
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
                        baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                        highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Container(color: AppMode.darkMode ? KColor.grey700 : KColor.grey200),
                        ),
                      ),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Shimmer.fromColors(
                            baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                            highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 25,
                              child: Container(color: AppMode.darkMode ? KColor.grey700 : KColor.grey200),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Shimmer.fromColors(
                              baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                              highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 15,
                                child: Container(color: AppMode.darkMode ? KColor.grey600 : KColor.grey100),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Shimmer.fromColors(
                              baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                              highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 12,
                                child: Container(color: AppMode.darkMode ? KColor.grey600 : KColor.grey100),
                              ),
                            ),
                          ),
                        ],
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
