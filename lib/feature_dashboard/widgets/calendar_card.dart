import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// A card widget that displays a "Calendar" label with a chevron icon.
class CalendarCard extends StatelessWidget {
  /// Creates a [CalendarCard].
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.calendar),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppSpacing.std.w),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.std.w,
          vertical: 18.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSize.radiusLg.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Text(
              'Calendar',
              style: TextStyle(
                fontSize: AppFontSize.xl.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black87,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: AppColors.grey600,
              size: AppSize.iconMd.sp,
            ),
          ],
        ),
      ),
    );
  }
}
