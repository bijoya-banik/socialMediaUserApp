import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KFeedLoadingIndicator extends StatelessWidget {
  final int feedItemCount;

  const KFeedLoadingIndicator({this.feedItemCount = 7, Key? key}) : super(key: key);

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
              color: AppMode.darkMode ? KColor.appBackground : KColor.white,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(color: AppMode.darkMode ? KColor.grey700! : KColor.grey200!, width: 0.55),
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
                              baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                              highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                              child: const CircleAvatar(radius: 20.0),
                            ),
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Shimmer.fromColors(
                                baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                                highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                                child: SizedBox(
                                  width: 100,
                                  height: 22,
                                  child: Container(color: AppMode.darkMode ? KColor.grey700 : KColor.grey200),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                child: Shimmer.fromColors(
                                  baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                                  highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                                  child: SizedBox(
                                    width: 50,
                                    height: 12,
                                    child: Container(color: AppMode.darkMode ? KColor.grey600 : KColor.grey100),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
                        child: Shimmer.fromColors(
                          baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                          highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 10,
                            child: Container(color: AppMode.darkMode ? KColor.grey700 : KColor.grey200),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 0),
                        child: Shimmer.fromColors(
                          baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                          highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            height: 10,
                            child: Container(color: AppMode.darkMode ? KColor.grey600 : KColor.grey100),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 0),
                        child: Shimmer.fromColors(
                          baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                          highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            height: 10,
                            child: Container(color: AppMode.darkMode ? KColor.grey600 : KColor.grey100),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
