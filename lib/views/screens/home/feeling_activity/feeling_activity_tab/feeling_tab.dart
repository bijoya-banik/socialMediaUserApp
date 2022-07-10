import 'package:buddyscripts/controller/feelings_activities/feelings_controller.dart';
import 'package:buddyscripts/controller/feelings_activities/state/feelings_state.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeelingTab extends ConsumerStatefulWidget {
  final FeelingsModel? feelingsModeldata;
  const FeelingTab({this.feelingsModeldata, Key? key}) : super(key: key);

  @override
  _FeelingTabState createState() => _FeelingTabState();
}

class _FeelingTabState extends ConsumerState<FeelingTab> {
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
    final feelingsState = ref.watch(feelingsProvider);

    TextEditingController searchController = TextEditingController();
    final _debouncer = Debouncer(milliseconds: 500);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          feelingData != null && feelingData?.type == "FEELINGS"
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Image.network(
                          //   feelingData!.icon!,
                          //   height: 25,
                          //   width: 25,
                          // ),
                          const SizedBox(width: 8),
                          Text(feelingData!.type == "FEELINGS" ? "Feeling " : " ",
                              style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w400)),
                          Text(feelingData!.name!, style: KTextStyle.subtitle2.copyWith(color: KColor.black87)),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              feelingData = null;
                            });
                            ref.read(feelingsProvider.notifier).selectedfeelingData = null;
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
                    autofocus: true,
                    callBack: true,
                    suffixCallback: true,
                    suffixCallbackFunction: () {
                      ref.read(feelingsProvider.notifier).refresh(ref.read(feelingsProvider.notifier).storeFeelingsModel);
                    },
                    callBackFunction: (String value) {
                      if (value.isNotEmpty) {
                        _debouncer.run(() => {ref.read(feelingsProvider.notifier).searchFeelings(value)});
                      } else {
                        ref.read(feelingsProvider.notifier).refresh(ref.read(feelingsProvider.notifier).storeFeelingsModel);
                      }
                    },
                  ),
                ),
          const SizedBox(height: 10),
          Expanded(
            child: feelingsState is FeelingsSuccessState
                ? feelingsState.feelingsModel.isEmpty
                    ? const KContentUnvailableComponent(message: "No result found")
                    : GridView.builder(
                        itemCount: feelingsState.feelingsModel.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 5, crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pop(feelingsState.feelingsModel[index]);

                              ref.read(feelingsProvider.notifier).selectedfeelingData = feelingsState.feelingsModel[index];
                            },
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black54, width: 0.3)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    // Image.network(
                                    //   feelingsState.feelingsModel[index].icon!,
                                    //   height: 25,
                                    //   width: 25,
                                    // ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text(feelingsState.feelingsModel[index].name!,
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
