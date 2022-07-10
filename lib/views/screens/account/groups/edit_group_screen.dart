import 'package:buddyscripts/controller/country/country_controller.dart';
import 'package:buddyscripts/controller/country/state/country_state.dart';
import 'package:buddyscripts/controller/group/group_controller.dart';
import 'package:buddyscripts/controller/group/state/group_state.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_field_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_dropdown_field.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/screens/home/components/privacy_options_modal.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditGroupScreen extends StatefulWidget {
  final dynamic groupData;

  const EditGroupScreen(this.groupData, {Key? key}) : super(key: key);

  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  //TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String privacy = 'Public';

  @override
  void initState() {
    groupNameController.text = widget.groupData.groupName;
    groupDescriptionController.text = widget.groupData.about;
    // countryController.text = widget.groupData.country == null ? "" : widget.groupData.country;
    cityController.text = widget.groupData.city ?? "";
    //  addressController.text = widget.groupData.address == null ? "" : widget.groupData.address;
    privacy = widget.groupData.groupPrivacy == "PUBLIC" ? "Public" : "Private";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, WidgetRef ref, _) {
      // final groupCategoryState = watch(groupCategoryProvider.state);
      final groupState = ref.watch(groupProvider);
      final countryState = ref.watch(countryProvider);

      ref.listen(countryProvider, (_, state) {
        if (state is CountrySuccessState) {
          countryController.text = widget.groupData.country;
        }
      });

      return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: 'Edit Group',
          automaticallyImplyLeading: false,
          customLeading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text('Close', style: KTextStyle.subtitle1.copyWith(color: KColor.closeText)),
            ),
          ),
          trailing: InkWell(
            onTap: () {
              if (groupState is! GroupLoadingState) {
                if (_formKey.currentState!.validate()) {
                  ref.read(groupProvider.notifier).editGroup(
                        groupData: widget.groupData,
                        groupName: groupNameController.text,
                        about: groupDescriptionController.text,
                        privacy: privacy,
                        categoryName: categoryController.text,
                        city: cityController.text,
                        country: countryController.text == "Select Country" ? "" : countryController.text,
                        //  address: addressController.text,
                      );
                }
              }
            },
            child: Text(
              groupState is GroupLoadingState ? 'Please wait...' : 'UPDATE',
              style: KTextStyle.subtitle2
                  .copyWith(color: groupState is GroupLoadingState ? KColor.white54Const : KColor.whiteConst, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      KTextField(
                        hintText: 'Name your group',
                        controller: groupNameController,
                        topMargin: KSize.getHeight(context, 10),
                        validator: (v) => Validators.fieldValidator(v),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Description', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      KTextField(
                        hintText: 'About your group',
                        maxLines: null,
                        minLines: 7,
                        topMargin: KSize.getHeight(context, 10),
                        controller: groupDescriptionController,
                        validator: (v) => Validators.fieldValidator(v),
                      ),
                    ],
                  ),
                ),

                // SizedBox(height: KSize.getHeight(context, 20)),
                // Text('Category', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
                // SizedBox(height: KSize.getHeight(context, 10)),
                // groupCategoryState is GroupCategorySuccessState
                //     ? Container(
                //         width: MediaQuery.of(context).size.width,
                //         padding: EdgeInsets.only(bottom: KSize.getWidth(context, 5)),
                //         margin: EdgeInsets.only(top: KSize.getHeight(context, 5)),
                //         decoration: BoxDecoration(
                //           color: KColor.white,
                //           boxShadow: [BoxShadow(color: KColor.white.withOpacity(0.1), blurRadius: 2, spreadRadius: 0, offset: Offset(0, 1))],
                //           borderRadius: BorderRadius.all(Radius.circular(6)),
                //         ),
                //         child: KDropdownField(
                //           dropdownFieldOptions: groupCategoryState is GroupCategorySuccessState ? groupCategoryState.groupCategoryModel : [],
                //           disabledHint: 'Select category',
                //           selectedIdController: categoryIdController,
                //           controller: categoryController,
                //           callbackFunction: () {},
                //           isObject: true,
                //           isCallback: true,
                //           validator: (value) => value.isEmpty ? 'This field is required' : null,
                //         ),
                //       )
                //     : KFieldLoadingIndicator(),
                SizedBox(height: KSize.getHeight(context, 20)),
                // Text('Country', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
                // KTextField(
                //   hintText: 'Your country name',
                //   controller: countryController,
                //   topMargin: KSize.getHeight(context, 10),
                // ),
                countryState is CountrySuccessState
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(bottom: KSize.getWidth(context, 5)),
                        margin: EdgeInsets.only(top: KSize.getHeight(context, 5)),
                        decoration: BoxDecoration(
                          color: KColor.white,
                          boxShadow: [BoxShadow(color: KColor.white.withOpacity(0.1), blurRadius: 2, spreadRadius: 0, offset: const Offset(0, 1))],
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                        ),
                        child: KDropdownField(
                          dropdownFieldOptions: countryState.countryModel,
                          disabledHint: 'Select country',
                          initialValue: widget.groupData.country == "" ? countryState.countryModel.first.name : widget.groupData.country,
                          controller: countryController,
                          callbackFunction: () {},
                          isObject: true,
                          isCallback: true,
                          validator: (value) => value.isEmpty ? 'This field is required' : null,
                        ),
                      )
                    : const KFieldLoadingIndicator(),
                SizedBox(height: KSize.getHeight(context, 20)),
                Text('City', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                KTextField(
                  hintText: 'City name',
                  controller: cityController,
                  topMargin: KSize.getHeight(context, 10),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                Text('Privacy', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                SizedBox(height: KSize.getHeight(context, 10)),
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  color: KColor.textBackground,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          elevation: 5,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          backgroundColor: KColor.textBackground,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                          ),
                          builder: (context) {
                            return PrivacyOptionsModal(
                              options: const [
                                PrivacyOptions('Public', Icons.public),
                                PrivacyOptions('Private', Icons.lock),
                              ],
                              callBackFunction: (val) {
                                setState(() {
                                  privacy = val;
                                });
                              },
                              isSelected: privacy,
                            );
                          });
                    },
                    child: Ink(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                      child: Row(
                        children: [
                          Icon(Icons.public, color: KColor.black54),
                          SizedBox(width: KSize.getWidth(context, 10)),
                          Expanded(
                            child: Text(privacy, style: KTextStyle.bodyText3.copyWith(color: KColor.black87)),
                          ),
                          Icon(Icons.keyboard_arrow_down, color: KColor.black87)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
