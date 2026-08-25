import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'dashboard_state.dart';

/// Bottom navigation destination the user is currently on.
enum DashboardNavTab { dashboard, myCourses, messages, notifications, more }

/// Entity representing a course item on the dashboard.
class CourseEntity extends Equatable {
  /// Creates a new [CourseEntity] instance.
  const CourseEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.progress,
    required this.isEnrolled,
    required this.isLocked,
    this.teacherName = 'Admin User',
    this.teacherInitials = 'AU',
    this.courseCompliance = 'Mandatory',
    this.selfEnrolBlocked = false,
  });

  /// Unique id of the course.
  final String id;

  /// The title of the course.
  final String title;

  /// The category or department of the course.
  final String category;

  /// The banner image URL for the course.
  final String imageUrl;

  /// The progress completion percentage in the 0..1 range.
  final double progress;

  /// Whether the current user is enrolled.
  final bool isEnrolled;

  /// Whether the course is access-restricted (shown via lock icon).
  final bool isLocked;

  /// Display name of the course's primary teacher.
  final String teacherName;

  /// Initials shown inside the teacher's avatar.
  final String teacherInitials;

  /// Compliance label surfaced on the course details page.
  final String courseCompliance;

  /// Whether the current user cannot enrol in this course (shows
  /// the "You cannot enrol yourself in this course" info banner).
  final bool selfEnrolBlocked;

  CourseEntity copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    double? progress,
    bool? isEnrolled,
    bool? isLocked,
    String? teacherName,
    String? teacherInitials,
    String? courseCompliance,
    bool? selfEnrolBlocked,
  }) {
    return CourseEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      progress: progress ?? this.progress,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      isLocked: isLocked ?? this.isLocked,
      teacherName: teacherName ?? this.teacherName,
      teacherInitials: teacherInitials ?? this.teacherInitials,
      courseCompliance: courseCompliance ?? this.courseCompliance,
      selfEnrolBlocked: selfEnrolBlocked ?? this.selfEnrolBlocked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        imageUrl,
        progress,
        isEnrolled,
        isLocked,
        teacherName,
        teacherInitials,
        courseCompliance,
        selfEnrolBlocked,
      ];
}

/// A timeline activity item rendered inside the dashboard Timeline card.
class TimelineActivityEntity extends Equatable {
  /// Creates a new [TimelineActivityEntity] instance.
  const TimelineActivityEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.dueDate,
  });

  /// Unique id of the timeline entry.
  final String id;

  /// Display name (e.g. activity title).
  final String name;

  /// Activity type label (Assignment, Quiz, …).
  final String type;

  /// When the activity is due.
  final DateTime dueDate;

  @override
  List<Object?> get props => [id, name, type, dueDate];
}

/// Cubit for managing the dashboard screen state.
@injectable
class DashboardCubit extends Cubit<DashboardState> {
  /// Creates a new [DashboardCubit] instance.
  DashboardCubit() : super(_initialStateWithMockData());

  static DashboardState _initialStateWithMockData() {
    final now = DateTime.now();
    return const DashboardState().copyWith(
      status: DashboardStatus.loaded,
      courses: _mockCourses.where((c) => c.isEnrolled).toList(),
      availableCourses: _mockCourses,
      timelineActivities: _mockTimeline(now),
    );
  }

  static final List<CourseEntity> _mockCourses = <CourseEntity>[
    const CourseEntity(
      id: 'c1',
      title: 'A1/A2 English with H5P',
      category: 'English as a Foreign Language',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=500',
      progress: 0.15,
      isEnrolled: true,
      isLocked: false,
    ),
    const CourseEntity(
      id: 'c2',
      title: 'Mindful Course Creation',
      category: 'Faculty of Education',
      imageUrl:
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500',
      progress: 0.5,
      isEnrolled: true,
      isLocked: false,
    ),
    const CourseEntity(
      id: 'c3',
      title: 'Mobile App Development',
      category: 'Computer Science',
      imageUrl:
          'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=500',
      progress: 0.8,
      isEnrolled: true,
      isLocked: false,
    ),
    const CourseEntity(
      id: 'c4',
      title: 'AIDLC - New way of implementation',
      category: 'Category 1',
      imageUrl: '',
      progress: 0,
      isEnrolled: false,
      isLocked: true,
      selfEnrolBlocked: true,
    ),
    const CourseEntity(
      id: 'c5',
      title: 'Introduction to Psychology',
      category: 'Social Sciences',
      imageUrl:
          'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=500',
      progress: 0,
      isEnrolled: false,
      isLocked: false,
    ),
    const CourseEntity(
      id: 'c6',
      title: 'Data Structures & Algorithms',
      category: 'Computer Science',
      imageUrl:
          'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=500',
      progress: 0,
      isEnrolled: false,
      isLocked: false,
    ),
  ];

  static List<TimelineActivityEntity> _mockTimeline(DateTime now) =>
      <TimelineActivityEntity>[
        TimelineActivityEntity(
          id: 't1',
          name: 'Submit English essay draft',
          type: 'Assignment',
          dueDate: now.add(const Duration(days: 2)),
        ),
        TimelineActivityEntity(
          id: 't2',
          name: 'Mindful course quiz',
          type: 'Quiz',
          dueDate: now.add(const Duration(days: 5)),
        ),
        TimelineActivityEntity(
          id: 't3',
          name: 'Mobile dev project proposal',
          type: 'Assignment',
          dueDate: now.add(const Duration(days: 14)),
        ),
      ];

  /// Selects the active top-level Dashboard/Site-home sub-tab.
  void selectTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  /// Selects the active bottom navigation destination.
  void selectBottomNav(DashboardNavTab tab) {
    emit(state.copyWith(bottomNavIndex: tab));
  }

  /// Changes the timeline sort type.
  void changeTimelineSortType(TimelineSortType sortType) {
    emit(state.copyWith(timelineSortType: sortType));
  }

  /// Changes the timeline filter type.
  void changeTimelineFilterType(TimelineFilterType filterType) {
    emit(state.copyWith(timelineFilterType: filterType));
  }

  /// Switches the timeline activity list between list and grid layouts.
  void changeTimelineViewMode(TimelineViewMode mode) {
    emit(state.copyWith(timelineViewMode: mode));
  }

  /// Updates the timeline search text.
  void changeTimelineSearch(String value) {
    emit(state.copyWith(timelineSearch: value));
  }

  /// Updates the available-courses search text.
  void changeAvailableCoursesSearch(String value) {
    emit(state.copyWith(availableCoursesSearch: value));
  }

  /// Toggles the "Show only my courses" filter.
  void toggleOnlyMyCourses(bool value) {
    emit(state.copyWith(onlyMyCourses: value));
  }

  /// Toggles a course's locked/unlocked state.
  void toggleCourseLock(String courseId) {
    final updated = state.availableCourses
        .map(
          (c) => c.id == courseId ? c.copyWith(isLocked: !c.isLocked) : c,
        )
        .toList(growable: false);
    emit(state.copyWith(availableCourses: updated));
  }

  /// Fetches the list of enrolled courses for the dashboard.
  Future<void> fetchDashboardCourses() async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      // Simulate network delay
      await Future<void>.delayed(const Duration(milliseconds: 800));

      emit(
        state.copyWith(
          status: DashboardStatus.loaded,
          courses: _mockCourses.where((c) => c.isEnrolled).toList(),
          availableCourses: _mockCourses,
          timelineActivities: _mockTimeline(DateTime.now()),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
