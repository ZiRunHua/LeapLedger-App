part of 'enter.dart';

class Time {
  static bool isSameDayComparison(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static DateTime getFirstSecondOfYear({int numberOfYears = 0, DateTime? date}) {
    date ??= DateTime.now();
    return DateTime(date.year + numberOfYears);
  }

  static DateTime getLastSecondOfYear({int numberOfYears = 0, DateTime? date}) {
    date ??= DateTime.now();
    return DateTime(date.year + numberOfYears + 1).add(const Duration(seconds: -1));
  }

  static DateTime getLastMonth({DateTime? date}) {
    date ??= DateTime.now();
    return DateTime(date.year, date.month - 1, date.day);
  }

  static DateTime getFirstSecondOfMonth({DateTime? date}) {
    date ??= DateTime.now();
    DateTime endOfMonth = DateTime(date.year, date.month, 1, 0, 0, 0);
    return endOfMonth;
  }

  static DateTime getLastSecondOfMonth({DateTime? date}) {
    date ??= DateTime.now();
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    DateTime endOfMonth = DateTime(lastDayOfMonth.year, lastDayOfMonth.month, lastDayOfMonth.day, 23, 59, 59);
    return endOfMonth;
  }

  static DateTime getFirstSecondOfPreviousMonths({required int numberOfMonths, DateTime? date}) {
    date ??= DateTime.now();
    int currentYear = date.year;
    int currentMonth = date.month;
    int targetMonth = currentMonth - numberOfMonths;
    int targetYear = currentYear;
    while (targetMonth <= 0) {
      targetMonth += 12;
      targetYear -= 1;
    }
    DateTime targetDate = DateTime(targetYear, targetMonth, 1);
    DateTime firstSecond = DateTime(targetDate.year, targetDate.month, targetDate.day, 0, 0, 0);
    return firstSecond;
  }
}
