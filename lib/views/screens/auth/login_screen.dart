import 'dart:io';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/services/notification_service.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/screens/auth/register_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<bool> _onWillPop() async {
    return await showPlatformDialog(
      context: context,
      builder: (_) => ConfirmationDialogContent(titleContent: 'Are you sure you want to exit this app?', onPressedCallback: () => exit(0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onWillPop();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: KColor.darkAppBackground,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 20)),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: KSize.getHeight(context, 75)),
                    Image.asset(
                      AssetPath.fullLogo,
                      fit: BoxFit.cover,
                      height: KSize.getHeight(context, 65),
                    ),
                    SizedBox(height: KSize.getHeight(context, 10)),
                    Text(
                      'BuddyScript is a modern social network script that allows you to build your own niche social networking platform.',
                      textAlign: TextAlign.center,
                      style: KTextStyle.bodyText3.copyWith(color: KColor.black),
                    ),
                    SizedBox(height: KSize.getHeight(context, 25)),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "Log in",
                        style: KTextStyle.headline5.copyWith(color: KColor.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Login with your account email and password",
                        style: KTextStyle.subtitle2.copyWith(color: KColor.black54),
                      ),
                      KTextField(
                        controller: emailController,
                        hintText: "Email",
                        labelText: 'Email',
                        textInputType: TextInputType.emailAddress,
                        validator: (v) {
                          return Validators.emailValidator(v);
                        },
                      ),
                      KTextField(
                        controller: passwordController,
                        hintText: "Password",
                        labelText: "Password",
                        isPasswordField: true,
                        validator: (v) => Validators.loginPasswordValidator(v),
                      ),
                    ]),
                    SizedBox(height:40),
                    Consumer(builder: (context, ref, _) {
                      final userState = ref.watch(userProvider);

                      return Visibility(
                        visible: userState is UserUnverifiedState,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Please verify your account first.", style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                            TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();
                                        if (!mounted) return;
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await ref.read(userProvider.notifier).sendResetToken(emailController.text, routeFromLogin: true);

                                        if (!mounted) return;
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                style: TextButton.styleFrom(
                                    primary: KColor.primary, textStyle: KTextStyle.subtitle2.copyWith(fontWeight: FontWeight.w700)),
                                child: Text(isLoading ? "Please wait..." : "Verify account")),
                          ],
                        ),
                      );
                    }),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     TextButton(
                    //         onPressed: () {
                    //           Navigator.push(context, CupertinoPageRoute(builder: (context) => const ForgotPasswordScreen()));
                    //         },
                    //         style: TextButton.styleFrom(
                    //           primary: KColor.buttonBackground,
                    //           textStyle: KTextStyle.subtitle2.copyWith(color: KColor.buttonBackground),
                    //         ),
                    //         child: Text("Forgot Password?", style: KTextStyle.subtitle2.copyWith(color: KColor.primary), textAlign: TextAlign.end)),
                    //   ],
                    // ),
                    Consumer(builder: (context, ref, _) {
                      final userState = ref.watch(userProvider);
                      return KButton(
                        title: userState is UserLoadingState ? 'Please wait...' : 'SIGN IN',
                        color: userState is UserLoadingState ? KColor.grey : KColor.buttonBackground,
                        onPressedCallback: () async {
                          if (userState is! UserLoadingState) {
                            if (_formKey.currentState!.validate()) {
                              ref.read(userProvider.notifier).login(
                                    emailController.text,
                                    passwordController.text,
                                    await NotificationService.getToken(),
                                  );
                            }
                          }
                        },
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?", style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, CupertinoPageRoute(builder: (context) => const RegisterScreen()));
                            },
                            style: TextButton.styleFrom(
                                primary: KColor.buttonBackground,
                                textStyle: KTextStyle.subtitle2.copyWith(fontWeight: FontWeight.w700, color: KColor.buttonBackground)),
                            child: const Text("Sign Up")),
                      ],
                    ),
                    SizedBox(height: KSize.getHeight(context, 20)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
