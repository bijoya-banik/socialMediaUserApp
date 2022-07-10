import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePhotoCoverComponent extends StatelessWidget {
  const ProfilePhotoCoverComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final profileAboutState = ref.watch(profileAboutProvider);
        final ProfileOverView? profileAboutData =
            profileAboutState is ProfileAboutSuccessState ? profileAboutState.profileOverviewModel.basicOverView : null;

        return Column(
          children: [
            SizedBox(height: KSize.getHeight(context, 10)),
            Row(
              children: [
                Expanded(child: Text('Profile Picture', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.w700, color: KColor.black))),
              ],
            ),
            SizedBox(height: KSize.getHeight(context, 10)),
            Center(
              child: UserProfilePicture(
                avatarRadius: 55,
                profileURL: profileAboutData?.profilePic,
                onTapNavigate: false,
              ),
            ),
            Container(margin: const EdgeInsets.symmetric(vertical: 10), width: MediaQuery.of(context).size.width, height: 0.1, color: KColor.grey),
            Row(
              children: [
                Expanded(child: Text('Cover Photo', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.w700, color: KColor.black))),
              ],
            ),
            SizedBox(height: KSize.getHeight(context, 10)),
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  profileAboutData!.cover!,
                  height: KSize.getHeight(context, 175),
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )),
            Container(margin: const EdgeInsets.symmetric(vertical: 10), width: MediaQuery.of(context).size.width, height: 0.1, color: KColor.grey),
            SizedBox(height: KSize.getHeight(context, 10)),
          ],
        );
      },
    );
  }
}
