import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Compact card variant of a timeline activity, used when the timeline is in
/// grid view mode. Renders an orange icon disc at the top with the activity
/// title and subtitle stacked below it. Designed for a 2-column grid.
class TimelineActivityGridCard extends StatelessWidget {
  /// Creates a [TimelineActivityGridCard].
  const TimelineActivityGridCard({
    required this.activity,
    this.onTap,
    super.key,
  });

  /// The timeline activity to render.
  final TimelineActivityEntity activity;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.sm.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.moodleLightOrange,
                  borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
                ),
                child: Icon(
                  _iconForActivityType(activity.type),
                  size: safeSp(AppSize.iconSmMd),
                  color: AppColors.moodleOrange,
                ),
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                activity.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: safeSp(AppFontSize.sm),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                _subtitle(activity),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: safeSp(AppFontSize.sm),
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForActivityType(String type) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return Icons.quiz_outlined;
      case 'lesson':
        return Icons.menu_book_outlined;
      case 'forum':
        return Icons.forum_outlined;
      default:
        return Icons.assignment_outlined;
    }
  }

  String _subtitle(TimelineActivityEntity a) {
    final days = a.dueDate.difference(DateTime.now()).inDays.abs();
    return '${a.type} \u2022 due in $days day${days == 1 ? '' : 's'}';
  }
}
