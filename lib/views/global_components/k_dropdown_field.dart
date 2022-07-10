import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

// ignore: must_be_immutable
class KDropdownField extends StatefulWidget {
  final String? title;
  final String? disabledHint;
  final List dropdownFieldOptions;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  String? errorMessage;
  final Function? callbackFunction;
  final bool? isCallback;
  final bool? isObject;
  final TextEditingController? selectedIdController;
  final String? initialValue;

  KDropdownField({
    Key? key,
    this.title,
    this.disabledHint,
    required this.dropdownFieldOptions,
    this.controller,
    this.validator,
    this.errorMessage = "",
    this.callbackFunction,
    this.isCallback = false,
    this.isObject = true,
    this.selectedIdController,
    this.initialValue,
  }) : super(key: key);

  @override
  _KDropdownFieldState createState() => _KDropdownFieldState();
}

class _KDropdownFieldState extends State<KDropdownField> {
  @override
  void initState() {
    if (widget.isObject!) {
      widget.initialValue == null ? widget.controller!.text = widget.dropdownFieldOptions[0].name : widget.controller!.text = widget.initialValue!;
      if (widget.selectedIdController != null) widget.selectedIdController!.text = widget.dropdownFieldOptions[0].id.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          if (widget.title != null)
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  widget.title ?? '',
                  textAlign: TextAlign.start,
                  style: KTextStyle.subtitle2.copyWith(color: KColor.white),
                )),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: KSize.getWidth(context, 10), right: KSize.getWidth(context, 10), bottom: 3, top: 3),
            decoration: BoxDecoration(
              color: KColor.textBackground,
              boxShadow: [BoxShadow(color: KColor.white.withOpacity(0.1), blurRadius: 2, spreadRadius: 0, offset: const Offset(0, 1))],
              border: Border.all(
                color: widget.errorMessage == null
                    ? KColor.grey
                    : widget.errorMessage!.isEmpty
                        ? KColor.grey
                        : KColor.buttonBackground,
                width: 0.7,
                style: widget.errorMessage == null || widget.errorMessage!.isEmpty ? BorderStyle.none : BorderStyle.solid,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: KColor.textBackground),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  validator: (String? value) {
                    setState(() {
                      widget.errorMessage = widget.validator!(value);
                    });

                    return widget.errorMessage == null || widget.errorMessage!.isEmpty ? null : widget.errorMessage;
                  },
                  decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0, height: 0)),
                  disabledHint: Text(widget.disabledHint ?? "Select", style: KTextStyle.bodyText3.copyWith(color: KColor.black54)),
                  isExpanded: true,
                  value: widget.controller!.text,
                  icon: Padding(
                    padding: EdgeInsets.only(right: KSize.getWidth(context, 12)),
                    child: Icon(Icons.keyboard_arrow_down, size: 25, color: KColor.black54),
                  ),
                  items: widget.isObject!
                      ? widget.dropdownFieldOptions.map((dynamic dropDownStringItem) {
                          return DropdownMenuItem<String>(
                              value: dropDownStringItem.name,
                              child: Text(
                                dropDownStringItem.name,
                                textAlign: TextAlign.left,
                                style: KTextStyle.bodyText2.copyWith(color: KColor.black87),
                              ));
                        }).toList()
                      : widget.dropdownFieldOptions.map((dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              textAlign: TextAlign.left,
                              style: KTextStyle.bodyText2.copyWith(color: KColor.black87),
                            ),
                          );
                        }).toList(),
                  onChanged: (String? value) {
                    print('onChanged... onChanged... onChanged...');
                    setState(() {
                      widget.controller!.text = value ?? '';
                      if (widget.isObject!) {
                        if (widget.selectedIdController != null) {
                          widget.selectedIdController?.text =
                              widget.dropdownFieldOptions[widget.dropdownFieldOptions.indexWhere((element) => element.name == value)].id.toString();
                        }
                      }
                    });
                    if (widget.isCallback!) widget.callbackFunction!();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
