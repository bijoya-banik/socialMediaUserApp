import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({Key? key}) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();
  double processingFee = 0.0;
  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(
        title: 'Add Fund',
        automaticallyImplyLeading: false,
        customLeading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text('Close', style: KTextStyle.subtitle1.copyWith(color: KColor.closeText)),
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                KTextField(
                  hintText: "Enter amount",
                  textInputType: TextInputType.number,
                  controller: amountController,
                  validator: (v) => Validators.fieldValidator(v),
                  callBack: true,
                  callBackFunction: (val) {
                    setState(() {
                      if (val == '') {
                        processingFee = 0.0;
                        totalAmount = 0.0;
                      } else {
                        processingFee = (double.parse(amountController.text) * 0.02) + 2.0;
                        totalAmount = double.parse(amountController.text) + processingFee + 1.8;
                      }
                    });
                  },
                ),
                SizedBox(height: KSize.getHeight(context, 5)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text("Processing Fee: \$${amountController.text == '' ? 0.0 : processingFee.toStringAsFixed(2)}",
                              style: KTextStyle.subtitle2)),
                      Expanded(
                          child: Text("Total Amount: \$${amountController.text == '' ? 0.0 : totalAmount.toStringAsFixed(2)}",
                              style: KTextStyle.subtitle2)),
                    ],
                  ),
                ),
                SizedBox(height: KSize.getHeight(context, 10)),
                KButton(
                  title: "Top up",
                  onPressedCallback: () {
                    if (_formKey.currentState!.validate()) Navigator.pop(context);
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
