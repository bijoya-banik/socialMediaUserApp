import 'package:buddyscripts/controller/country/state/country_state.dart';
import 'package:buddyscripts/controller/page/page_category_controller.dart';
import 'package:buddyscripts/controller/page/page_controller.dart';
import 'package:buddyscripts/controller/page/state/page_category_state.dart';
import 'package:buddyscripts/controller/page/state/page_state.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_dropdown_field.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_field_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPageScreen extends StatefulWidget {
  final dynamic pageData;
  const EditPageScreen(this.pageData, {Key? key}) : super(key: key);

  @override
  _EditPageScreenState createState() => _EditPageScreenState();
}

class _EditPageScreenState extends State<EditPageScreen> {
  TextEditingController pageNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
//  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    pageNameController.text = widget.pageData.pageName;
    descriptionController.text = widget.pageData.about;
    // shortDescriptionController.text = widget.pageData.pageTitle;
    websiteController.text = widget.pageData.website ?? "";
    phoneController.text = widget.pageData.phone ?? "";
    emailController.text = widget.pageData.email ?? "";
    countryController.text = widget.pageData.country ?? "";
    cityController.text = widget.pageData.city ?? "";
    addressController.text = widget.pageData.address ?? "";
    categoryController.text = widget.pageData.categoryName ?? "Select Category";
    print("widget.pageData.categoryName");
    print(widget.pageData.categoryName);
    print(categoryController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, WidgetRef ref, _) {
      final pageCategoryState = ref.watch(pageCategoryProvider);
      final pageCreateState = ref.watch(pageProvider);

      ref.listen(pageProvider, (_, state) {
        if (state is PageCategorySuccessState) {
          categoryController.text = widget.pageData.categoryName;
        }
        if (state is CountrySuccessState) {
          countryController.text = widget.pageData.country;
        }
      });

      return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: 'Edit Page',
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
              if (pageCreateState is! PageLoadingState) {
                if (_formKey.currentState!.validate()) {
                  ref.read(pageProvider.notifier).editPage(
                      pageData: widget.pageData,
                      pageName: pageNameController.text,
                      categoryName: categoryController.text,
                      about: descriptionController.text,
                      // shortDescription: shortDescriptionController.text,
                      website: websiteController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                      // country: countryController.text,
                      // city: cityController.text,
                      address: addressController.text);
                }
              }
            },
            child: Text(
              pageCreateState is PageLoadingState ? 'Please wait...' : 'UPDATE',
              style: KTextStyle.subtitle2
                  .copyWith(color: pageCreateState is PageLoadingState ? KColor.black54 : KColor.black, fontWeight: FontWeight.w700),
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
                        hintText: 'Name your page',
                        controller: pageNameController,
                        topMargin: KSize.getHeight(context, 10),
                        validator: (v) => Validators.fieldValidator(v),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Category', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      SizedBox(height: KSize.getHeight(context, 10)),
                      pageCategoryState is PageCategorySuccessState
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
                                dropdownFieldOptions: pageCategoryState.pageCategoryModel,
                                disabledHint: 'Select category',
                                selectedIdController: categoryIdController,
                                controller: categoryController,
                                callbackFunction: () {},
                                isObject: true,
                                isCallback: true,
                                initialValue: categoryController.text,
                                validator: (value) => value.isEmpty ? 'This field is required' : null,
                              ))
                          : const KFieldLoadingIndicator(),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Email', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      KTextField(
                        hintText: 'Email address',
                        controller: emailController,
                        topMargin: KSize.getHeight(context, 10),
                        validator: (v) => Validators.fieldValidator("optional"),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text(
                        'Phone',
                        style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold),
                      ),
                      KTextField(
                        hintText: 'Phone number',
                        topMargin: KSize.getHeight(context, 10),
                        controller: phoneController,
                        validator: (v) => Validators.fieldValidator("optional"),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Website', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      KTextField(
                        hintText: 'Your website name',
                        controller: websiteController,
                        topMargin: KSize.getHeight(context, 10),
                        validator: (v) => Validators.fieldValidator("optional"),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text(
                        'About page',
                        style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold),
                      ),
                      KTextField(
                        hintText: 'About page',
                        maxLines: null,
                        minLines: 7,
                        topMargin: KSize.getHeight(context, 10),
                        controller: descriptionController,
                        validator: (v) => Validators.fieldValidator(v),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                Text('Address', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                KTextField(
                  hintText: 'Your address name',
                  controller: addressController,
                  topMargin: KSize.getHeight(context, 10),
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
