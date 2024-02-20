import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getTimeString(
  final DateTime dateTime, {
  final bool? isStrict,
  final FormatType? formatType,
  required final String defaultText,
}) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  // debugPrint(now.toString());
  // debugPrint(dateTime.toString());
  // debugPrint(difference.toString());
  // debugPrint(isStrict.toString());
  // debugPrint(formatType.toString());

  final differenceInDays = difference.inDays;
  if ((formatType == FormatType.automatic || formatType == FormatType.days)) {
    if (differenceInDays > 0) {
      if (differenceInDays == 1) {
        return 'Вчера';
      }
      return DateFormat("dd.MM.yy").format(dateTime);
    }
  }

  final differenceInHours = difference.inHours;
  if ((formatType == FormatType.automatic || formatType == FormatType.hours)) {
    if (differenceInHours > 0) {
      if (differenceInHours == 1) {
        return 'Час назад';
      }
      return DateFormat("HH:mm").format(dateTime);
    }
  }

  final differenceInMinutes = difference.inMinutes;
  if ((formatType == FormatType.automatic ||
      formatType == FormatType.minutes)) {
    if (differenceInMinutes > 0) {
      if (differenceInMinutes == 1) {
        return 'Минуту назад';
      }
      if (differenceInMinutes < 5) {
        return "${dateTime.minute} минуты назад";
      }
      return "${dateTime.minute} минут назад";
    }
  }

  final differenceInSeconds = difference.inSeconds;
  if ((formatType == FormatType.automatic ||
      formatType == FormatType.seconds)) {
    if (differenceInSeconds > 0) {
      if (differenceInSeconds == 1) {
        return 'Секунду назад';
      }
      if (differenceInSeconds < 5) {
        return "${dateTime.second} секунды назад";
      }
      return "${dateTime.second} секунд назад";
    }
  }

  final differenceInMilliseconds = difference.inMilliseconds;
  if ((formatType == FormatType.automatic ||
      formatType == FormatType.milliseconds)) {
    if (differenceInMilliseconds > 100) {
      return "Только что";
    }
  }

  return defaultText;
}

enum FormatType { automatic, days, hours, minutes, seconds, milliseconds }

class TimeDifferenceWidget extends StatelessWidget {
  final DateTime dateTime;
  final bool isStrict;
  final FormatType formatType;
  final String defaultText;

  const TimeDifferenceWidget({
    super.key,
    required this.dateTime,
    this.isStrict = false,
    this.defaultText = '',
    this.formatType = FormatType.automatic,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // final Duration timerDuration = ;
    // Timer.periodic(timerDuration, (Timer t) => setState(() {}));

    return Text(
      getTimeString(
        dateTime,
        defaultText: defaultText,
        isStrict: isStrict,
        formatType: formatType,
      ),
      style: TextStyle(
        color: theme.colorScheme.onTertiary,
        fontSize: 12,
      ),
    );
  }
}
