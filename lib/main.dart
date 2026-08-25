import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/error_boundary/error_boundary_export.dart';
import 'package:flutter_boilerplate/routes/app_router.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Flavor
    try {
      FlavorConfig.instance;
    } catch (_) {
      FlavorConfig.instance = FlavorConfig.dev();
    }

    // Initialize logger
    AppLogger.init();

    // Initialize dependency injection
    // This also initializes Hive and pre-resolves SharedPreferences
    await di.configureDependencies();

    // Set bloc observer for debugging
    Bloc.observer = SimpleBlocObserver();

    runApp(const MyApp());
  } catch (error, stackTrace) {
    debugPrint('Fatal initialization error: $error\n$stackTrace');
    runApp(ErrorScreen(
      error: error.toString(),
      stackTrace: stackTrace.toString(),
    ));
  }
}

/// Main app widget
class MyApp extends StatelessWidget {
  /// Main app widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      onError: (error, stackTrace) {
        AppLogger.e('Uncaught error', error, stackTrace);
      },
      child: ScreenUtilInit(
        designSize: const Size(AppSize.designWidth, AppSize.designHeight),
        minTextAdapt: true,
        splitScreenMode: true,
        // This is the key to preventing fontSize: 0 crash
        ensureScreenSize: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: FlavorConfig.instance.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            routerConfig: AppRouter.getRouter(
              isLoggedIn: () async {
                try {
                  final (token, _) = await di.getIt<LocalStorage>()
                      .get<String>(AppConstants.tokenKey);
                  return token != null && token.isNotEmpty;
                } catch (_) {
                  return false;
                }
              },
            ),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.noScaling),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
