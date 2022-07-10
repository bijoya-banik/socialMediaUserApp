import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';

class DateTimeModalContent extends StatelessWidget {
  final bool isDate, isFirstNow;
  final dynamic initialDate, initialTime, firstDate, lastDate;

  const DateTimeModalContent(
      {Key? key, this.isDate = true, this.isFirstNow = false, this.initialDate, this.initialTime, this.firstDate, this.lastDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? dateTimeVal;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: <Widget>[
          Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 65,
                  height: 5,
                  decoration: BoxDecoration(color: KColor.grey200, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25)))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CupertinoButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
              CupertinoButton(child: const Text('Done'), onPressed: () => Navigator.of(context).pop(dateTimeVal ?? DateTime.now())),
            ],
          ),
          const Divider(height: 0, thickness: 1),
          Expanded(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                brightness: AppMode.darkMode ? Brightness.dark : Brightness.light,
              ),
              child: CupertinoDatePicker(
                maximumDate: lastDate == null ? null : DateTime(lastDate.year, lastDate.month, lastDate.day),
                minimumDate: firstDate,
                initialDateTime: isDate
                    ? isFirstNow
                        ? DateTime.now()
                        : initialDate == null
                            ? DateTime(1500)
                            : DateTime(initialDate.year, initialDate.month, initialDate.day)
                    : initialTime,
                mode: isDate ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.time,
                onDateTimeChanged: (DateTime dateTime) {
                  print(dateTime);
                  dateTimeVal = dateTime;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
