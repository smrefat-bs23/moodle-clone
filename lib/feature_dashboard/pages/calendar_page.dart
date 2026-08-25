import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/new_event_page.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Calendar page displayed when "Calendar" is tapped from the dashboard.
///
/// Mirrors the official Moodle Mobile layout:
///   - Header with back arrow, title, filter icon, kebab menu
///   - Month view ("July 2026"), weekday headers Mon-Sun
///   - Floating round orange + button for new events
///   - Tapping a day opens the Calendar events page
///   - Tapping the filter icon opens the event type filter sheet
///   - Tapping the kebab menu opens the Settings / Upcoming events menu
class CalendarPage extends StatefulWidget {
  /// Creates a [CalendarPage].
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _visibleMonth;
  late DateTime _selectedDate;

  // Mock event filters (all enabled by default like the design).
  bool _siteEvents = true;
  bool _categoryEvents = true;
  bool _courseEvents = true;
  bool _groupEvents = true;
  bool _userEvents = true;
  bool _allCourses = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + delta,
        1,
      );
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (innerContext, setSheetState) {
            Widget row({
              required Color color,
              required IconData icon,
              required String label,
              required bool value,
              required ValueChanged<bool> onChanged,
            }) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg.w,
                  vertical: 12.h,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.white,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: AppFontSize.md.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black87,
                        ),
                      ),
                    ),
                    Switch(
                      value: value,
                      onChanged: onChanged,
                      activeThumbColor: AppColors.moodleOrange,
                      activeTrackColor:
                          AppColors.moodleOrange.withValues(alpha: 0.45),
                      inactiveThumbColor: AppColors.grey400,
                      inactiveTrackColor: AppColors.grey200,
                    ),
                  ],
                ),
              );
            }

            return SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8.h),
                  row(
                    color: const Color(0xFF388E3C),
                    icon: Icons.public,
                    label: 'Site events',
                    value: _siteEvents,
                    onChanged: (v) => setSheetState(() => _siteEvents = v),
                  ),
                  Divider(height: 1.h, color: AppColors.divider),
                  row(
                    color: const Color(0xFF8E24AA),
                    icon: Icons.category,
                    label: 'Category events',
                    value: _categoryEvents,
                    onChanged: (v) => setSheetState(() => _categoryEvents = v),
                  ),
                  Divider(height: 1.h, color: AppColors.divider),
                  row(
                    color: const Color(0xFFC62828),
                    icon: Icons.school,
                    label: 'Course events',
                    value: _courseEvents,
                    onChanged: (v) => setSheetState(() => _courseEvents = v),
                  ),
                  Divider(height: 1.h, color: AppColors.divider),
                  row(
                    color: const Color(0xFFE0A100),
                    icon: Icons.group,
                    label: 'Group events',
                    value: _groupEvents,
                    onChanged: (v) => setSheetState(() => _groupEvents = v),
                  ),
                  Divider(height: 1.h, color: AppColors.divider),
                  row(
                    color: const Color(0xFF1976D2),
                    icon: Icons.person,
                    label: 'User events',
                    value: _userEvents,
                    onChanged: (v) => setSheetState(() => _userEvents = v),
                  ),
                  Divider(height: 1.h, color: AppColors.divider),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'All courses',
                            style: TextStyle(
                              fontSize: AppFontSize.md.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black87,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              setSheetState(() => _allCourses = !_allCourses),
                          child: Icon(
                            _allCourses
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: AppColors.black87,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openMenu() {
    showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 56.w,
        kToolbarHeight + MediaQuery.of(context).padding.top + 8.h,
        16.w,
        0,
      ),
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
      ),
      items: [
        PopupMenuItem<void>(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: 14.h,
          ),
          child: Row(
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: AppFontSize.md.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.settings,
                size: 22.sp,
                color: AppColors.grey700,
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).pop();
            context.pushNamed(AppRoutes.calendarSettings);
          },
        ),
        PopupMenuItem<void>(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: 14.h,
          ),
          child: Row(
            children: [
              Text(
                'Upcoming events',
                style: TextStyle(
                  fontSize: AppFontSize.md.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.calendar_view_month,
                size: 22.sp,
                color: AppColors.grey700,
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const _CalendarUpcomingEventsPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildMonthGrid(),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: Builder(
        builder: (innerContext) => IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            if (GoRouter.of(innerContext).canPop()) {
              GoRouter.of(innerContext).pop();
            } else {
              Navigator.of(innerContext).maybePop();
            }
          },
        ),
      ),
      title: Text(
        'Calendar',
        style: TextStyle(
          color: AppColors.black,
          fontSize: AppFontSize.xxl.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.filter_alt,
            color: AppColors.black87,
            size: 24.sp,
          ),
          onPressed: _openFilterSheet,
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: AppColors.black87,
            size: 24.sp,
          ),
          onPressed: _openMenu,
        ),
      ],
    );
  }

  Widget _buildFab() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, right: 8.w),
      child: FloatingActionButton(
        backgroundColor: AppColors.moodleOrange,
        elevation: 6,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => NewEventPage(initialDate: _selectedDate),
            ),
          );
        },
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: 28.sp,
        ),
      ),
    );
  }

  Widget _buildMonthGrid() {
    final monthLabel = DateFormat('MMMM y').format(_visibleMonth);

    // First day of the month and weekday it falls on.
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    // Dart: Monday = 1 ... Sunday = 7. Visually we want Mon=0 .. Sun=6.
    final leadingBlanks = (firstOfMonth.weekday - 1) % 7;
    final daysInMonth = DateUtils.getDaysInMonth(
      _visibleMonth.year,
      _visibleMonth.month,
    );

    final totalCells = leadingBlanks + daysInMonth;
    final rows = (totalCells / 7).ceil();

    final today = DateTime.now();
    final isCurrentMonth =
        today.year == _visibleMonth.year && today.month == _visibleMonth.month;

    return Column(
      children: [
        // Month header with prev/next arrows.
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.std.w,
            vertical: 8.h,
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 28.sp,
                  color: AppColors.black87,
                ),
                onPressed: () => _changeMonth(-1),
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSize.xl.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black87,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  size: 28.sp,
                  color: AppColors.black87,
                ),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
        ),
        // Weekday headers.
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.std.w,
            vertical: 4.h,
          ),
          child: Row(
            children: const [
              _WeekdayLabel('Mon'),
              _WeekdayLabel('Tue'),
              _WeekdayLabel('Wed'),
              _WeekdayLabel('Thu'),
              _WeekdayLabel('Fri'),
              _WeekdayLabel('Sat'),
              _WeekdayLabel('Sun'),
            ],
          ),
        ),
        // Day grid.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.std.w),
          child: Column(
            children: [
              for (var row = 0; row < rows; row++)
                Row(
                  children: [
                    for (var col = 0; col < 7; col++)
                      _buildCell(
                        rowIndex: row,
                        colIndex: col,
                        leadingBlanks: leadingBlanks,
                        daysInMonth: daysInMonth,
                        isCurrentMonth: isCurrentMonth,
                        today: today,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCell({
    required int rowIndex,
    required int colIndex,
    required int leadingBlanks,
    required int daysInMonth,
    required bool isCurrentMonth,
    required DateTime today,
  }) {
    final cellIndex = rowIndex * 7 + colIndex;
    final dayNumber = cellIndex - leadingBlanks + 1;

    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return Expanded(
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            border: Border(
              top: BorderSide(color: AppColors.divider, width: 0.5),
              right: BorderSide(color: AppColors.divider, width: 0.5),
              bottom: BorderSide(color: AppColors.divider, width: 0.5),
            ),
          ),
        ),
      );
    }

    final cellDate = DateTime(
      _visibleMonth.year,
      _visibleMonth.month,
      dayNumber,
    );
    final isToday = isCurrentMonth && dayNumber == today.day;
    final isSelected = cellDate.year == _selectedDate.year &&
        cellDate.month == _selectedDate.month &&
        cellDate.day == _selectedDate.day;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() => _selectedDate = cellDate);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _CalendarEventsPage(date: cellDate),
            ),
          );
        },
        child: Container(
          height: 56.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              top: BorderSide(color: AppColors.divider, width: 0.5),
              right: BorderSide(color: AppColors.divider, width: 0.5),
              bottom: BorderSide(color: AppColors.divider, width: 0.5),
            ),
          ),
          child: isToday
              ? Container(
                  width: 32.w,
                  height: 32.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.black87, width: 1.5),
                  ),
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: AppFontSize.md.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black87,
                    ),
                  ),
                )
              : Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: AppFontSize.md.sp,
                    color:
                        isSelected ? AppColors.moodleOrange : AppColors.black87,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
        ),
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 36.h,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppFontSize.md.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black87,
          ),
        ),
      ),
    );
  }
}

