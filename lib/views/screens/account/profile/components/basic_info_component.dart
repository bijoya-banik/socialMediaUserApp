import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/screens/account/components/profile_info_tile.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicInfoComponent extends StatefulWidget {
  final ProfileOverView basicProfileData;

  const BasicInfoComponent(this.basicProfileData, {Key? key}) : super(key: key);

  @override
  _BasicInfoComponentState createState() => _BasicInfoComponentState();
}

class _BasicInfoComponentState extends State<BasicInfoComponent> {
  String isEditable = '';
  bool isLoading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.basicProfileData.firstName ?? '';
    lastNameController.text = widget.basicProfileData.lastName ?? '';
    nicknameController.text = widget.basicProfileData.nickName ?? '';
    birthdayController.text = widget.basicProfileData.birthDate == null ? '' : DateTimeService.convert(widget.basicProfileData.birthDate);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final profileAboutState = ref.watch(profileAboutProvider);
        final ProfileOverView? profileAboutData =
            profileAboutState is ProfileAboutSuccessState ? profileAboutState.profileOverviewModel.basicOverView : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Basic Info', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.w700, color: KColor.black)),
            SizedBox(height: KSize.getHeight(context, 5)),
            // isEditable != 'Name' ?
            ProfileInfoTile(
              icon: Icon(Icons.person, color: KColor.black54),
              value: '${profileAboutData!.firstName} ${profileAboutData.lastName}',
              title: 'Name',
            ),
            SizedBox(height: KSize.getHeight(context, 5)),
            ProfileInfoTile(
              icon: Icon(Icons.calendar_today, color: KColor.black54),
              value: profileAboutData.birthDate == null ? '--' : DateTimeService.convert(profileAboutData.birthDate).toString(),
              title: 'Birthday',
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
