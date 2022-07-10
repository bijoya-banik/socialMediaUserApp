import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'Change Password', automaticallyImplyLeading: false, hasLeading: true),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 20)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                KTextField(
                  controller: oldPasswordController,
                  hintText: "Current Password",
                  isPasswordField: true,
                  validator: (v) => Validators.loginPasswordValidator(v),
                ),
                KTextField(
                  controller: newPasswordController,
                  hintText: "New Password",
                  isPasswordField: true,
                  validator: (v) => Validators.newPasswordValidator(v),
                ),
                KTextField(
                  controller: passwordConfirmationController,
                  hintText: "Retype New Password",
                  isPasswordField: true,
                  validator: (v) => Validators.newPasswordValidator(v),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                Consumer(builder: (context, ref, _) {
                  final userState = ref.watch(userProvider);
                  return KButton(
                    title: userState is UserLoadingState ? 'Please wait...' : 'Update Password',
                    color: userState is UserLoadingState ? KColor.grey : KColor.buttonBackground,
                    onPressedCallback: () async {
                      if (newPasswordController.text != passwordConfirmationController.text) {
                        return toast("Confirm Password doesn't match!", bgColor: KColor.red);
                      }
                      if (userState is! UserLoadingState) {
                        if (_formKey.currentState!.validate()) {
                          ref.read(userProvider.notifier).changePassword(
                                oldPasswordController.text,
                                newPasswordController.text,
                                passwordConfirmationController.text,
                              );
                        }
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
