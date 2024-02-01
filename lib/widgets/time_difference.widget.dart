import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getTimeString(final DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  {
    final differenceInDays = difference.inDays;
    if (differenceInDays > 0) {
      if (differenceInDays == 1) {
        return 'Вчера';
      }
      return DateFormat("DD.MM.yy").format(dateTime);
    }
  }

  {
    final differenceInHours = difference.inHours;
    if (differenceInHours > 0) {
      if (differenceInHours == 1) {
        return 'Час назад';
      }
      return DateFormat("HH:mm").format(dateTime);
    }
  }

  {
    final differenceInMinutes = difference.inMinutes;
    if (differenceInMinutes > 0) {
      if (differenceInMinutes == 1) {
        return 'Минуту назад';
      }
      return "${dateTime.minute} минут назад";
    }
  }

  return '';
}

class TimeDifferenceWidget extends StatelessWidget {
  final DateTime dateTime;

  const TimeDifferenceWidget({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      getTimeString(dateTime),
      style: TextStyle(
        color: theme.colorScheme.onTertiary,
        fontSize: 12,
      ),
    );
  }
}
