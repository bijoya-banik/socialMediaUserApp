import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KProfileLoadingIndicator extends StatelessWidget {
  const KProfileLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: KColor.appBackground,
      child: Column(
        children: <Widget>[
          Container(
            color: AppMode.darkMode ? KColor.appBackground : KColor.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                  highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                  child: const Icon(Icons.arrow_back_ios_rounded, size: 30),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Shimmer.fromColors(
                    baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                    highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                    child: const CircleAvatar(radius: 20.0),
                  ),
                ),
                const SizedBox(width: 10),
                Shimmer.fromColors(
                  baseColor: AppMode.darkMode ? KColor.grey800! : KColor.grey200!,
                  highlightColor: AppMode.darkMode ? KColor.grey900! : KColor.grey100!,
                  child: SizedBox(
                    width: 100,
                    height: 10,
                    child: Container(color: AppMode.darkMode ? KColor.grey900 : KColor.grey100),
                  ),
                ),
              ],
            ),
          ),
          Shimmer.fromColors(
            baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
            highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
            child: Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              color: KColor.grey,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(top: 3),
            child: Shimmer.fromColors(
              baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
              highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
              child: SizedBox(
                width: 100,
                height: 10,
                child: Container(color: KColor.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                child: Shimmer.fromColors(
                  baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                  highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                  child: Container(width: 100, height: 30, color: KColor.grey),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                margin: const EdgeInsets.only(top: 3),
                child: Shimmer.fromColors(
                  baseColor: AppMode.darkMode ? KColor.grey700! : KColor.grey200!,
                  highlightColor: AppMode.darkMode ? KColor.grey600! : KColor.grey100!,
                  child: Container(
                    width: 100,
                    height: 30,
                    color: AppMode.darkMode ? KColor.grey600 : KColor.grey100,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: KColor.appBackground,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: AppMode.darkMode ? KColor.grey600! : KColor.grey100!, width: 0.55),
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
                                          child: Container(color: AppMode.darkMode ? KColor.grey600 : KColor.grey100),
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
                                    child: Container(color: AppMode.darkMode ? KColor.grey600 : KColor.grey100),
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
                }),
          )
        ],
      ),
    );
  }
}
