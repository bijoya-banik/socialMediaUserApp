import 'dart:io';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/date_time_modal_content.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateTimeService {
  static convert(dateTime, {bool isDate = true, bool isLongDate = false, bool isDateWithTime = false, bool isCustomDateFormat = false}) {
    // Format:
    // var utcFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
    var dateFormat = DateFormat('yyyy-MM-dd');
    var customDateFormat = DateFormat('dd MMM');
    var longDateFormat = DateFormat("MMMM d, y ");
    var timeFormat = DateFormat('h:mm a');

    DateTime parsedLocalDateTime;
    parsedLocalDateTime = DateTime.parse(dateTime.toString()).toLocal();

    if (isDate && !isLongDate && !isCustomDateFormat && !isDateWithTime) {
      return dateFormat.format(parsedLocalDateTime);
    } else if (isLongDate) {
      return longDateFormat.format(parsedLocalDateTime);
    } else if (isCustomDateFormat) {
      return customDateFormat.format(parsedLocalDateTime);
    } else if (isDateWithTime) {
      return longDateFormat.format(parsedLocalDateTime) + timeFormat.format(parsedLocalDateTime);
    } else {
      return timeFormat.format(parsedLocalDateTime);
    }
  }

  static timeAgoLocal(dateTime, {alwaysTimeAgo = false, timeAgo = 2, shortTime = false}) {
    if (!alwaysTimeAgo) {
      return DateTime.now().difference(DateTime.parse(dateTime)).inDays > timeAgo
          ? DateFormat('dd/MM/yyyy' /*'MMM dd, yyyy h:mm a'*/).format(DateTime.parse(dateTime).toLocal())
          : timeago.format(DateTime.parse(dateTime), allowFromNow: true, locale: shortTime ? 'en_short' : '');
    } else {
      return timeago.format(DateTime.parse(dateTime), allowFromNow: true, locale: shortTime ? 'en_short' : '');
    }
  }

  /*
  Date Picker Function
  */
  static Future<DateTime> pickDate(BuildContext context, {isFirstNow = false, firstDate, lastDate, initialDate}) async {
    final DateTime? picked = Platform.isIOS
        ? await showModalBottomSheet<DateTime>(
            context: context,
            isDismissible: true,
            elevation: 5,
            isScrollControlled: true,
            backgroundColor: KColor.appBackground,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            ),
            builder: (context) {
              return DateTimeModalContent(
                  isFirstNow: isFirstNow,
                  firstDate: firstDate == null ? DateTime(1500) : DateTime(firstDate.year, firstDate.month, firstDate.day),
                  lastDate: lastDate,
                  initialDate: initialDate);
            },
          )
        : await showDatePicker(
            context: context,
            initialDate: initialDate == null ? DateTime.now() : DateTime(initialDate.year, initialDate.month, initialDate.day),
            firstDate: firstDate == null ? DateTime(1500) : DateTime(firstDate.year, firstDate.month, firstDate.day),
            lastDate: lastDate == null ? DateTime(2101) : DateTime(lastDate.year, lastDate.month, lastDate.day),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: AppMode.darkMode
                    ? ThemeData.dark().copyWith(
                        colorScheme:
                            const ColorScheme.dark().copyWith(primary: KColor.primary, primaryContainer: KColor.primary, secondary: KColor.primary),
                      )
                    : ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(primary: KColor.primary),
                        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                child: child!,
              );
            },
          );
    return picked!;
  }

  /*
  Time Picker Function
  */
  static Future pickTime(BuildContext context) async {
    dynamic picked = Platform.isIOS
        ? await showModalBottomSheet<DateTime>(
            context: context,
            isDismissible: true,
            elevation: 5,
            isScrollControlled: true,
            backgroundColor: KColor.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            ),
            builder: (context) {
              return const DateTimeModalContent(isFirstNow: false, isDate: false);
            },
          ) /* returns DateTime */
        : await showTimePicker(
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: AppMode.darkMode
                    ? ThemeData.dark().copyWith(
                        colorScheme:
                            const ColorScheme.dark().copyWith(primary: KColor.primary, primaryContainer: KColor.primary, secondary: KColor.primary),
                      )
                    : ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(primary: KColor.primary),
                        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                child: child!,
              );
            },
            context: context,
            initialTime: TimeOfDay.now(),
          ); /* Returns TimeOfDay */
    return picked;
  }

//  TargetPlatform.android
}
