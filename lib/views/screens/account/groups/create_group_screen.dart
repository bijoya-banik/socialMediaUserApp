import 'package:buddyscripts/controller/group/group_controller.dart';
import 'package:buddyscripts/controller/group/state/group_state.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/screens/home/components/privacy_options_modal.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String privacy = 'Public';

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //  final groupCategoryState = watch(groupCategoryProvider.state);
      final groupState = ref.watch(groupProvider);

      ref.listen(groupProvider, (_, state) {
        // if (state is GroupCategorySuccessState) categoryController.text = state.groupCategoryModel.first.name;
      });
      return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: 'Create Group',
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
                  ref.read(groupProvider.notifier).createGroup(
                      groupName: groupNameController.text,
                      about: groupDescriptionController.text,
                      privacy: privacy,
                      categoryName: categoryController.text);
                }
              }
            },
            child: Text(
              groupState is GroupLoadingState ? 'Please wait...' : 'CREATE',
              style:
                  KTextStyle.subtitle2.copyWith(color: groupState is GroupLoadingState ? KColor.black54 : KColor.black, fontWeight: FontWeight.w700),
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
                  Text('Group Name', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                  KTextField(
                    hintText: 'Enter name',
                    controller: groupNameController,
                    topMargin: KSize.getHeight(context, 10),
                    validator: (v) => Validators.fieldValidator(v),
                  ),
                  SizedBox(height: KSize.getHeight(context, 20)),
                  Text('About Group', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                  KTextField(
                    hintText: 'Enter details',
                    maxLines: null,
                    minLines: 7,
                    topMargin: KSize.getHeight(context, 10),
                    controller: groupDescriptionController,
                    validator: (v) => Validators.fieldValidator(v),
                  ),
                  SizedBox(height: KSize.getHeight(context, 20)),
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
        ),
      );
    });
  }
}
