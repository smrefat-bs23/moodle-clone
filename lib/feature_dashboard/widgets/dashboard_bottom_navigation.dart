import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A bottom navigation bar widget for the dashboard.
class DashboardBottomNavigation extends StatelessWidget {
  /// Creates a [DashboardBottomNavigation].
  const DashboardBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) =>
          previous.bottomNavIndex != current.bottomNavIndex,
      builder: (context, state) {
        final cubit = context.read<DashboardCubit>();
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              top: BorderSide(color: AppColors.divider, width: 1.h),
            ),
          ),
          child: SafeArea(
            top: false,
            child: BottomNavigationBar(
              currentIndex:
                  DashboardNavTab.values.indexOf(state.bottomNavIndex),
              onTap: (index) => cubit.selectBottomNav(
                DashboardNavTab.values[index],
              ),
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.white,
              selectedItemColor: AppColors.black,
              unselectedItemColor: AppColors.grey700,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              items: [
                _buildNavItem(
                  activeIcon: Icons.speed,
                  inactiveIcon: Icons.speed_outlined,
                  isActive: state.bottomNavIndex ==
                      DashboardNavTab.dashboard,
                  safeSp: safeSp,
                ),
                _buildNavItem(
                  activeIcon: Icons.school,
                  inactiveIcon: Icons.school_outlined,
                  isActive: state.bottomNavIndex ==
                      DashboardNavTab.myCourses,
                  safeSp: safeSp,
                ),
                _buildNavItem(
                  activeIcon: Icons.chat_bubble,
                  inactiveIcon: Icons.chat_bubble_outline,
                  isActive: state.bottomNavIndex ==
                      DashboardNavTab.messages,
                  safeSp: safeSp,
                ),
                _buildNavItem(
                  activeIcon: Icons.notifications,
                  inactiveIcon: Icons.notifications_none,
                  isActive: state.bottomNavIndex ==
                      DashboardNavTab.notifications,
                  safeSp: safeSp,
                ),
                _buildNavItem(
                  activeIcon: Icons.more_horiz,
                  inactiveIcon: Icons.more_horiz,
                  isActive: state.bottomNavIndex == DashboardNavTab.more,
                  safeSp: safeSp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required bool isActive,
    required double Function(double) safeSp,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(top: AppSpacing.sm.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              size: safeSp(24),
              color: isActive ? AppColors.black : AppColors.grey700,
            ),
            const SizedBox(height: 4),
            Container(
              height: 3,
              width: 32,
              decoration: BoxDecoration(
                color:
                    isActive ? AppColors.moodleOrange : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
      label: '',
    );
  }
}
