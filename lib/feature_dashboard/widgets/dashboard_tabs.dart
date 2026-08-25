import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A widget that displays tabs for the dashboard (e.g., Dashboard, Site home).
class DashboardTabs extends StatelessWidget {
  /// Creates a [DashboardTabs].
  const DashboardTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final selectedIndex = state.selectedTabIndex;

        return ColoredBox(
          color: AppColors.white,
          child: Row(
            children: [
              _TabItem(
                title: 'Dashboard',
                isActive: selectedIndex == 0,
                onTap: () => context.read<DashboardCubit>().selectTab(0),
              ),
              _TabItem(
                title: 'Site home',
                isActive: selectedIndex == 1,
                onTap: () => context.read<DashboardCubit>().selectTab(1),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: AppFontSize.tab.sp,
      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
      color: isActive ? AppColors.black87 : AppColors.grey700,
    );
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Wrap text + underline together so the underline widths itself
            // to the text. IntrinsicWidth inside Expanded is fine: it sizes
            // the inner Column to the text's intrinsic width, and the
            // Expanded lets the outer InkWell still fill the tab cell.
            IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Text(title, style: textStyle),
                  ),
                  // Underline at ~60% of the text width, centered. This
                  // matches the design where "Dashboard" gets a short bar
                  // and "Site home" gets a longer one (both ~60% of their
                  // label widths).
                  SizedBox(
                    height: 3.h,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      alignment: Alignment.center,
                      child: Container(
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.moodleOrange
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.r),
                            topRight: Radius.circular(3.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
