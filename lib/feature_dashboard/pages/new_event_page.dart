import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:intl/intl.dart';

/// Placeholder for the "new calendar event" screen.
///
/// Referenced by the calendar's floating action button, but never built —
/// this stands in until a real event-creation flow lands on its own branch.
class NewEventPage extends StatelessWidget {
  /// Creates a [NewEventPage].
  const NewEventPage({super.key, this.initialDate});

  /// The date the new event should default to, if known.
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    final date = initialDate;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('New Event'),
      ),
      body: Center(
        child: Text(
          date == null
              ? 'Event creation is not implemented yet.'
              : 'Event creation is not implemented yet.\n'
                  'Selected date: '
                  '${DateFormat('EEEE, MMMM d, y').format(date)}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
