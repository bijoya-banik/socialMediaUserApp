import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class ContactAboutEditScreen extends ConsumerStatefulWidget {
  final ProfileOverView basicProfileData;
  const ContactAboutEditScreen(this.basicProfileData, {Key? key}) : super(key: key);

  @override
  _ContactAboutEditScreenState createState() => _ContactAboutEditScreenState();
}

class _ContactAboutEditScreenState extends ConsumerState<ContactAboutEditScreen> {
  bool isLoading = false;
  TextEditingController aboutController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  @override
  void initState() {
    aboutController.text = widget.basicProfileData.about;
    phoneController.text = widget.basicProfileData.phone;
    websiteController.text = widget.basicProfileData.website;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(
        title: 'Contact and About',
        automaticallyImplyLeading: false,
        customLeading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text('Close', style: KTextStyle.subtitle1.copyWith(color: KColor.closeText)),
          ),
        ),
        trailing: InkWell(
          onTap: isLoading
              ? null
              : () async {
                  setState(() {
                    isLoading = true;
                  });
                  await ref
                      .read(userProvider.notifier)
                      .updateUserData(about: aboutController.text, phone: phoneController.text, website: websiteController.text);
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                },
          child: Text(
            'UPDATE',
            style: KTextStyle.subtitle2.copyWith(color: isLoading ? KColor.grey : KColor.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Website', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
              KTextField(
                  hintText: 'Website', controller: websiteController, textInputType: TextInputType.url, topMargin: KSize.getHeight(context, 10)),
              SizedBox(height: KSize.getHeight(context, 20)),
              Text('Phone Number', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
              KTextField(
                  hintText: 'Phone Number', controller: phoneController, textInputType: TextInputType.phone, topMargin: KSize.getHeight(context, 10)),
              SizedBox(height: KSize.getHeight(context, 20)),
              Text('About', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
              KTextField(
                hintText: 'About you',
                maxLines: null,
                minLines: 7,
                topMargin: KSize.getHeight(context, 10),
                controller: aboutController,
              ),
              SizedBox(height: KSize.getHeight(context, 20)),
            ],
          ),
        ),
      ),
    );
  }
}
