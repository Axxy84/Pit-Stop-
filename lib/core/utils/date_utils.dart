class DatabaseDateUtils {
  static String formatDateTimeForDatabase(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  static DateTime parseDateTimeFromDatabase(String dateString) {
    return DateTime.parse(dateString);
  }

  static String formatDateForDatabase(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static DateTime parseDateFromDatabase(String dateString) {
    final parts = dateString.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  static String getCurrentDatabaseDateTime() {
    return formatDateTimeForDatabase(DateTime.now());
  }

  static String getCurrentDatabaseDate() {
    return formatDateForDatabase(DateTime.now());
  }

  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}