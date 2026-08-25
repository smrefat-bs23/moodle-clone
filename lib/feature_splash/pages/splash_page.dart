import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Splash Screen for the Moodle Clone application.
///
/// Displays the official Moodle logo, then after a short delay decides
/// where to send the user based on persisted state:
///   - no saved site -> [AppRoutes.setBaseUrl]
///   - saved site, not logged in -> [AppRoutes.reconnect]
///   - saved site, logged in -> [AppRoutes.dashboard]
class SplashPage extends StatefulWidget {
  /// Creates an instance of [SplashPage].
  const SplashPage({required this.isLoggedIn, super.key});

  /// Checks whether a valid auth token is currently persisted.
  final Future<bool> Function() isLoggedIn;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<bool> _hasSite() async {
    final (siteUrl, _) =
        await di.getIt<LocalStorage>().get<String>(AppConstants.siteUrlKey);
    return siteUrl != null && siteUrl.isNotEmpty;
  }

  /// Navigates to the correct destination after a short splash delay,
  /// based on whether a site is saved and whether the user is logged in.
  Future<void> _navigateToNext() async {
    // Standard splash delay (3 seconds)
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (!await _hasSite()) {
      if (!mounted) return;
      context.go(AppRoutes.setBaseUrl);
      return;
    }

    if (!await widget.isLoggedIn()) {
      if (!mounted) return;
      context.go(AppRoutes.reconnect);
      return;
    }

    if (!mounted) return;
    context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          AppAssets.moodleSplashLogo,
          width: AppSize.splashLogoWidth.w,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.school,
            size: AppSize.splashLogoErrorSize.r,
            color: AppBrandColors.moodleOrange,
          ),
        ),
      ),
    );
  }
}
