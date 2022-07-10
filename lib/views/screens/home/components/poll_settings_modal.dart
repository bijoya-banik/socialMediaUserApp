import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class PollSettingsModal extends StatefulWidget {
  final Function? callBackFunction;
  final bool isAllowMultipleChoice, isAllowMemberAddOptions;

  const PollSettingsModal({Key? key, this.callBackFunction, this.isAllowMemberAddOptions = false, this.isAllowMultipleChoice = false})
      : super(key: key);

  @override
  State<PollSettingsModal> createState() => _PollSettingsModalState();
}

class _PollSettingsModalState extends State<PollSettingsModal> {
  final List options = ['Allow people to add options', 'Allow people to choose multiple options'];
  bool isAllowMultipleChoice = false, isAllowMemberAddOptions = false;

  @override
  void initState() {
    super.initState();
    isAllowMultipleChoice = widget.isAllowMultipleChoice;
    isAllowMemberAddOptions = widget.isAllowMemberAddOptions;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // print('val from will pop scope = { isAllowMemberAddOptions: $isAllowMemberAddOptions, isAllowMultipleChoice: $isAllowMultipleChoice, }');

        widget.callBackFunction!({
          'isAllowMemberAddOptions': isAllowMemberAddOptions,
          'isAllowMultipleChoice': isAllowMultipleChoice,
        });
        return Future.value(true);
      },
      child: Container(
        color: KColor.appBackground,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: <Widget>[
            Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 65,
                    height: 5,
                    decoration: BoxDecoration(color: KColor.grey200, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25)))),
            Expanded(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        options[index],
                        style: KTextStyle.bodyText1.copyWith(color: KColor.black),
                      ),
                      trailing: Switch(
                        onChanged: (value) {
                          if (index == 0) {
                            isAllowMemberAddOptions = !isAllowMemberAddOptions;
                          } else {
                            isAllowMultipleChoice = !isAllowMultipleChoice;
                          }
                          setState(() {});
                        },
                        value: index == 0 ? isAllowMemberAddOptions : isAllowMultipleChoice,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
