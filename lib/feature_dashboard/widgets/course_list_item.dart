import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable list item representing a course row in the Available Courses
/// list, My Courses screen, and search results.
///
/// The card surfaces the course thumbnail, title, optional category chip and
/// an optional lock icon. Tapping the lock toggles the locked state via
/// [onToggleLock] when supplied.
class CourseListItem extends StatelessWidget {
  /// Creates a [CourseListItem].
  const CourseListItem({
    required this.course,
    this.onTap,
    this.onToggleLock,
    super.key,
  });

  /// Course entity to render.
  final CourseEntity course;

  /// Tap callback for the row body.
  final VoidCallback? onTap;

  /// Optional callback when the lock indicator is tapped.
  final ValueChanged<String>? onToggleLock;

  @override
  Widget build(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.radiusLg.r),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSize.radiusLg.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(safeSp),
            SizedBox(width: AppSpacing.md.w),
            Expanded(child: _buildBody(safeSp)),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(double Function(double) safeSp) {
    if (course.imageUrl.isEmpty) {
      return Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          color: const Color(0xFFB6B0FB),
          borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
        ),
        child: Icon(
          Icons.school_outlined,
          color: AppColors.white,
          size: safeSp(AppSize.iconLg),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
      child: Image.network(
        course.imageUrl,
        width: 64.w,
        height: 64.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: const Color(0xFFB6B0FB),
            borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
          ),
          child: Icon(
            Icons.school_outlined,
            color: AppColors.white,
            size: safeSp(AppSize.iconLg),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(double Function(double) safeSp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                course.title,
                style: TextStyle(
                  fontSize: safeSp(AppFontSize.lg),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                  height: 1.25,
                ),
              ),
            ),
            InkResponse(
              onTap:
                  onToggleLock == null ? null : () => onToggleLock!(course.id),
              radius: 22,
              child: SizedBox(
                width: 44.w,
                height: 44.h,
                child: Center(
                  child: Icon(
                    course.isLocked
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                    size: safeSp(AppSize.iconSmMd),
                    color: course.isLocked
                        ? AppColors.grey700
                        : AppColors.grey400,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
            vertical: AppSpacing.xs.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.moodleLightOrange,
            borderRadius: BorderRadius.circular(AppSize.radiusFull.r),
          ),
          child: Text(
            course.category,
            style: TextStyle(
              fontSize: safeSp(AppFontSize.sm),
              color: AppColors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
