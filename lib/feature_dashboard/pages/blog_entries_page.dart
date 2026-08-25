import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Page displaying blog entries of the user.
class BlogEntriesPage extends StatelessWidget {
  /// Creates a [BlogEntriesPage].
  const BlogEntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Blog entries',
          style: TextStyle(
            color: AppColors.black,
            fontSize: safeSp(AppFontSize.xxl),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 80.w,
              color: AppColors.grey300,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'No blog entries found',
              style: TextStyle(
                fontSize: safeSp(AppFontSize.lg),
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
