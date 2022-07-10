import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/views/screens/account/components/profile_info_tile.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactAboutComponent extends ConsumerWidget {
  const ContactAboutComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAboutState = ref.watch(profileAboutProvider);

    final ProfileOverView? profileAboutData =
        profileAboutState is ProfileAboutSuccessState ? profileAboutState.profileOverviewModel.basicOverView : null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text('Contact and About', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.w700, color: KColor.black))),
          ],
        ),
        SizedBox(height: KSize.getHeight(context, 10)),
        InkWell(
          onTap: () {
            if (profileAboutData?.website != null || profileAboutData?.website != "") {
              launch(profileAboutData!.website);
            }
          },
          child: ProfileInfoTile(
            icon: Icon(MaterialCommunityIcons.web, color: KColor.black54),
            value: profileAboutData?.website == null ? '--' : profileAboutData!.website.toString(),
            title: 'Website',
          ),
        ),
        SizedBox(height: KSize.getHeight(context, 5)),
        ProfileInfoTile(
          icon: Icon(MaterialIcons.info, color: KColor.black54),
          value: profileAboutData?.about == null ? '--' : profileAboutData!.about.toString(),
          title: 'About',
        ),
        Container(margin: const EdgeInsets.symmetric(vertical: 10), width: MediaQuery.of(context).size.width, height: 0.1, color: KColor.grey),
        SizedBox(height: KSize.getHeight(context, 10)),
      ],
    );
  }
}
