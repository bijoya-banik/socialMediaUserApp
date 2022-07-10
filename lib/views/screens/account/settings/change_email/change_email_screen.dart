import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeEmailScreen extends StatefulWidget {
  final String email;

  const ChangeEmailScreen(this.email, {Key? key}) : super(key: key);

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'Change Email', automaticallyImplyLeading: false, hasLeading: true),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 20)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                KTextField(
                  controller: emailController,
                  hintText: "New Email",
                  textInputType: TextInputType.emailAddress,
                  validator: (v) => Validators.emailValidator(v),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                Consumer(builder: (context, ref, _) {
                  final userState = ref.watch(userProvider);
                  return KButton(
                    title: userState is UserLoadingState ? 'Please wait...' : 'Save Changes',
                    color: userState is UserLoadingState ? KColor.grey : KColor.buttonBackground,
                    onPressedCallback: () async {
                      if (userState is! UserLoadingState) {
                        if (_formKey.currentState!.validate()) {
                          if (emailController.text.trim() == widget.email) {
                            await Future.delayed(const Duration(milliseconds: 150));
                            Navigator.of(context).pop();
                          } else {
                            ref.read(userProvider.notifier).changeEmail(emailController.text);
                          }
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