/// "Calendar events" page shown when a day is tapped.
class _CalendarEventsPage extends StatefulWidget {
  const _CalendarEventsPage({required this.date});

  final DateTime date;

  @override
  State<_CalendarEventsPage> createState() => _CalendarEventsPageState();
}

class _CalendarEventsPageState extends State<_CalendarEventsPage> {
  /// Sample event list anchored to the selected day. Replace with cubit data.
  List<_CalendarEvent> _events = const [];

  @override
  void initState() {
    super.initState();
    _events = _seedEvents(widget.date);
  }

  void _openMenu() {
    showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 56.w,
        kToolbarHeight + MediaQuery.of(context).padding.top + 8.h,
        16.w,
        0,
      ),
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
      ),
      items: [
        PopupMenuItem<void>(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: 14.h,
          ),
          child: Row(
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: AppFontSize.md.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                ),
              ),
              const Spacer(),
              Icon(Icons.settings, size: 22.sp, color: AppColors.grey700),
            ],
          ),
          onTap: () {
            Navigator.of(context).pop();
            context.pushNamed(AppRoutes.calendarSettings);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEEE, MMMM d, y').format(widget.date);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Builder(
          builder: (innerContext) => IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.of(innerContext).maybePop(),
          ),
        ),
        title: Text(
          'Calendar events',
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.xxl.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: AppColors.black87, size: 24.sp),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.black87, size: 24.sp),
            onPressed: _openMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          // Day navigation row.
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.std.w,
              vertical: 6.h,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left,
                      size: 28.sp, color: AppColors.black87),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => _CalendarEventsPage(
                          date: widget.date.subtract(const Duration(days: 1)),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    dateLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSize.xl.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right,
                      size: 28.sp, color: AppColors.black87),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => _CalendarEventsPage(
                          date: widget.date.add(const Duration(days: 1)),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _events.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.std.w,
                      vertical: AppSpacing.md.h,
                    ),
                    itemCount: _events.length,
                    separatorBuilder: (ctx, idx) =>
                        SizedBox(height: AppSpacing.md.h),
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return _buildEventTile(event);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 16.h, right: 8.w),
        child: FloatingActionButton(
          backgroundColor: AppColors.moodleOrange,
          elevation: 6,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => NewEventPage(initialDate: widget.date),
              ),
            );
          },
          shape: const CircleBorder(),
          child: Icon(Icons.add, color: AppColors.white, size: 28.sp),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 96.w,
            color: AppColors.grey300,
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'There are no events',
            style: TextStyle(
              fontSize: AppFontSize.lg.sp,
              color: AppColors.grey800,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(_CalendarEvent event) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: AppFontSize.md.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  event.time,
                  style: TextStyle(
                    fontSize: AppFontSize.sm.sp,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarEvent {
  const _CalendarEvent({
    required this.title,
    required this.time,
    required this.color,
  });

  final String title;
  final String time;
  final Color color;
}

List<_CalendarEvent> _seedEvents(DateTime date) {
  // Design shows "There are no events" by default; keep list empty.
  return const [];
}

/// "Upcoming events" page reachable from the calendar menu.
class _CalendarUpcomingEventsPage extends StatelessWidget {
  const _CalendarUpcomingEventsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Builder(
          builder: (innerContext) => IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.of(innerContext).maybePop(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar',
              style: TextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.xxl.sp,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
            Text(
              'Upcoming events',
              style: TextStyle(
                color: AppColors.black87,
                fontSize: AppFontSize.md.sp,
                fontWeight: FontWeight.w400,
                height: 1.1,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: AppColors.black87, size: 24.sp),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.black87, size: 24.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 96.w,
              color: AppColors.grey300,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'There are no events',
              style: TextStyle(
                fontSize: AppFontSize.lg.sp,
                color: AppColors.grey800,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 16.h, right: 8.w),
        child: FloatingActionButton(
          backgroundColor: AppColors.moodleOrange,
          elevation: 6,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NewEventPage(),
              ),
            );
          },
          shape: const CircleBorder(),
          child: Icon(Icons.add, color: AppColors.white, size: 28.sp),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
