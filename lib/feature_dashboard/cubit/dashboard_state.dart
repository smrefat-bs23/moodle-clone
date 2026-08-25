part of 'dashboard_cubit.dart';

/// Loading status for the dashboard data fetch.
enum DashboardStatus { initial, loading, loaded, error }

/// Sort type for the Timeline card.
enum TimelineSortType { dates, courses }

/// Visual layout for the Timeline card activity list.
enum TimelineViewMode { list, grid }

/// Predefined Timeline filters with display labels.
enum TimelineFilterType {
  all('All'),
  overdue('Overdue'),
  next7Days('Next 7 days'),
  next30Days('Next 30 days'),
  next3Months('Next 3 months'),
  next6Months('Next 6 months');

  const TimelineFilterType(this.label);
  final String label;
}

/// Dashboard state held by [DashboardCubit].
class DashboardState extends Equatable {
  /// Creates a new [DashboardState] instance.
  const DashboardState({
    this.selectedTabIndex = 0,
    this.bottomNavIndex = DashboardNavTab.dashboard,
    this.status = DashboardStatus.initial,
    this.courses = const [],
    this.availableCourses = const [],
    this.timelineActivities = const [],
    this.message = '',
    this.timelineSortType = TimelineSortType.dates,
    this.timelineFilterType = TimelineFilterType.next30Days,
    this.timelineSearch = '',
    this.availableCoursesSearch = '',
    this.onlyMyCourses = false,
    this.timelineViewMode = TimelineViewMode.list,
  });

  /// Index of the active Dashboard / Site-home sub-tab.
  final int selectedTabIndex;

  /// Active bottom navigation destination.
  final DashboardNavTab bottomNavIndex;

  /// Current loading status of the cubit.
  final DashboardStatus status;

  /// Enrolled courses shown on the Dashboard tab.
  final List<CourseEntity> courses;

  /// All courses shown in the Available Courses list.
  final List<CourseEntity> availableCourses;

  /// Mock timeline items rendered inside the Timeline card.
  final List<TimelineActivityEntity> timelineActivities;

  /// Last error message, if any.
  final String message;

  /// Sort setting for the Timeline card.
  final TimelineSortType timelineSortType;

  /// Period filter for the Timeline card.
  final TimelineFilterType timelineFilterType;

  /// Search text in the Timeline card.
  final String timelineSearch;

  /// Search text in the Available Courses page.
  final String availableCoursesSearch;

  /// Whether the Available Courses list is filtered to enrolled courses.
  final bool onlyMyCourses;

  /// Active layout for the Timeline card activity list (list vs grid).
  final TimelineViewMode timelineViewMode;

  TimelineActivityEntity? get firstTimelineActivity {
    if (timelineActivities.isEmpty) return null;
    return timelineActivities.first;
  }

  @override
  List<Object?> get props => [
        selectedTabIndex,
        bottomNavIndex,
        status,
        courses,
        availableCourses,
        timelineActivities,
        message,
        timelineSortType,
        timelineFilterType,
        timelineSearch,
        availableCoursesSearch,
        onlyMyCourses,
        timelineViewMode,
      ];

  DashboardState copyWith({
    int? selectedTabIndex,
    DashboardNavTab? bottomNavIndex,
    DashboardStatus? status,
    List<CourseEntity>? courses,
    List<CourseEntity>? availableCourses,
    List<TimelineActivityEntity>? timelineActivities,
    String? message,
    TimelineSortType? timelineSortType,
    TimelineFilterType? timelineFilterType,
    String? timelineSearch,
    String? availableCoursesSearch,
    bool? onlyMyCourses,
    TimelineViewMode? timelineViewMode,
  }) {
    return DashboardState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      status: status ?? this.status,
      courses: courses ?? this.courses,
      availableCourses: availableCourses ?? this.availableCourses,
      timelineActivities: timelineActivities ?? this.timelineActivities,
      message: message ?? this.message,
      timelineSortType: timelineSortType ?? this.timelineSortType,
      timelineFilterType: timelineFilterType ?? this.timelineFilterType,
      timelineSearch: timelineSearch ?? this.timelineSearch,
      availableCoursesSearch:
          availableCoursesSearch ?? this.availableCoursesSearch,
      onlyMyCourses: onlyMyCourses ?? this.onlyMyCourses,
      timelineViewMode: timelineViewMode ?? this.timelineViewMode,
    );
  }
}
