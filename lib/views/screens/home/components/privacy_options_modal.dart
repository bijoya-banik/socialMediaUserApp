import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class PrivacyOptions {
  final String name;
  final IconData iconData;

  const PrivacyOptions(this.name, this.iconData);
}

const List<PrivacyOptions> privacyOptions = [
  PrivacyOptions('Public', Icons.public),
  PrivacyOptions('Friends', Icons.group),
  PrivacyOptions('Only Me', Icons.lock),
];
const List<PrivacyOptions> storyPrivacyOptions = [
  PrivacyOptions('Friends', Icons.group),
  PrivacyOptions('Only Me', Icons.lock),
];

class PrivacyOptionsModal extends StatefulWidget {
  final List<PrivacyOptions> options;
  final Function? callBackFunction;
  final String isSelected;
  final bool isStory;

  const PrivacyOptionsModal({Key? key, this.options = privacyOptions, this.callBackFunction, this.isSelected = 'Public', this.isStory = false})
      : super(key: key);

  @override
  State<PrivacyOptionsModal> createState() => _PrivacyOptionsModalState();
}

class _PrivacyOptionsModalState extends State<PrivacyOptionsModal> {
  List<PrivacyOptions> optionsInstance = [];
  String isSelectedInstance = "Public";

  @override
  void initState() {
    super.initState();
    if (widget.isStory) {
      optionsInstance = storyPrivacyOptions;
      isSelectedInstance = "Friends";
    } else {
      optionsInstance = widget.options;
      isSelectedInstance = widget.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KColor.appBackground,
      height: MediaQuery.of(context).size.height * 0.3,
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
                itemCount: optionsInstance.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 23.0,
                      backgroundColor: KColor.black.withOpacity(0.1),
                      child: Icon(optionsInstance[index].iconData, color: KColor.black),
                    ),
                    title: Text(
                      optionsInstance[index].name,
                      style: KTextStyle.bodyText1.copyWith(color: KColor.black),
                    ),
                    onTap: () {
                      widget.callBackFunction!(optionsInstance[index].name);
                      Navigator.pop(context);
                    },
                    trailing:isSelectedInstance == optionsInstance[index].name ? Icon(Icons.check, color: KColor.black54) : null,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
