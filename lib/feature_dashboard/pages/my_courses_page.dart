import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/course_list_item.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Lists the enrolled courses ("My Courses" bottom-nav destination).
///
/// When [embedded] is true the page is rendered inside the dashboard's
/// shell (the app-bar from the shell is reused). When false, the page
/// stands alone and provides its own [Scaffold] + back navigation.
class MyCoursesPage extends StatelessWidget {
  /// Creates a [MyCoursesPage].
  const MyCoursesPage({super.key, this.embedded = false});

  /// Whether the page is rendered inside another [Scaffold].
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);

    if (embedded) {
      return ColoredBox(color: AppColors.background, child: body);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'My Courses',
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.h3.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: body,
    );
  }

  Widget _buildBody(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) =>
          previous.courses != current.courses ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.status == DashboardStatus.loading &&
            state.courses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.courses.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 80.w,
                  color: AppColors.grey300,
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  'You are not enrolled in any course yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: safeSp(AppFontSize.lg),
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(AppSpacing.std.w),
          itemCount: state.courses.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md.h),
          itemBuilder: (context, index) {
            final course = state.courses[index];
            return CourseListItem(
              course: course,
              onTap: () => context.pushNamed(
                AppRoutes.details,
                queryParameters: {'courseId': course.id},
              ),
            );
          },
        );
      },
    );
  }
}
