import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/timeline_activity_grid_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A card widget that displays a timeline of activities.
class TimelineCard extends StatelessWidget {
  /// Creates a [TimelineCard].
  const TimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.std.w,
        vertical: AppSpacing.md.h,
      ),
      padding: EdgeInsets.all(AppSpacing.std.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.radiusLg.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline',
            style: TextStyle(
              fontSize: safeSp(AppFontSize.xl),
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: AppSpacing.std.h),
          _buildSearchField(context, safeSp),
          SizedBox(height: AppSpacing.md.h),
          _buildFilterRow(context, safeSp),
          SizedBox(height: AppSpacing.lg.h),
          BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              final visible = _filter(state);
              if (visible.isEmpty) {
                return _buildEmptyState(safeSp);
              }
              if (state.timelineViewMode == TimelineViewMode.grid) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    return TimelineActivityGridCard(activity: visible[index]);
                  },
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < visible.length; i++) ...[
                    if (i > 0) Divider(height: AppSpacing.lg.h),
                    _buildTimelineRow(context, visible[i], safeSp),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<TimelineActivityEntity> _filter(DashboardState state) {
    final query = state.timelineSearch.trim().toLowerCase();
    final now = DateTime.now();
    final list = state.timelineActivities.where((a) {
      switch (state.timelineFilterType) {
        case TimelineFilterType.all:
          return true;
        case TimelineFilterType.overdue:
          return a.dueDate.isBefore(now);
        case TimelineFilterType.next7Days:
          return a.dueDate.isAfter(now) &&
              a.dueDate.isBefore(now.add(const Duration(days: 7)));
        case TimelineFilterType.next30Days:
          return a.dueDate.isAfter(now) &&
              a.dueDate.isBefore(now.add(const Duration(days: 30)));
        case TimelineFilterType.next3Months:
          return a.dueDate.isAfter(now) &&
              a.dueDate.isBefore(now.add(const Duration(days: 90)));
        case TimelineFilterType.next6Months:
          return a.dueDate.isAfter(now) &&
              a.dueDate.isBefore(now.add(const Duration(days: 180)));
      }
    }).toList();
    if (query.isEmpty) return list;
    return list
        .where(
          (a) =>
              a.name.toLowerCase().contains(query) ||
              a.type.toLowerCase().contains(query),
        )
        .toList();
  }

  Widget _buildSearchField(
    BuildContext context,
    double Function(double) safeSp,
  ) {
    final cubit = context.read<DashboardCubit>();
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) =>
          previous.timelineSearch != current.timelineSearch,
      builder: (context, state) {
        return Container(
          height: 44.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
            border: Border.all(color: AppColors.black87, width: 1),
          ),
          child: Row(
            children: [
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: TextField(
                  onChanged: cubit.changeTimelineSearch,
                  style: TextStyle(fontSize: safeSp(AppFontSize.md)),
                  decoration: InputDecoration(
                    hintText: 'Search by activity type or name',
                    hintStyle: TextStyle(
                      color: AppColors.grey600,
                      fontSize: safeSp(AppFontSize.md),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppSpacing.md.h,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.search,
                color: AppColors.grey800,
                size: safeSp(AppSize.iconMd - 2),
              ),
              if (state.timelineSearch.isNotEmpty) ...[
                SizedBox(width: AppSpacing.sm.w),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => cubit.changeTimelineSearch(''),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius:
                          BorderRadius.circular(AppSize.radiusSm.r),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.grey800,
                      size: safeSp(AppFontSize.md),
                    ),
                  ),
                ),
              ],
              SizedBox(width: AppSpacing.md.w),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterRow(BuildContext context, double Function(double) safeSp) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) =>
          previous.timelineSortType != current.timelineSortType ||
          previous.timelineFilterType != current.timelineFilterType ||
          previous.timelineViewMode != current.timelineViewMode,
      builder: (context, state) {
        return Row(
          children: [
            Theme(
              data: ThemeData(
                brightness: Brightness.light,
                canvasColor: AppColors.white,
                cardColor: AppColors.white,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                dialogTheme: const DialogThemeData(
                  backgroundColor: AppColors.white,
                  surfaceTintColor: AppColors.white,
                ),
              ),
              child: PopupMenuButton<TimelineFilterType>(
                padding: EdgeInsets.zero,
                offset: Offset(0, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
                ),
                onSelected: (TimelineFilterType result) {
                  context
                      .read<DashboardCubit>()
                      .changeTimelineFilterType(result);
                },
                itemBuilder: (BuildContext context) => [
                  _buildFilterMenuItem(
                    TimelineFilterType.all,
                    state.timelineFilterType,
                    safeSp,
                  ),
                  _buildFilterMenuItem(
                    TimelineFilterType.overdue,
                    state.timelineFilterType,
                    safeSp,
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<TimelineFilterType>(
                    enabled: false,
                    height: 32.h,
                    child: Text(
                      'Due date',
                      style: TextStyle(
                        fontSize: safeSp(AppFontSize.label),
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildFilterMenuItem(
                    TimelineFilterType.next7Days,
                    state.timelineFilterType,
                    safeSp,
                  ),
                  _buildFilterMenuItem(
                    TimelineFilterType.next30Days,
                    state.timelineFilterType,
                    safeSp,
                  ),
                  _buildFilterMenuItem(
                    TimelineFilterType.next3Months,
                    state.timelineFilterType,
                    safeSp,
                  ),
                  _buildFilterMenuItem(
                    TimelineFilterType.next6Months,
                    state.timelineFilterType,
                    safeSp,
                  ),
                ],
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
                    border: Border.all(color: AppColors.black87, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.timelineFilterType.label,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: safeSp(AppFontSize.md),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs.w),
                      Icon(
                        Icons.expand_more_rounded,
                        size: safeSp(20),
                        color: AppColors.black87,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Theme(
              data: ThemeData(
                brightness: Brightness.light,
                canvasColor: AppColors.white,
                cardColor: AppColors.white,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                dialogTheme: const DialogThemeData(
                  backgroundColor: AppColors.white,
                  surfaceTintColor: AppColors.white,
                ),
              ),
              child: PopupMenuButton<TimelineSortType>(
                padding: EdgeInsets.zero,
                offset: Offset(0, 44.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
                ),
                onSelected: (TimelineSortType result) {
                  context.read<DashboardCubit>().changeTimelineSortType(result);
                },
                itemBuilder: (BuildContext context) => [
                  _buildSortMenuItem(
                    TimelineSortType.dates,
                    state.timelineSortType,
                    'Sort by dates',
                    safeSp,
                  ),
                  _buildSortMenuItem(
                    TimelineSortType.courses,
                    state.timelineSortType,
                    'Sort by courses',
                    safeSp,
                  ),
                ],
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
                    border: Border.all(color: AppColors.black87, width: 1),
                  ),
                  child: Icon(
                    Icons.sort_rounded,
                    color: AppColors.black87,
                    size: safeSp(AppSize.iconSmMd),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.xs.w),
            _buildViewModeButton(context, state, safeSp),
          ],
        );
      },
    );
  }

  /// Static icon button that toggles the timeline between list and grid
  /// layouts. The icon shows the *destination* view, so when the timeline
  /// is in list mode the icon is the grid glyph (tap to switch to grid),
  /// and vice versa.
  Widget _buildViewModeButton(
    BuildContext context,
    DashboardState state,
    double Function(double) safeSp,
  ) {
    final cubit = context.read<DashboardCubit>();
    final isList = state.timelineViewMode == TimelineViewMode.list;
    final icon =
        isList ? Icons.grid_view_rounded : Icons.view_list_rounded;
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
      child: InkWell(
        onTap: () => cubit.changeTimelineViewMode(
          isList ? TimelineViewMode.grid : TimelineViewMode.list,
        ),
        borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
        child: Container(
          width: 44.w,
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
            border: Border.all(color: AppColors.black87, width: 1),
          ),
          child: Icon(
            icon,
            color: AppColors.black87,
            size: safeSp(AppSize.iconSmMd),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<TimelineFilterType> _buildFilterMenuItem(
    TimelineFilterType value,
    TimelineFilterType currentSelection,
    double Function(double) safeSp,
  ) {
    final isSelected = value == currentSelection;
    return PopupMenuItem<TimelineFilterType>(
      value: value,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.std.w,
          vertical: AppSpacing.md.h,
        ),
        color: isSelected ? AppColors.moodleLightOrange : null,
        child: Text(
          value.label,
          style: TextStyle(
            fontSize: safeSp(AppFontSize.md),
            color: AppColors.black87,
          ),
        ),
      ),
    );
  }

  PopupMenuItem<TimelineSortType> _buildSortMenuItem(
    TimelineSortType value,
    TimelineSortType currentSelection,
    String label,
    double Function(double) safeSp,
  ) {
    final isSelected = value == currentSelection;
    return PopupMenuItem<TimelineSortType>(
      value: value,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.std.w,
          vertical: AppSpacing.md.h,
        ),
        color: isSelected ? AppColors.moodleLightOrange : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: safeSp(AppFontSize.md),
            color: AppColors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineRow(
    BuildContext context,
    TimelineActivityEntity activity,
    double Function(double) safeSp,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.moodleLightOrange,
            borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
          ),
          child: Icon(
            Icons.assignment_outlined,
            size: safeSp(AppSize.iconMd),
            color: AppColors.moodleOrange,
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.name,
                style: TextStyle(
                  fontSize: safeSp(AppFontSize.md),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${activity.type} • due in '
                '${activity.dueDate.difference(DateTime.now()).inDays.abs()} '
                'days',
                style: TextStyle(
                  fontSize: safeSp(AppFontSize.sm),
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(double Function(double) safeSp) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.archive_outlined,
              size: 96.w,
              color: AppColors.grey300,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'No activities require action',
              style: TextStyle(
                color: AppColors.grey800,
                fontSize: safeSp(AppFontSize.lg),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
