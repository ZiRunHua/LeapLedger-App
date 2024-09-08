part of 'enter.dart';

class Time {
  static bool isSameDayComparison(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static DateTime getFirstSecondOfDay({DateTime? date}) {
    date ??= DateTime.now();
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getLastSecondOfDay({DateTime? date}) {
    date ??= DateTime.now();
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
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

  static DateTime getFirstSecondOfYear({int numberOfYears = 0, DateTime? date}) {
    date ??= DateTime.now();
    return DateTime(date.year + numberOfYears);
  }

  static DateTime getLastSecondOfYear({int numberOfYears = 0, DateTime? date}) {
    date ??= DateTime.now();
    return DateTime(date.year + numberOfYears + 1).add(const Duration(seconds: -1));
  }

  static List<DateTime> getDays(DateTime start, DateTime end) {
    start = getFirstSecondOfDay(date: start);
    end = getFirstSecondOfDay(date: end);
    List<DateTime> list = [start];
    while (end.isAfter(start)) {
      start = start.add(Duration(days: 1));
      list.add(start);
    }
    return list;
  }
}

class Tz {
  static TZDateTime getNewByDate(DateTime time, Location location) {
    return TZDateTime(location, time.year, time.month, time.day, time.hour, time.minute, time.second, time.millisecond,
        time.microsecond);
  }

  static TZDateTime copy(TZDateTime time) {
    return TZDateTime(time.location, time.year, time.month, time.day, time.hour, time.minute, time.second);
  }

  static bool isSameDayComparison(TZDateTime date1, TZDateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static TZDateTime getFirstSecondOfDay({required TZDateTime date}) {
    return TZDateTime(
      date.location,
      date.year,
      date.month,
      date.day,
    );
  }

  static TZDateTime getLastSecondOfDay({required TZDateTime date}) {
    return TZDateTime(date.location, date.year, date.month, date.day, 23, 59, 59);
  }

  static TZDateTime getLastMonth({required TZDateTime date}) {
    return TZDateTime(date.location, date.year, date.month - 1, date.day);
  }

  static bool isFirstSecondOfMonth(TZDateTime date) {
    return date.day == 1 &&
        date.hour == 0 &&
        date.minute == 0 &&
        date.second == 0 &&
        date.millisecond == 0 &&
        date.microsecond == 0;
  }

  static TZDateTime getFirstSecondOfMonth({required TZDateTime date}) {
    TZDateTime endOfMonth = TZDateTime(date.location, date.year, date.month, 1, 0, 0, 0);
    return endOfMonth;
  }

  static bool isLastSecondOfMonth(TZDateTime date) {
    return getLastSecondOfMonth(date: date).isAtSameMomentAs(date);
  }

  static TZDateTime getLastSecondOfMonth({required TZDateTime date}) {
    TZDateTime lastDayOfMonth = TZDateTime(date.location, date.year, date.month + 1, 0);
    TZDateTime endOfMonth =
        TZDateTime(date.location, lastDayOfMonth.year, lastDayOfMonth.month, lastDayOfMonth.day, 23, 59, 59);
    return endOfMonth;
  }

  static TZDateTime getFirstSecondOfPreviousMonths({required int numberOfMonths, required TZDateTime date}) {
    int currentYear = date.year;
    int currentMonth = date.month;
    int targetMonth = currentMonth - numberOfMonths;
    int targetYear = currentYear;
    while (targetMonth <= 0) {
      targetMonth += 12;
      targetYear -= 1;
    }
    TZDateTime targetDate = TZDateTime(date.location, targetYear, targetMonth, 1);
    TZDateTime firstSecond = TZDateTime(date.location, targetDate.year, targetDate.month, targetDate.day, 0, 0, 0);
    return firstSecond;
  }

  static TZDateTime getFirstSecondOfYear({int numberOfYears = 0, required TZDateTime date}) {
    return TZDateTime(date.location, date.year + numberOfYears);
  }

  static TZDateTime getLastSecondOfYear({int numberOfYears = 0, required TZDateTime date}) {
    return TZDateTime(date.location, date.year + numberOfYears + 1).add(const Duration(seconds: -1));
  }

  static List<TZDateTime> getDays(TZDateTime start, TZDateTime end) {
    start = getFirstSecondOfDay(date: start);
    end = getFirstSecondOfDay(date: end);
    List<TZDateTime> list = [start];
    while (end.isAfter(start)) {
      start = start.add(Duration(days: 1));
      list.add(start);
    }
    return list;
  }
}
