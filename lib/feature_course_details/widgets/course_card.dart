import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_boilerplate/feature_course_details/widgets/course_date.dart';
import 'package:flutter_boilerplate/feature_course_details/widgets/course_progress.dart';
import 'package:flutter_boilerplate/feature_course_details/widgets/course_summary.dart';
import 'package:flutter_boilerplate/feature_course_details/widgets/teacher_tile.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * .68,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorScheme.onInverseSurface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26.r),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.courseTitle,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  color: context.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: AppSpacing.sm.h),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  AppStrings.courseCategory,
                  style: TextStyle(
                    color: context.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),

              SizedBox(height: 22.h),

              const CourseProgress(),

              const CourseDate(),

              const CourseSummary(),

              const TeacherTile(),
            ],
          ),
        ),
      ),
    );
  }
}