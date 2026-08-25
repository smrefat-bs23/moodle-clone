import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Course detail page shown when a user taps a course from the
/// Available Courses list. Surfaces the purple hero, title, category,
/// teachers list, course compliance, and an info banner when the
/// current user cannot self-enrol.
class DetailsPage extends StatelessWidget {
  /// Creates a [DetailsPage] optionally bound to a [courseId] passed
  /// through go_router state.
  const DetailsPage({super.key, this.courseId});

  /// Optional id of the course to display. When null, the first
  /// available course from the cubit is used as a fallback.
  final String? courseId;

  @override
  Widget build(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) =>
          previous.availableCourses != current.availableCourses,
      builder: (context, state) {
        final course = _resolveCourse(state);

        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              _buildHero(context, course, safeSp),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.lg.h),
                      _buildTitleBlock(context, course, safeSp),
                      SizedBox(height: AppSpacing.lg.h),
                      _buildSectionLabel('Teachers', safeSp),
                      SizedBox(height: AppSpacing.sm.h),
                      _buildTeacherRow(context, course, safeSp),
                      Divider(height: AppSpacing.lg.h),
                      _buildComplianceRow(course, safeSp),
                      Divider(height: AppSpacing.lg.h),
                    ],
                  ),
                ),
              ),
              if (course.selfEnrolBlocked)
                _buildInfoBanner(safeSp),
            ],
          ),
        );
      },
    );
  }

  CourseEntity _resolveCourse(DashboardState state) {
    if (courseId != null) {
      final match = state.availableCourses
          .where((c) => c.id == courseId)
          .cast<CourseEntity?>()
          .firstWhere((_) => true, orElse: () => null);
      if (match != null) return match;
    }
    return state.availableCourses.isNotEmpty
        ? state.availableCourses.first
        : const CourseEntity(
            id: 'c4',
            title: 'AIDLC - New way of implementation',
            category: 'Category 1',
            imageUrl: '',
            progress: 0,
            isEnrolled: false,
            isLocked: true,
            selfEnrolBlocked: true,
          );
  }

  Widget _buildHero(
    BuildContext context,
    CourseEntity course,
    double Function(double) safeSp,
  ) {
    return Stack(
      children: [
        Container(
          height: 220.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.courseHeroPurple,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          left: AppSpacing.md.w,
          child: CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.black),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md.h),
              child: Icon(
                Icons.school_outlined,
                size: 130.w,
                color: AppColors.white.withValues(alpha: 0.45),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleBlock(
    BuildContext context,
    CourseEntity course,
    double Function(double) safeSp,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          style: TextStyle(
            fontSize: safeSp(AppFontSize.h2),
            fontWeight: FontWeight.w400,
            color: AppColors.black87,
            height: 1.2,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: AppSpacing.xs.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.moodleLightOrange,
            borderRadius: BorderRadius.circular(AppSize.radiusFull.r),
          ),
          child: Text(
            course.category,
            style: TextStyle(
              fontSize: safeSp(AppFontSize.md),
              color: AppColors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label, double Function(double) safeSp) {
    return Text(
      label,
      style: TextStyle(
        fontSize: safeSp(AppFontSize.lg),
        fontWeight: FontWeight.w400,
        color: AppColors.black87,
      ),
    );
  }

  Widget _buildTeacherRow(
    BuildContext context,
    CourseEntity course,
    double Function(double) safeSp,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 22.r,
        backgroundColor: AppColors.grey200,
        child: Text(
          course.teacherInitials,
          style: TextStyle(
            fontSize: safeSp(AppFontSize.md),
            color: AppColors.grey700,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      title: Text(
        course.teacherName,
        style: TextStyle(
          fontSize: safeSp(AppFontSize.lg),
          color: AppColors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.black54),
      onTap: () => context.pushNamed(AppRoutes.userDetails),
    );
  }

  Widget _buildComplianceRow(
    CourseEntity course,
    double Function(double) safeSp,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course compliance:',
            style: TextStyle(
              fontSize: safeSp(AppFontSize.lg),
              fontWeight: FontWeight.bold,
              color: AppColors.black87,
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              course.courseCompliance,
              style: TextStyle(
                fontSize: safeSp(AppFontSize.lg),
                fontWeight: FontWeight.w400,
                color: AppColors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(double Function(double) safeSp) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        0,
        AppSpacing.lg.w,
        AppSpacing.lg.h,
      ),
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.infoBannerBlue,
        borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: const BoxDecoration(
              color: AppColors.infoBannerIcon,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppColors.white,
              size: 18,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              'You cannot enrol yourself in this course.',
              style: TextStyle(
                fontSize: safeSp(AppFontSize.lg),
                color: AppColors.infoBannerText,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}