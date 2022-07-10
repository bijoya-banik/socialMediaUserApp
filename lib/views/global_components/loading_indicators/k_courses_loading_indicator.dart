import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KCoursesLoadingIndicator extends StatelessWidget {
  const KCoursesLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: KSize.getHeight(context, 350),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 5.0),
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext ctx, int index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            width: MediaQuery.of(context).size.width / 1.65,
            decoration: BoxDecoration(
              color: AppMode.darkMode ? KColor.appBackground : KColor.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                  highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                  child: Container(
                    height: KSize.getHeight(context, 160),
                    width: MediaQuery.of(context).size.width / 1.65,
                    color: AppMode.darkMode ? KColor.grey700 : KColor.grey200,
                    child: const ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                          baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                          highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                          child: Container(color: KColor.grey200, height: 20, width: 150)),
                      const SizedBox(height: 10),
                      Shimmer.fromColors(
                          baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                          highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                          child: Container(color: KColor.grey200, height: 20, width: 100)),
                      const SizedBox(height: 10),
                      Shimmer.fromColors(
                          baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                          highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                          child: Container(color: AppMode.darkMode ? KColor.grey600 : KColor.grey200, height: 20, width: 80)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
