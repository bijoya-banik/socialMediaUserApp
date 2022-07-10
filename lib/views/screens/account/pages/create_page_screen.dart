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
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePageScreen extends StatefulWidget {
  final bool isEdit;
  const CreatePageScreen({Key? key, this.isEdit = false}) : super(key: key);

  @override
  _CreatePageScreenState createState() => _CreatePageScreenState();
}

class _CreatePageScreenState extends State<CreatePageScreen> {
  TextEditingController pageNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, WidgetRef ref, _) {
      final pageCategoryState = ref.watch(pageCategoryProvider);
      final pageState = ref.watch(pageProvider);

      ref.listen(pageProvider, (_, state) {
        if (state is PageCategorySuccessState) {
          categoryController.text = state.pageCategoryModel.first.name ?? "";
        }
      });

      return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: 'Create Page',
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
              if (pageState is! PageLoadingState) {
                if (_formKey.currentState!.validate()) {
                  ref.read(pageProvider.notifier).createPage(
                      pageName: pageNameController.text,
                      email: emailController.text,
                      website: websiteController.text,
                      phone: phoneController.text,
                      description: descriptionController.text,
                      categoryName: categoryController.text);
                }
              }
            },
            child: Text(
              pageState is PageLoadingState ? 'Please wait...' : 'CREATE',
              style: KTextStyle.subtitle2.copyWith(color: pageState is PageLoadingState ? KColor.black54 : KColor.black, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Page Name', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                  KTextField(
                    hintText: 'Page Name',
                    controller: pageNameController,
                    topMargin: KSize.getHeight(context, 10),
                    validator: (v) => Validators.fieldValidator(v),
                  ),
                  SizedBox(height: KSize.getHeight(context, 20)),
                  Text('Category', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                  SizedBox(height: KSize.getHeight(context, 10)),
                  pageCategoryState is PageCategorySuccessState
                      ? KDropdownField(
                          dropdownFieldOptions: pageCategoryState.pageCategoryModel,
                          disabledHint: 'Select category',
                          selectedIdController: categoryIdController,
                          controller: categoryController,
                          callbackFunction: () {},
                          isObject: true,
                          isCallback: true,
                          validator: (value) => value.isEmpty ? 'This field is required' : null,
                        )
                      : const KFieldLoadingIndicator(),
                  SizedBox(height: KSize.getHeight(context, 20)),
                  Text(
                    'Email',
                    style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, color: KColor.black),
                  ),
                  KTextField(
                    hintText: 'Email (Optional)',
                    topMargin: KSize.getHeight(context, 10),
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    validator: (v) {
                      return Validators.fieldValidator("optional");
                    },
                  ),
                  SizedBox(height: KSize.getHeight(context, 20)),
                  Text(
                    'Phone',
                    style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold),
                  ),
                  KTextField(
                    hintText: 'Phone (Optional)',
                    topMargin: KSize.getHeight(context, 10),
                    controller: phoneController,
                    textInputType: TextInputType.number,
                    validator: (v) => Validators.fieldValidator("optional"),
                  ),
                  SizedBox(height: KSize.getHeight(context, 20)),
                  Text(
                    'Website',
                    style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold),
                  ),
                  KTextField(
                    hintText: 'Website (Optional)',
                    topMargin: KSize.getHeight(context, 10),
                    controller: websiteController,
                    validator: (v) => Validators.fieldValidator("optional"),
                  ),
                  SizedBox(height: KSize.getHeight(context, 20)),
                  Text(
                    'About Page',
                    style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold),
                  ),
                  KTextField(
                    hintText: 'About Page',
                    maxLines: 10,
                    minLines: 7,
                    topMargin: KSize.getHeight(context, 10),
                    controller: descriptionController,
                    validator: (v) => Validators.fieldValidator(v),
                    inputFormatters: [LengthLimitingTextInputFormatter(300)],
                  ),
                  SizedBox(height: KSize.getHeight(context, 20)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
