import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  TextEditingController codeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'Verify Email', automaticallyImplyLeading: false, hasLeading: true),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 20)),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: KSize.getHeight(context, 25)),
                Text("Verify code", style: KTextStyle.headline5),
                SizedBox(height: KSize.getHeight(context, 10)),
                Text(
                  "We’ve sent a 6-character verification code to your email, please enter it",
                  textAlign: TextAlign.start,
                  style: KTextStyle.caption.copyWith(color: KColor.black87),
                ),
                KTextField(
                  controller: codeController,
                  hintText: "Code *",
                  textInputType: const TextInputType.numberWithOptions(),
                  validator: (v) => Validators.fieldValidator(v),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                Consumer(builder: (context, ref, _) {
                  final userState = ref.watch(userProvider);

                  return KButton(
                      title: userState is UserLoadingState ? 'Please wait' : 'Verify',
                      color: userState is UserLoadingState ? KColor.grey : KColor.buttonBackground,
                      onPressedCallback: () {
                        if (userState is! UserLoadingState) {
                          if (_formKey.currentState!.validate()) {
                            ref.read(userProvider.notifier).verifyUpdateEmail(codeController.text, widget.email);
                          }
                        }
                      });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
