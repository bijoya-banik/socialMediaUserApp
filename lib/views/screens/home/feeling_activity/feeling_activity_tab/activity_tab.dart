import 'package:buddyscripts/controller/feelings_activities/activities_controller.dart';
import 'package:buddyscripts/controller/feelings_activities/feelings_controller.dart';
import 'package:buddyscripts/controller/feelings_activities/state/activities_state.dart';
import 'package:buddyscripts/controller/feelings_activities/sub_activities_controller.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/screens/home/feeling_activity/sub_activity_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityTab extends ConsumerStatefulWidget {
  final FeelingsModel? feelingsModeldata;
  const ActivityTab({this.feelingsModeldata, Key? key}) : super(key: key);

  @override
  _ActivityTabState createState() => _ActivityTabState();
}

class _ActivityTabState extends ConsumerState<ActivityTab> {
  FeelingsModel? feelingData;

  @override
  void initState() {
    super.initState();
    feelingData = widget.feelingsModeldata;
    ref.read(feelingsProvider.notifier).selectedfeelingData = feelingData;
    //= widget.feelingsModeldata;
  }

  @override
  Widget build(BuildContext context) {
    final activitiesState = ref.watch(activitiesProvider);

    TextEditingController searchController = TextEditingController();
    final _debouncer = Debouncer(milliseconds: 500);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          feelingData != null && feelingData?.type != "FEELINGS"
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            feelingData!.icon!,
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(width: 8),
                          Text(feelingData!.type == "FEELINGS" ? "Feeling " : '${feelingData!.type} ',
                              style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.w400)),
                          Text(feelingData!.name!, style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              feelingData = null;
                            });
                            ref.read(feelingsProvider.notifier).selectedfeelingData = null;

                            print("objectrrrrrrrrr");
                            print(ref.read(feelingsProvider.notifier).selectedfeelingData);
                          },
                          child: Icon(Icons.close, color: KColor.black54, size: 18))
                    ],
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: KTextField(
                    hintText: 'Search',
                    topMargin: 5,
                    hasPrefixIcon: true,
                    prefixIcon: Icon(Feather.search, color: KColor.black54, size: 20),
                    isClearableField: true,
                    backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.grey300!.withOpacity(0.7),
                    borderRadius: 50,
                    controller: searchController,
                    // autofocus: true,
                    callBack: true,
                    suffixCallback: true,
                    suffixCallbackFunction: () {
                      ref.read(activitiesProvider.notifier).refresh(ref.read(activitiesProvider.notifier).storeActivitiesModel);
                    },
                    callBackFunction: (String value) {
                      if (value.isNotEmpty) {
                        _debouncer.run(() {
                          ref.read(activitiesProvider.notifier).searchActivities(value);
                        });
                      } else {
                        ref.read(activitiesProvider.notifier).refresh(ref.read(activitiesProvider.notifier).storeActivitiesModel);
                      }
                    },
                  ),
                ),
          const SizedBox(height: 10),
          Expanded(
            child: activitiesState is ActivitiesSuccessState
                ? activitiesState.activitiesModel.isEmpty
                    ? const KContentUnvailableComponent(
                        message: "No result found",
                      )
                    :GridView.builder(
                    itemCount: activitiesState.activitiesModel.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 5, crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          ref.read(subActivitiesProvider.notifier).fetchSubActivities(id: activitiesState.activitiesModel[index].id);
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => SubActivityScreen(subActivity: activitiesState.activitiesModel[index])));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black54,
                            width: 0.3,
                          )),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                // Image.network(
                                //   activitiesState.activitiesModel[index].icon!,
                                //   height: 25,
                                //   width: 25,
                                // ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(activitiesState.activitiesModel[index].name!,
                                        style: KTextStyle.subtitle2.copyWith(color: KColor.black87), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                : Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 10, top: 5),
                    child: const CupertinoActivityIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}
