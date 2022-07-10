import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? email;
  const ResetPasswordScreen({Key? key, this.email}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(
          backgroundColor: KColor.appBackground,
          arrowIconColor: KColor.black87,
          hasBorder: false,
          automaticallyImplyLeading: false,
          hasLeading: true),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 20)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: KSize.getHeight(context, 25)),
                Center(
                  child: Image.asset(
                    AssetPath.fullLogo,
                    fit: BoxFit.cover,
                    height: KSize.getHeight(context, 65),
                  ),
                ),
                SizedBox(height: KSize.getHeight(context, 45)),
                Text("Reset password", style: KTextStyle.headline5.copyWith(color: KColor.black87)),
                SizedBox(height: KSize.getHeight(context, 10)),
                Text(
                  "Set the new password for your account so you can login and access all features",
                  textAlign: TextAlign.start,
                  style: KTextStyle.subtitle2.copyWith(color: KColor.black54),
                ),
                SizedBox(height: KSize.getHeight(context, 10)),
                KTextField(
                  controller: passwordController,
                  hintText: "New Password *",
                  isPasswordField: true,
                  validator: (v) => Validators.loginPasswordValidator(v),
                ),
                KTextField(
                  controller: passwordConfirmationController,
                  hintText: "Confirm New Password *",
                  isPasswordField: true,
                  validator: (v) => Validators.loginPasswordValidator(v),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                Consumer(
                  builder: (context, ref, _) {
                    final userState = ref.watch(userProvider);
                    return KButton(
                      title: userState is UserLoadingState ? 'Please wait...' : 'Reset Password',
                      color: userState is UserLoadingState ? KColor.grey : KColor.buttonBackground,
                      onPressedCallback: () {
                        if (passwordController.text == passwordConfirmationController.text) {
                          if (_formKey.currentState!.validate()) {
                            ref.read(userProvider.notifier).resetPassword(widget.email, passwordController.text, codeController.text);
                          }
                        } else {
                          toast("Confirm Password doesn't match!", bgColor: KColor.red);
                        }
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
