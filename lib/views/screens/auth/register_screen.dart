import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_dropdown_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/screens/auth/login_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController fbController = TextEditingController();

  List genderList = ["Select Gender", "Female", "Male", "Other"];

  // bool _isAgreed = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    genderController.text = 'Select Gender';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(
          backgroundColor: KColor.darkAppBackground,
          arrowIconColor: KColor.black87,
          hasBorder: false,
          automaticallyImplyLeading: false),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 20)),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  Row(
                    children: [
                      Expanded(
                        child: KTextField(
                          controller: firstNameController,
                          hintText: "First Name",
                          labelText: "First Name",
                          widthFactor: 0.5,
                          validator: (v) {
                            return Validators.fieldValidator(v);
                          },
                        ),
                      ),
                      SizedBox(width: KSize.getWidth(context, 20)),
                      Expanded(
                        child: KTextField(
                          controller: lastNameController,
                          hintText: "Last Name",
                          labelText: "Last Name",
                          widthFactor: 0.5,
                          validator: (v) {
                            return Validators.fieldValidator(v);
                          },
                        ),
                      ),
                    ],
                  ),
                  KTextField(
                    controller: emailController,
                    hintText: "Email",
                    labelText: "Email",
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
                    validator: (v) => Validators.newPasswordValidator(v),
                  ),
                  KTextField(
                    controller: passwordConfirmationController,
                    hintText: "Confirm Password",
                    labelText: "Confirm Password",
                    isPasswordField: true,
                    validator: (v) => Validators.newPasswordValidator(v),
                  ),
                  SizedBox(height: KSize.getHeight(context, 8)),
                  KDropdownField(
                    dropdownFieldOptions: genderList,
                    disabledHint: 'Select gender',
                    controller: genderController,
                    callbackFunction: () {},
                    isObject: false,
                    isCallback: true,
                    validator: (v) => Validators.dropdownFieldValidator(
                        "optional", 'Select Gender'), // Optional value
                  ),
                  SizedBox(height: KSize.getHeight(context, 10)),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       _isAgreed = !_isAgreed;
                  //     });
                  //   },
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Theme(
                  //           data: ThemeData(
                  //             unselectedWidgetColor: KColor.grey,
                  //             checkboxTheme: CheckboxThemeData(
                  //               fillColor: MaterialStateColor.resolveWith(
                  //                 (states) {
                  //                   if (states.contains(MaterialState.selected)) return KColor.primary; // the color when checkbox is selected;
                  //                   return KColor.grey; //the color when checkbox is unselected;
                  //                 },
                  //               ),
                  //             ),
                  //           ),
                  //           child: Checkbox(
                  //               value: _isAgreed,
                  //               onChanged: (val) {
                  //                 setState(() {
                  //                   _isAgreed = !_isAgreed;
                  //                 });
                  //               }),
                  //         ),
                  //         RichText(
                  //           text: TextSpan(
                  //             children: [
                  //               TextSpan(
                  //                 text: 'You agree to ',
                  //                 style: KTextStyle.bodyText3.copyWith(color: KColor.black87),
                  //               ),
                  //               TextSpan(
                  //                 text: 'Our Terms & Conditions.',
                  //                 style: KTextStyle.bodyText3.copyWith(color: KColor.primary, fontWeight: FontWeight.w600),
                  //                 recognizer: TapGestureRecognizer()
                  //                   ..onTap = () {
                  //                     launch("https://free.appifylab.com/terms");
                  //                   },
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         SizedBox(width: KSize.getWidth(context, 15)),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: KSize.getHeight(context, 20)),
                  Consumer(
                    builder: (context, ref, _) {
                      final userState = ref.watch(userProvider);
                      return KButton(
                          title: userState is UserLoadingState
                              ? 'Please wait...'
                              : 'SIGN UP',
                          color: userState is UserLoadingState
                              ? KColor.grey
                              : KColor.buttonBackground,
                          onPressedCallback: () {
                            if (genderController.text == "Select Gender" || genderController.text == "") {
                              toast("Select Gender", bgColor: KColor.red);
                            }
                            // if (!_isAgreed) {
                            //   toast("Please accept our Terms & Privacy Policy!", bgColor: KColor.red);
                            // } else
                            if (passwordController.text ==
                                passwordConfirmationController.text) {
                              if (userState is! UserLoadingState) {
                                if (_formKey.currentState!.validate()) {
                                  print(
                                      '_formKey.currentState!.validate() = ${_formKey.currentState!.validate()}');
                                  ref.read(userProvider.notifier).register(
                                      agree: true,
                                      email: emailController.text,
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      birthdate: birthDateController.text,
                                      gender: genderController.text,
                                      password: passwordController.text,
                                      fbHandle: fbController.text);
                                }
                              }
                            } else {
                              toast("Passwords don't match!",
                                  bgColor: KColor.red);
                            }
                          });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?",
                          style: KTextStyle.subtitle2
                              .copyWith(color: KColor.black)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          style: TextButton.styleFrom(
                              primary: KColor.buttonBackground,
                              textStyle: KTextStyle.subtitle2.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: KColor.buttonBackground)),
                          child: Text("Sign In",
                              style: KTextStyle.subtitle2
                                  .copyWith(color: KColor.primary))),
                    ],
                  ),
                  SizedBox(height: KSize.getHeight(context, 35)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
