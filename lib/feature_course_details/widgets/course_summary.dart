import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class CourseSummary extends StatelessWidget {
  const CourseSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.lg.h),

        Text(
          AppStrings.courseSummary,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
            color: context.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: AppSpacing.sm.h),

        Text(
          AppStrings.courseDescription,
          style: TextStyle(
            fontSize: 15.sp,
            height: 1.5,
            color: context.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}