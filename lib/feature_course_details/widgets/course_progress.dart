import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class CourseProgress extends StatelessWidget {
  const CourseProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: LinearProgressIndicator(
                  value: .27,
                  minHeight: 8.h,
                  color: context.colorScheme.primary,
                  backgroundColor:
                  context.colorScheme.primary.withValues(alpha: .15),
                ),
              ),
            ),

            SizedBox(width: AppSpacing.sm.w),

            Text(
              AppStrings.progress,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            )
          ],
        ),

        SizedBox(height: 18.h),
      ],
    );
  }
}