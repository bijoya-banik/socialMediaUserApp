import 'dart:io';

import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class KDateTimePickerField extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final String? dateHint;
  final String? timeHint;
  final TextInputType? inputType;
  // ignore: prefer_typing_uninitialized_variables
  final dateTimePickerType;
  final bool disablePastDate;
  final bool calender;
  final double topMargin;
  final FormFieldValidator? validator;
  String errorMessage;

  KDateTimePickerField({
    Key? key,
    this.label,
    this.controller,
    this.dateHint,
    this.inputType,
    this.validator,
    this.errorMessage = "",
    this.dateTimePickerType = 'date',
    this.timeHint = 'Time',
    this.disablePastDate = false,
    this.calender = true,
    this.topMargin = 20.0,
  }) : super(key: key);

  @override
  _KDateTimePickerFieldState createState() => _KDateTimePickerFieldState();
}

class _KDateTimePickerFieldState extends State<KDateTimePickerField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: KSize.getHeight(context, widget.topMargin)),
      child: Column(
        children: <Widget>[
          widget.label != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.label ?? "",
                    textAlign: TextAlign.start,
                    style: KTextStyle.bodyText2.copyWith(color: KColor.grey350const!.withOpacity(0.7)),
                  ))
              : Container(),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.errorMessage.isEmpty ? KColor.grey : KColor.buttonBackground,
                width: 0.7,
                style: widget.errorMessage.isEmpty ? BorderStyle.none : BorderStyle.solid,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: KTextField(
              hintText: 'Date',
              controller: widget.controller,
              isReadOnly: true,
              suffixIcon: Icon(Icons.date_range, color: KColor.grey350const),
              topMargin: KSize.getHeight(context, 10),
              onTap: () async {
                var date = await DateTimeService.pickDate(context, isFirstNow: true);

                setState(() {
                  widget.controller?.text = DateFormat('dd/MM/yyyy').format(date);
                });

                var time = await DateTimeService.pickTime(context);
                print('time = $time');

                setState(() {
                  widget.controller?.text += ' ${(Platform.isIOS ? TimeOfDay.fromDateTime(time).format(context) : time.format(context))}';
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
