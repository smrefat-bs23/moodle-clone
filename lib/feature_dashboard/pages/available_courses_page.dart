import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/course_list_item.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Full Available Courses page reachable from the Site-home card.
class AvailableCoursesPage extends StatelessWidget {
  /// Creates an [AvailableCoursesPage].
  const AvailableCoursesPage({super.key});

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.radiusLg.r),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Refresh'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context
                      .read<DashboardCubit>()
                      .fetchDashboardCourses();
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text('Sort by name'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sort by name coming soon')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download_outlined),
                title: const Text('Download all for offline'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Offline downloads coming soon'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Available courses',
          style: TextStyle(
            color: AppColors.black,
            fontSize: safeSp(AppFontSize.h3),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.black),
            onPressed: () => _showMoreActions(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.std.w),
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            final filtered = _filter(state);
            final hasActiveFilter = state.availableCoursesSearch.isNotEmpty ||
                state.onlyMyCourses;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchField(context, state, safeSp),
                SizedBox(height: AppSpacing.md.h),
                _buildShowOnlyMyCoursesRow(context, state, safeSp),
                SizedBox(height: AppSpacing.lg.h),
                if (filtered.isEmpty)
                  _buildEmptyState(hasActiveFilter, safeSp)
                else
                  Column(
                    children: [
                      for (var i = 0; i < filtered.length; i++) ...[
                        if (i > 0) SizedBox(height: AppSpacing.md.h),
                        CourseListItem(
                          course: filtered[i],
                          onTap: () => context.pushNamed(
                            AppRoutes.details,
                            queryParameters: {'courseId': filtered[i].id},
                          ),
                          onToggleLock: (id) => context
                              .read<DashboardCubit>()
                              .toggleCourseLock(id),
                        ),
                      ],
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<CourseEntity> _filter(DashboardState state) {
    final query = state.availableCoursesSearch.trim().toLowerCase();
    var list = state.availableCourses;
    if (state.onlyMyCourses) {
      list = list.where((c) => c.isEnrolled).toList();
    }
    if (query.isNotEmpty) {
      list = list
          .where(
            (c) =>
                c.title.toLowerCase().contains(query) ||
                c.category.toLowerCase().contains(query),
          )
          .toList();
    }
    return list;
  }

  Widget _buildSearchField(
    BuildContext context,
    DashboardState state,
    double Function(double) safeSp,
  ) {
    final cubit = context.read<DashboardCubit>();
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: TextField(
              onChanged: cubit.changeAvailableCoursesSearch,
              style: TextStyle(fontSize: safeSp(AppFontSize.md)),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: AppColors.grey600,
                  fontSize: safeSp(AppFontSize.md),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Icon(
            Icons.search,
            color: AppColors.grey600,
            size: safeSp(AppSize.iconMdLg),
          ),
          if (state.availableCoursesSearch.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => cubit.changeAvailableCoursesSearch(''),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
                child: Icon(
                  Icons.backspace_outlined,
                  color: AppColors.grey600,
                  size: safeSp(AppSize.iconSmMd),
                ),
              ),
            ),
          SizedBox(width: AppSpacing.md.w),
        ],
      ),
    );
  }

  Widget _buildShowOnlyMyCoursesRow(
    BuildContext context,
    DashboardState state,
    double Function(double) safeSp,
  ) {
    final cubit = context.read<DashboardCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Show only my courses',
          style: TextStyle(
            fontSize: safeSp(AppFontSize.lg),
            color: AppColors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        Switch(
          value: state.onlyMyCourses,
          onChanged: cubit.toggleOnlyMyCourses,
          activeThumbColor: AppColors.moodleOrange,
          activeTrackColor:
              AppColors.moodleOrange.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    bool isSearchResult,
    double Function(double) safeSp,
  ) {
    final icon = isSearchResult ? Icons.search : Icons.school_outlined;
    final message =
        isSearchResult ? 'No results' : 'No course information to show.';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              icon,
              size: 96.w,
              color: AppColors.grey300,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              message,
              style: TextStyle(
                fontSize: safeSp(AppFontSize.lg),
                color: AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
