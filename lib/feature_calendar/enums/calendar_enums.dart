/// Defines the months of the year for the calendar.
enum CalendarMonth {
  /// January
  january,
  /// February
  february,
  /// March
  march,
  /// April
  april,
  /// May
  may,
  /// June
  june,
  /// July
  july,
  /// August
  august,
  /// September
  september,
  /// October
  october,
  /// November
  november,
  /// December
  december;

  /// Returns the capitalized name of the month.
  String get displayName => name[0].toUpperCase() + name.substring(1);
}
