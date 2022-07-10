import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum VerificationType { PASSWORD, REGISTRATION }

class VerifyAccountScreen extends ConsumerStatefulWidget {
  final String? email;
  final dynamic verificationType;
  const VerifyAccountScreen({Key? key, this.email, this.verificationType}) : super(key: key);

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends ConsumerState<VerifyAccountScreen> {
  TextEditingController codeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(
          backgroundColor: KColor.darkAppBackground,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    AssetPath.fullLogo,
                    fit: BoxFit.cover,
                    height: KSize.getHeight(context, 65),
                  ),
                ),
                SizedBox(height: KSize.getHeight(context, 45)),
                Text("Verify Email", style: KTextStyle.headline5.copyWith(color: KColor.black)),
                SizedBox(height: KSize.getHeight(context, 10)),
                Text(
                  "We have send a code to ${widget.email}. Enter the code that you have received on your mail",
                  textAlign: TextAlign.start,
                  style: KTextStyle.subtitle2.copyWith(color: KColor.black54),
                ),
                KTextField(
                  contentPaddingVerticle: 15,
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
                            if (widget.verificationType == VerificationType.PASSWORD) {
                              ref.read(userProvider.notifier).verifyCode(codeController.text, widget.email!);
                            } else {
                              ref.read(userProvider.notifier).verifyRegistration(codeController.text, widget.email!);
                            }
                          }
                        }
                      });
                }),

                /*
                  * Resend code snippet
                */
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isSending
                        ? null
                        : () async {
                            setState(() {
                              _isSending = true;
                            });

                            await ref.read(userProvider.notifier).sendResetToken(widget.email!, routeFromLogin: false);

                            if (!mounted) return;
                            setState(() {
                              _isSending = false;
                            });
                          },
                    style: TextButton.styleFrom(
                      primary: KColor.primary,
                      textStyle: KTextStyle.subtitle2.copyWith(color: KColor.primary),
                    ),
                    child: Text(
                      _isSending ? 'Resending...' : 'Resend Code',
                      style: KTextStyle.bodyText2
                          .copyWith(decoration: TextDecoration.underline, color: KColor.primary, decorationColor: KColor.primary.withOpacity(0.35)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
