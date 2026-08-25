import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_app_settings/pages/app_settings_page.dart';
import 'package:flutter_boilerplate/feature_auth/pages/login_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/available_courses_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/badges_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/blog_entries_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/calendar_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/dashboard_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/details_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/messages_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/my_courses_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/notifications_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/user_details_page.dart';
import 'package:flutter_boilerplate/feature_more/pages/more_page.dart';
import 'package:flutter_boilerplate/feature_post/pages/posts_page.dart';
import 'package:flutter_boilerplate/feature_set_base_url/pages/set_base_url_page.dart';
import 'package:flutter_boilerplate/feature_splash/pages/splash_page.dart';
import 'package:flutter_boilerplate/feature_webview_about/pages/about_page.dart';
import 'package:flutter_boilerplate/feature_webview_about/pages/web_view_page.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/routes/route_observer.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/feature_course_details/pages/course_details_screen.dart';

class AppRouter {
  AppRouter._();

  static final AppRouteObserver routeObserver = AppRouteObserver();

  /// Get the router configuration
  static GoRouter getRouter({
    required Future<bool> Function() isLoggedIn,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      observers: [routeObserver],
      errorBuilder: (context, state) =>
          _buildErrorPage(context, state.error, state.uri.toString()),
      routes: <RouteBase>[
        // Splash Route
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashPage(),
        ),

        // Auth Routes
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.login,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LoginPage()),
        ),

        // Posts Routes (JSONPlaceholder CRUD demo)
        GoRoute(
          path: AppRoutes.courseDetails,
          name: AppRoutes.courseDetails,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CourseDetailsScreen()),
        ),
        GoRoute(
          path: AppRoutes.posts,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PostsPage()),
        ),

        // Set base URL screen (added on main)
        // Set Base URL Route (Connect to Moodle)
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SetBaseUrlPage()),
        ),

        // App Settings Route
        GoRoute(
          path: AppRoutes.appSettings,
          name: AppRoutes.appSettings,
          builder: (context, state) => const AppSettingsPage(),
        ),

        // About Route
        GoRoute(
          path: AppRoutes.about,
          name: AppRoutes.about,
          builder: (context, state) => const AboutPage(),
        ),

        // WebView Route — receives a `url` argument via state.extra.
        GoRoute(
          path: AppRoutes.webview,
          name: AppRoutes.webview,
          builder: (context, state) {
            final url = state.extra as String?;
            if (url == null || url.isEmpty) {
              return const _MissingWebViewUrlPage();
            }
            return WebViewPage(url: url);
          },
        ),

        // Dashboard Routes (from feature_dashboard)
        GoRoute(
          path: AppRoutes.dashboard,
          name: AppRoutes.dashboard,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DashboardPage()),
        ),
        GoRoute(
          path: AppRoutes.calendar,
          name: AppRoutes.calendar,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CalendarPage()),
        ),
        GoRoute(
          path: AppRoutes.availableCourses,
          name: AppRoutes.availableCourses,
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<DashboardCubit>(),
            child: const AvailableCoursesPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.myCourses,
          name: AppRoutes.myCourses,
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<DashboardCubit>(),
            child: const MyCoursesPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.messages,
          name: AppRoutes.messages,
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<DashboardCubit>(),
            child: const MessagesPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.notifications,
          name: AppRoutes.notifications,
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<DashboardCubit>(),
            child: const NotificationsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.userDetails,
          name: AppRoutes.userDetails,
          builder: (context, state) => const UserDetailsPage(),
        ),
        GoRoute(
          path: AppRoutes.details,
          name: AppRoutes.details,
          builder: (context, state) {
            final courseId = state.uri.queryParameters['courseId'];
            return DetailsPage(courseId: courseId);
          },
        ),
        GoRoute(
          path: AppRoutes.badges,
          name: AppRoutes.badges,
          builder: (context, state) => const BadgesPage(),
        ),
        GoRoute(
          path: AppRoutes.blogEntries,
          name: AppRoutes.blogEntries,
          builder: (context, state) => const BlogEntriesPage(),
        ),

        // More Route — uses the full feature_more implementation, not
        // feature_dashboard's placeholder MorePage.
        GoRoute(
          path: AppRoutes.more,
          name: AppRoutes.more,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MorePage()),
        ),
      ],
    );
  }

  /// Build error page for routing errors
  static Widget _buildErrorPage(
    BuildContext context,
    Exception? error,
    String location,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.labelError)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(AppStrings.errorNavigation),
            if (error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text('Back to Splash'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fallback page shown when [WebViewPage] is pushed without a URL.
class _MissingWebViewUrlPage extends StatelessWidget {
  /// Creates an instance of [_MissingWebViewUrlPage].
  const _MissingWebViewUrlPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop<void>(),
        ),
      ),
      body: const Center(
        child: Text('No URL provided for the WebView.'),
      ),
    );
  }
}
