import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/country/country_controller.dart';
import 'package:buddyscripts/controller/country/state/country_state.dart';
import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_dropdown_field.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_field_loading_indicator.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformationSettingsScreen extends StatefulWidget {
  final ProfileOverView? basicProfileData;
  const InformationSettingsScreen(this.basicProfileData, {Key? key}) : super(key: key);

  @override
  _InformationSettingsScreenState createState() => _InformationSettingsScreenState();
}

class _InformationSettingsScreenState extends State<InformationSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController currentCityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController countryIdController = TextEditingController();
  TextEditingController homeTownController = TextEditingController();
  TextEditingController workplaceController = TextEditingController();

  bool isLoading = false;
  List genderList = ["Select Gender", "Female", "Male", "Other"];
  TextEditingController genderController = TextEditingController();
  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.basicProfileData?.firstName ?? '';
    lastNameController.text = widget.basicProfileData?.lastName ?? '';
    birthdayController.text = widget.basicProfileData?.birthDate == null ? '' : DateTimeService.convert(widget.basicProfileData?.birthDate);
    currentCityController.text = widget.basicProfileData?.currentCity ?? '';

    countryController.text = (widget.basicProfileData?.country == null || widget.basicProfileData?.country == "")
        ? "Select Country"
        : widget.basicProfileData?.country ?? '';
    homeTownController.text = widget.basicProfileData?.homeTown ?? '';
    aboutController.text = widget.basicProfileData?.about ?? "";
    websiteController.text = widget.basicProfileData?.website ?? "";
    workplaceController.text = widget.basicProfileData?.workplace ?? "";
    genderController.text =
        widget.basicProfileData?.gender == null || widget.basicProfileData?.gender == "" ? "Select Gender" : widget.basicProfileData?.gender ?? '';

    print("genderController.text");
    print(genderController.text);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(title: 'Information Settings', automaticallyImplyLeading: false, hasLeading: true),
        child: Consumer(builder: (context, ref, _) {
          final profileAboutState = ref.watch(profileAboutProvider);
          final countryState = ref.watch(countryProvider);
          return profileAboutState is ProfileAboutSuccessState
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 20), vertical: KSize.getHeight(context, 15)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('First Name', style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                                  KTextField(
                                    controller: firstNameController,
                                    hintText: "First Name",
                                    topMargin: 5,
                                    validator: (v) => Validators.fieldValidator(v),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: KSize.getWidth(context, 10)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Last Name', style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                                  KTextField(
                                    controller: lastNameController,
                                    hintText: "Last Name",
                                    topMargin: 5,
                                    validator: (v) => Validators.fieldValidator(v),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Birth Date', style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                      KTextField(
                        controller: birthdayController,
                        hintText: "Birth Date",
                        topMargin: 5,
                        isReadOnly: true,
                        suffixIcon: Icon(Icons.date_range, color: KColor.primary),
                        onTap: () async {
                          DateTime picked = await DateTimeService.pickDate(
                            context,
                            lastDate: DateTime.now(),
                            initialDate: birthdayController.text.isNotEmpty ? DateTime.parse(birthdayController.text) : null,
                          );
                          setState(() {
                            birthdayController.text = DateTimeService.convert(picked).toString();
                          });
                        },
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Select gender', style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                      KDropdownField(
                        dropdownFieldOptions: genderList,
                        disabledHint: 'Select gender',
                        controller: genderController,
                        callbackFunction: () {},
                        isObject: false,
                        isCallback: true,
                        validator: (v) => Validators.dropdownFieldValidator(v, 'Select Gender'),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Website Link', style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                      KTextField(
                        hintText: 'Website',
                        controller: websiteController,
                        textInputType: TextInputType.url,
                        topMargin: KSize.getHeight(context, 10),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Home Town', style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                      KTextField(controller: homeTownController, hintText: "Home town", topMargin: 5),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Country', style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                          countryState is CountrySuccessState
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(bottom: KSize.getWidth(context, 5)),
                                  margin: EdgeInsets.only(top: KSize.getHeight(context, 5)),
                                  decoration: BoxDecoration(
                                    color: KColor.white,
                                    boxShadow: [
                                      BoxShadow(color: KColor.white.withOpacity(0.1), blurRadius: 2, spreadRadius: 0, offset: const Offset(0, 1))
                                    ],
                                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  ),
                                  child: KDropdownField(
                                    dropdownFieldOptions: countryState.countryModel,
                                    disabledHint: 'Select country',
                                    initialValue: countryController.text,
                                    controller: countryController,
                                    callbackFunction: () {},
                                    isObject: true,
                                    isCallback: true,
                                    validator: (value) => value.isEmpty ? 'This field is required' : null,
                                  ),
                                )
                              : const KFieldLoadingIndicator(),
                        ],
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('City', style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                      KTextField(controller: currentCityController, hintText: "City", topMargin: 5),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('About', style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                      KTextField(
                        hintText: 'About you',
                        maxLines: null,
                        minLines: 7,
                        topMargin: KSize.getHeight(context, 10),
                        controller: aboutController,
                        inputFormatters: [LengthLimitingTextInputFormatter(300)],
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      KButton(
                        title: isLoading ? 'Please wait...' : 'Save Changes',
                        color: isLoading ? KColor.grey : KColor.buttonBackground,
                        onPressedCallback: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await ref.read(userProvider.notifier).updateUserData(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        birthDate: birthdayController.text,
                                        website: websiteController.text,
                                        country: countryController.text == "Select Country" ? "" : countryController.text,
                                        city: currentCityController.text,
                                        hometown: homeTownController.text,
                                        about: aboutController.text,
                                        gender: genderController.text == "Select Gender" ? "" : genderController.text,
                                        // workplace: workplaceController.text,
                                      );
                                  setState(() {
                                    isLoading = false;
                                  });
                                  // Navigator.pop(context);
                                }
                              },
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                    ]),
                  ),
                )
              : const Center(child: CupertinoActivityIndicator());
        }));
  }
}
