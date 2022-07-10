import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/screens/account/components/profile_info_tile.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkEducationComponent extends ConsumerWidget {
  const WorkEducationComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAboutState = ref.watch(profileAboutProvider);
    final ProfileOverView? profileAboutData =
        profileAboutState is ProfileAboutSuccessState ? profileAboutState.profileOverviewModel.basicOverView : null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text('Work and Education', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.w700, color: KColor.black))),
          ],
        ),
        profileAboutData!.workData!.isEmpty
            ? ProfileInfoTile(
                icon: Icon(Icons.work, color: KColor.black54),
                value: "--",
                title: "Not given yet",
              )
            : Column(
                children: List.generate(profileAboutData.workData!.length, (index) {
                  return ProfileInfoTile(
                    icon: Icon(Entypo.suitcase, color: KColor.black54),
                    value: '${profileAboutData.workData![index].position} at ${profileAboutData.workData![index].comapnyName}',
                    title: DateTimeService.convert(profileAboutData.workData![index].startingDate) +
                        ' - ' +
                        (profileAboutData.workData![index].isCurrentlyWorking!
                            ? 'Present'
                            : DateTimeService.convert(profileAboutData.workData![index].endingDate)),
                  );
                }),
              ),
        Column(
          children: List.generate(profileAboutData.educationData!.length, (index) {
            return ProfileInfoTile(
              icon: Icon(MaterialCommunityIcons.school, color: KColor.black54),
              value: '${profileAboutData.educationData![index].position} at ${profileAboutData.educationData![index].comapnyName}',
              title: DateTimeService.convert(profileAboutData.educationData![index].startingDate) +
                  ' - ' +
                  (profileAboutData.educationData![index].isCurrentlyWorking
                      ? 'Present'
                      : DateTimeService.convert(profileAboutData.educationData![index].endingDate)),
            );
          }),
        ),
        SizedBox(height: KSize.getHeight(context, 5)),
      ],
    );
  }
}
