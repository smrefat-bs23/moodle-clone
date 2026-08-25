import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/course_list_item.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Full-screen search results page launched from the dashboard header.
///
/// Searches the cubit's [DashboardState.availableCourses] and renders
/// matches as a list of [CourseListItem]s. When the search field is
/// empty, all courses are shown.
class SearchPage extends StatelessWidget {
  /// Creates a [SearchPage].
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (previous, current) =>
            previous.availableCourses != current.availableCourses,
        builder: (context, state) {
          return ListView.separated(
            padding: EdgeInsets.all(AppSpacing.std.w),
            itemCount: state.availableCourses.length,
            separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md.h),
            itemBuilder: (context, index) {
              final course = state.availableCourses[index];
              return CourseListItem(course: course);
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 0,
      title: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (previous, current) =>
            previous.availableCoursesSearch !=
            current.availableCoursesSearch,
        builder: (context, state) {
          final cubit = context.read<DashboardCubit>();
          return TextField(
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: cubit.changeAvailableCoursesSearch,
            style: TextStyle(
              fontSize: AppFontSize.lg.sp,
              color: AppColors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Search courses, people, …',
              hintStyle: TextStyle(
                color: AppColors.grey600,
                fontSize: AppFontSize.lg.sp,
              ),
              border: InputBorder.none,
            ),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () =>
              context.read<DashboardCubit>().changeAvailableCoursesSearch(''),
        ),
      ],
    );
  }
}
