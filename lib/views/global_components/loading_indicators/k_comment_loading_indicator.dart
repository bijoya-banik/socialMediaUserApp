import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class KCommentLoadingIndicator extends StatelessWidget {
  const KCommentLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 10),
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
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                          child: Shimmer.fromColors(
                            baseColor: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!,
                            highlightColor: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: KSize.getHeight(context, 65),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppMode.darkMode ? KColor.grey850const : KColor.grey200const,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
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
        ),
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 10),
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
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: Shimmer.fromColors(
                      baseColor: AppMode.darkMode ? KColor.grey850const! : KColor.grey200const!,
                      highlightColor: AppMode.darkMode ? KColor.grey800const! : KColor.grey100const!,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: KSize.getHeight(context, 45),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppMode.darkMode ? KColor.grey850const : KColor.grey200const,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
