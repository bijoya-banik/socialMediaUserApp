import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KProfileOverviewLoadingIndicator extends StatelessWidget {
  final int feedItemCount;

  const KProfileOverviewLoadingIndicator({Key? key, this.feedItemCount = 7}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 30, left: 10, right: 10),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: KColor.white,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!, width: 0.55),
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Shimmer.fromColors(
                    baseColor: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!,
                    highlightColor: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!,
                    child: SizedBox(
                      width: 100,
                      height: 22,
                      child: Container(color: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!),
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
                        child: Container(color: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(1.0),
                child: Shimmer.fromColors(
                  baseColor: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!,
                  highlightColor: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!,
                  child: const CircleAvatar(radius: 60),
                ),
                decoration: const BoxDecoration(shape: BoxShape.circle),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
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
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Shimmer.fromColors(
                                      baseColor: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!,
                                      highlightColor: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!,
                                      child: SizedBox(
                                        width: 100,
                                        height: 22,
                                        child: Container(color: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!),
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
                                          child: Container(color: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
