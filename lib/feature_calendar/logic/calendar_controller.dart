import 'package:flutter/material.dart';

/// Controller for the calendar screen.
class CalendarController extends ChangeNotifier {
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate = DateTime.now();

  /// The month currently being displayed.
  DateTime get currentMonth => _currentMonth;

  /// The currently selected date.
  DateTime? get selectedDate => _selectedDate;

  /// Moves to the next month.
  void nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    notifyListeners();
  }

  /// Moves to the previous month.
  void previousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    notifyListeners();
  }

  /// Handles date selection.
  void onDaySelected(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
