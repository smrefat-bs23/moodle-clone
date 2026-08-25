/// Defines the days of the week for the calendar.
enum CalendarDay {
  /// Monday
  monday,
  /// Tuesday
  tuesday,
  /// Wednesday
  wednesday,
  /// Thursday
  thursday,
  /// Friday
  friday,
  /// Saturday
  saturday,
  /// Sunday
  sunday;

  /// Returns the short three-letter display name.
  String get shortName => name[0].toUpperCase() + name.substring(1, 3);
}
