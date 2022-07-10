import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/views/screens/account/components/profile_info_tile.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesLivedComponent extends StatefulWidget {
  final ProfileOverView basicProfileData;
  const PlacesLivedComponent(this.basicProfileData, {Key? key}) : super(key: key);

  @override
  _PlacesLivedComponentState createState() => _PlacesLivedComponentState();
}

class _PlacesLivedComponentState extends State<PlacesLivedComponent> {
  TextEditingController currentCityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController homeTownController = TextEditingController();
  String isEditable = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentCityController.text = widget.basicProfileData.currentCity ?? '';
    countryController.text = widget.basicProfileData.country ?? '';
    homeTownController.text = widget.basicProfileData.homeTown ?? '';
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
            Text('Places Lived', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.w700, color: KColor.black)),
            SizedBox(height: KSize.getHeight(context, 10)),
            ProfileInfoTile(
              icon: Icon(Icons.location_pin, color: KColor.black54),
              value: profileAboutData?.currentCity == null
                  ? '--'
                  : (profileAboutData!.currentCity.toString() + ', ') +
                      (profileAboutData.country == null ? '--' : profileAboutData.country.toString()),
              title: 'Current City',
            ),
            SizedBox(height: KSize.getHeight(context, 5)),
            ProfileInfoTile(
              icon: Icon(Icons.home, color: KColor.black54),
              value: profileAboutData?.homeTown == null ? '--' : profileAboutData?.homeTown.toString(),
              title: 'Home Town',
            ),
            SizedBox(height: KSize.getHeight(context, 5)),
            const Divider(),
          ],
        );
      },
    );
  }
}
