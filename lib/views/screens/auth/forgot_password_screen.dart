import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(
        backgroundColor: KColor.darkAppBackground,
        arrowIconColor: KColor.black87,
        hasBorder: false,
        automaticallyImplyLeading: false,
        hasLeading: true,
      ),
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
                SizedBox(height: KSize.getHeight(context, 25)),
                Text("Forgot Password?", style: KTextStyle.headline5.copyWith(color: KColor.black)),
                SizedBox(height: KSize.getHeight(context, 10)),
                Text(
                  "Enter the email associated with your account.A code will be sent to this email to reset password.",
                  style: KTextStyle.caption.copyWith(color: KColor.black54, fontSize: 14.7),
                ),
                KTextField(
                  controller: emailController,
                  hintText: "Enter your email",
                  contentPaddingVerticle: 16,
                  textInputType: TextInputType.emailAddress,
                  validator: (v) => Validators.emailValidator(v),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                Consumer(
                  builder: (context, ref, _) {
                    final userState = ref.watch(userProvider);
                    return KButton(
                        title: userState is UserLoadingState ? 'Please wait...' : 'Proceed',
                        color: userState is UserLoadingState ? KColor.grey : KColor.buttonBackground,
                        onPressedCallback: () {
                          if (userState is! UserLoadingState) {
                            if (_formKey.currentState!.validate()) {
                              ref.read(userProvider.notifier).sendPasswordResetMail(emailController.text);
                            }
                          }
                        });
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
