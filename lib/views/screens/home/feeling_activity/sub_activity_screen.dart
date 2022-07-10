import 'package:buddyscripts/controller/feelings_activities/feelings_controller.dart';
import 'package:buddyscripts/controller/feelings_activities/state/sub_activities_state.dart';
import 'package:buddyscripts/controller/feelings_activities/sub_activities_controller.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubActivityScreen extends ConsumerStatefulWidget {
  final FeelingsModel? subActivity;
  const SubActivityScreen({this.subActivity, Key? key}) : super(key: key);

  @override
  _SubActivityScreenState createState() => _SubActivityScreenState();
}

class _SubActivityScreenState extends ConsumerState<SubActivityScreen> {
  FeelingsModel? feelingData;

  @override
  void initState() {
    super.initState();
    //  feelingData = widget.feelingsModeldata;
  }

  @override
  Widget build(BuildContext context) {
    final subActivitiesState = ref.watch(subActivitiesProvider);

    TextEditingController searchController = TextEditingController();
    final _debouncer = Debouncer(milliseconds: 500);

    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: '${widget.subActivity?.name ?? ""}...', automaticallyImplyLeading: false, hasLeading: true),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Container(
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
                  ref.read(subActivitiesProvider.notifier).refresh(ref.read(subActivitiesProvider.notifier).storeSubActivitiesModel);
                },
                callBackFunction: (String value) {
                  if (value.isNotEmpty) {
                    _debouncer.run(() {
                      ref.read(subActivitiesProvider.notifier).searchSubActivities(str: value, id: widget.subActivity?.id);
                    });
                  } else {
                    ref.read(subActivitiesProvider.notifier).refresh(ref.read(subActivitiesProvider.notifier).storeSubActivitiesModel);
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: subActivitiesState is SubActivitiesSuccessState
                  ? subActivitiesState.subActivitiesModel.isEmpty
                      ? const KContentUnvailableComponent(
                          message: "No result found",
                        )
                      : ListView.builder(
                          itemCount: subActivitiesState.subActivitiesModel.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                FeelingsModel feelingData;
                                feelingData = FeelingsModel(
                                  icon: subActivitiesState.subActivitiesModel[index].icon,
                                  type: widget.subActivity?.name,
                                  name: subActivitiesState.subActivitiesModel[index].name,
                                );
                                Navigator.of(context).pop(feelingData);
                                Navigator.of(context).pop(feelingData);

                                ref.read(feelingsProvider.notifier).selectedfeelingData = feelingData;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.black54,
                                  width: 0.3,
                                )),
                                child: Row(
                                  children: [
                                    // Image.network(
                                    //   subActivitiesState.subActivitiesModel[index].icon!,
                                    //   height: 25,
                                    //   width: 25,
                                    // ),
                                   // const SizedBox(width: 8),
                                    Expanded(
                                        child: Text(subActivitiesState.subActivitiesModel[index].name!,
                                            style: KTextStyle.subtitle2.copyWith(color: KColor.black87), overflow: TextOverflow.ellipsis)),
                                  ],
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
      ),
    );
  }
}
