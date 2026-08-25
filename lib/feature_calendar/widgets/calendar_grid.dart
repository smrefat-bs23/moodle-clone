import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_calendar/enums/calendar_days.dart';

/// Grid widget displaying the days of the month with 6 rows.
class CalendarGrid extends StatelessWidget {
  /// Creates a [CalendarGrid].
  const CalendarGrid({
    required this.currentMonth,
    required this.selectedDate,
    required this.onDaySelected,
    super.key,
  });

  /// The month to display.
  final DateTime currentMonth;

  /// The currently selected date.
  final DateTime? selectedDate;

  /// Callback when a day is selected.
  final void Function(DateTime) onDaySelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );
    final firstDayOffset = DateTime(
      currentMonth.year,
      currentMonth.month,
    ).weekday - 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: CalendarDay.values.map((d) => Expanded(
              child: Center(
                child: Text(
                  d.shortName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: 42,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemBuilder: (context, index) {
              final day = index - firstDayOffset + 1;
              final isValid = day > 0 && day <= daysInMonth;
              final date = DateTime(currentMonth.year, currentMonth.month, day);
              final isSelected = selectedDate != null &&
                  selectedDate!.day == day &&
                  selectedDate!.month == currentMonth.month;

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                  // Tinted background for empty cells
                  color: isValid
                      ? colorScheme.surface
                      : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                child: isValid
                    ? InkWell(
                  onTap: () => onDaySelected(date),
                  child: Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all() : null,
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ),
      ],
    );
  }
}