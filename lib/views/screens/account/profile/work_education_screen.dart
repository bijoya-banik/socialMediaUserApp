import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/screens/account/components/profile_info_tile.dart';
import 'package:buddyscripts/views/screens/account/components/work_education_options_modal.dart';
import 'package:buddyscripts/views/screens/account/profile/work_add_edit_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

// ignore: must_be_immutable
class WorkEducationScreen extends ConsumerStatefulWidget {
  const WorkEducationScreen({Key? key}) : super(key: key);

  @override
  _WorkEducationScreenState createState() => _WorkEducationScreenState();
}

class _WorkEducationScreenState extends ConsumerState<WorkEducationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: KColor.appBackground,
        navigationBar: KCupertinoNavBar(title: 'Work', automaticallyImplyLeading: false, hasLeading: true),
        child: Consumer(
          builder: (context, ref, _) {
            final profileAboutState = ref.watch(profileAboutProvider);
            final ProfileOverView? profileAboutData =
                profileAboutState is ProfileAboutSuccessState ? profileAboutState.profileOverviewModel.basicOverView : null;

            return profileAboutState is ProfileAboutSuccessState
                ? CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      CupertinoSliverRefreshControl(
                          onRefresh: () => ref.read(profileAboutProvider.notifier).fetchProfileAbout(profileAboutData!.username!)),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Work', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.w700, color: KColor.black)),
                            SizedBox(height: KSize.getHeight(context, 10)),
                            Material(
                              color: KColor.appBackground,
                              child: InkWell(
                                onTap: () =>
                                    Navigator.push(context, CupertinoPageRoute(builder: (context) => const WorkAddEditScreen(isEdit: false))),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add, size: 20, color: KColor.primary),
                                      SizedBox(width: KSize.getWidth(context, 10)),
                                      Text('Add Work Experience', style: KTextStyle.bodyText3.copyWith(color: KColor.black87)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 5, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 0.1,
                                color: KColor.grey),
                            Column(
                              children: List.generate(profileAboutData!.workData!.length, (index) {
                                return Column(
                                  children: [
                                    ProfileInfoTile(
                                      icon: Icon(Entypo.suitcase, color: KColor.black54),
                                      value: '${profileAboutData.workData![index].position} at ${profileAboutData.workData![index].comapnyName}',
                                      title: DateTimeService.convert(profileAboutData.workData![index].startingDate) +
                                          ' - ' +
                                          (profileAboutData.workData![index].isCurrentlyWorking!
                                              ? 'Present'
                                              : DateTimeService.convert(profileAboutData.workData![index].endingDate)),
                                      onInlineEdit: () {
                                        _showOptionsModal(context, profileAboutData.workData![index], index);
                                      },
                                    ),
                                  ],
                                );
                              }),
                            ),
                            SizedBox(height: KSize.getHeight(context, 10)),
                            SizedBox(height: KSize.getHeight(context, 10)),
                          ],
                        ),
                      )),
                    ],
                  )
                : const Center(child: CupertinoActivityIndicator());
          },
        ));
  }

  void _showOptionsModal(context, workData, index) {
    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        backgroundColor: KColor.appBackground,
        elevation: 5,
        isScrollControlled: true,
        useRootNavigator: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      ),
      builder: (_) => PlatformWidget(
        material: (_, __) => WorkEducationOptionsModal(workData: workData, index: index),
        cupertino: (_, __) => WorkEducationOptionsModal(isPlatformIos: true, workData: workData, index: index),
      ),
    );
    /*
      * Code snippet to show platform wise bottom sheet, in case plugin doesn't work as expected
    */
    // !Platform.isAndroid
    //     ? showModalBottomSheet(
    //         context: context,
    //         elevation: 5,
    //         isScrollControlled: true,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
    //         ),
    //         builder: (BuildContext bc) {
    //           return WorkEducationOptionsModal();
    //         })
    //     : showCupertinoModalPopup(
    //         context: context,
    //         builder: (context) {
    //           return WorkEducationOptionsModal(isPlatformIos: true);
    //         });
  }
}
