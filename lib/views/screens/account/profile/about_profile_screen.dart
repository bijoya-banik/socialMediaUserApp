import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_profile_overview_loading_indicator.dart';
import 'package:buddyscripts/views/screens/account/profile/components/basic_info_component.dart';
import 'package:buddyscripts/views/screens/account/profile/components/contact_about_component.dart';
import 'package:buddyscripts/views/screens/account/profile/components/places_lived_component.dart';
import 'package:buddyscripts/views/screens/account/profile/components/profile_photo_cover_component.dart';
import 'package:buddyscripts/views/screens/account/profile/components/work_education_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class AboutProfileScreen extends StatefulWidget {
  const AboutProfileScreen({Key? key}) : super(key: key);

  @override
  _AboutProfileScreenState createState() => _AboutProfileScreenState();
}

class _AboutProfileScreenState extends State<AboutProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: KColor.appBackground,
        navigationBar: KCupertinoNavBar(title: 'About', automaticallyImplyLeading: false, hasLeading: true),
        child: Consumer(
          builder: (context, ref, _) {
            final profileAboutState = ref.watch(profileAboutProvider);
            final ProfileOverView? profileAboutData =
                profileAboutState is ProfileAboutSuccessState ? profileAboutState.profileOverviewModel.basicOverView : null;

            return profileAboutState is ProfileAboutSuccessState
                ? CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      CupertinoSliverRefreshControl(
                          onRefresh: () => ref.read(profileAboutProvider.notifier).fetchProfileAbout(profileAboutData!.username!)),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ProfilePhotoCoverComponent(),
                            BasicInfoComponent(profileAboutData!),
                            const ContactAboutComponent(),
                            const WorkEducationComponent(),
                            const Divider(),
                            SizedBox(height: KSize.getHeight(context, 10)),
                            PlacesLivedComponent(profileAboutData),
                          ],
                        ),
                      )),
                    ],
                  )
                : const KProfileOverviewLoadingIndicator();
          },
        ));
  }
}
