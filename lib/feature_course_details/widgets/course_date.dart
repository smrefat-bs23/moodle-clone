import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class CourseDate extends StatelessWidget {
  const CourseDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.calendar_today,
            size: 18.sp,
            color: context.colorScheme.onSurface,
          ),

          SizedBox(width: AppSpacing.sm.w),

          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: context.colorScheme.onSurface,
                  fontSize: 15.sp,
                ),
                children: [
                  TextSpan(
                    text: AppStrings.courseStartDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: AppStrings.courseStartTime,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}