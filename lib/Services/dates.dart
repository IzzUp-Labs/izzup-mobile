class Dates {
  //static function that converts a datetime to a postgres timestamptz
  static String toPostgresTimestamp(DateTime date) {
    return date.toUtc().toIso8601String();
  }

  //static function that converts a postgres timestamptz to a datetime
  static DateTime fromPostgresTimestamp(String date) {
    return DateTime.parse(date).toLocal();
  }
}