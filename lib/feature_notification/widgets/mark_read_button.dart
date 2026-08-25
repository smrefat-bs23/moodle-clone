import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class MarkReadButton extends StatelessWidget {
  const MarkReadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppSpacing.xxl.h * 2,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: context.screenWidth * .48,
          height: 42.h,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.visibility_outlined, size: AppSize.iconSm.sp),
            label: Text(
              AppStrings.markAllAsRead,
              style: context.textTheme.labelLarge?.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.onPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
              elevation: AppSize.elevationMd,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.radiusXl.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
