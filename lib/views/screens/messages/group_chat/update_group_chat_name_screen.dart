import 'package:buddyscripts/controller/chat/group_chat_controller.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class UpdateGroupChatNameScreen extends ConsumerStatefulWidget {
  final dynamic groupName;
  final dynamic inboxId;
  const UpdateGroupChatNameScreen({this.groupName, this.inboxId, Key? key}) : super(key: key);

  @override
  _UpdateGroupChatNameScreenState createState() => _UpdateGroupChatNameScreenState();
}

class _UpdateGroupChatNameScreenState extends ConsumerState<UpdateGroupChatNameScreen> {
  TextEditingController nameController = TextEditingController();
  String groupName = '';
  @override
  void initState() {
    super.initState();
    nameController.text = widget.groupName;
    groupName = widget.groupName;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'Edit group name', automaticallyImplyLeading: false, hasLeading: true),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              KTextField(
                hintText: groupName,
                controller: nameController,
                autofocus: true,
                validator: (v) => Validators.fieldValidator(v),
                callBack: true,
                callBackFunction: (String val) {
                  setState(() {
                    groupName = val;
                  });
                },
              ),
              SizedBox(height: KSize.getHeight(context, 20)),
              KButton(
                title: 'Save',
                color: widget.groupName == nameController.text ? KColor.black54 : KColor.primary,
                onPressedCallback: () async {
                  if (widget.groupName != nameController.text) {
                    if (_formKey.currentState!.validate()) {
                      KDialog.kShowDialog(
                        context,
                        const ProcessingDialogContent("Processing..."),
                        barrierDismissible: false,
                      );
                      await ref.read(groupChatProvider.notifier).updateGroupChatName(groupChatName: nameController.text, inboxId: widget.inboxId);
                   Navigator.of(context).pop(nameController.text);
                  
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
