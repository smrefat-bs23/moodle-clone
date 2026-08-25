import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Placeholder for the Messages bottom-nav destination.
///
/// A full Messages implementation will live on its own branch
/// (`feature/messages-modular`). This page provides the minimum visual
/// scaffolding so that the bottom-nav tap resolves to a navigable route.
class MessagesPage extends StatelessWidget {
  /// Creates a [MessagesPage].
  const MessagesPage({super.key, this.embedded = false});

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
          'Messages',
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
              Icons.chat_bubble_outline,
              size: 80.w,
              color: AppColors.grey300,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'No conversations yet',
              style: TextStyle(
                fontSize: safeSp(AppFontSize.lg),
                color: AppColors.grey600,
              ),
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              'Messages will appear here once the feature ships.',
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
