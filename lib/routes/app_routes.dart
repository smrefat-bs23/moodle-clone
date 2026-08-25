/// Route name constants for the application
///
/// This class contains all route names used in the app
/// for navigation and route generation.
abstract class AppRoutes {
  /// Private constructor to prevent instantiation
  AppRoutes._();

  // Auth routes
  static const String courseDetails = '/course-details';

  /// Splash screen route
  static const String splash = '/';

  /// Authentication routes
  static const String login = '/login';

  /// Registration route
  static const String register = '/register';

  /// Forgot password route
  static const String forgotPassword = '/forgot-password';

  /// Posts route (JSONPlaceholder CRUD demo)
  static const String posts = '/posts';
  static const String notification = '/notification';

  /// Dashboard route for the student courses view
  static const String dashboard = '/dashboard';

  /// Available courses route
  static const String availableCourses = '/available-courses';

  /// User details route
  static const String userDetails = '/user-details';

  /// User specific details route
  static const String details = '/details';

  /// Badges route
  static const String badges = '/badges';

  /// Blog entries route
  static const String blogEntries = '/blog-entries';

  // Course routes
  /// Course overview route
  static const String courseOverview = '/course_overview';

  /// Settings routes
  static const String settings = '/settings';

  /// Profile route
  static const String profile = '/profile';

  /// My Courses route (bottom-nav destination).
  static const String myCourses = '/my-courses';

  /// Messages route (bottom-nav destination).
  static const String messages = '/messages';

  /// Notifications route (bottom-nav destination).
  static const String notifications = '/notifications';

  /// More route
  static const String more = '/more';

  /// Search route (dashboard header).
  static const String search = '/search';

  /// Calendar route.
  static const String calendar = '/calendar';

  /// Calendar settings route.
  static const String calendarSettings = '/calendar/settings';

  /// Calendar reminder settings route.
  static const String calendarReminderSettings = '/calendar/reminder';

  /// App settings route
  static const String appSettings = '/app-settings';

  /// About route
  static const String about = '/about';

  /// WebView route (used for in-app browser screens).
  static const String webview = '/webview';

  /// Error routes
  static const String notFound = '/not-found';

  /// Server error route
  static const String serverError = '/server-error';
}
