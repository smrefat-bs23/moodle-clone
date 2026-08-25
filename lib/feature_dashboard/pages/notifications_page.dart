import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Placeholder for the Notifications bottom-nav destination.
///
/// The full notifications + preferences implementation will live on its
/// own branch (`feature/notifications-modular`). This page renders the
/// minimum visual scaffolding so the bottom-nav tap resolves cleanly.
class NotificationsPage extends StatelessWidget {
  /// Creates a [NotificationsPage].
  const NotificationsPage({super.key, this.embedded = false});

  /// Whether the page is rendered inside another [Scaffold].
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);

    if (embedded) {
      return ColoredBox(color: AppColors.background, child: body);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.h3.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: body,
    );
  }

  Widget _buildBody(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80.w,
              color: AppColors.grey300,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: safeSp(AppFontSize.lg),
                color: AppColors.grey600,
              ),
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              'You will be notified here when something new arrives.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: safeSp(AppFontSize.md),
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
