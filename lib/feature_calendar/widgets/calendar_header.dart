import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_calendar/enums/calendar_enums.dart';

/// A widget that displays the current month and year with navigation arrows.
class CalendarHeader extends StatelessWidget {
  /// Creates a [CalendarHeader].
  const CalendarHeader({
    required this.currentMonth,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  /// The month to display.
  final DateTime currentMonth;

  /// Callback for navigating to the previous month.
  final VoidCallback onPrevious;

  /// Callback for navigating to the next month.
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthName = CalendarMonth.values[currentMonth.month - 1].displayName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: onPrevious,
          ),
          Text(
            '$monthName ${currentMonth.year}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 20),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
