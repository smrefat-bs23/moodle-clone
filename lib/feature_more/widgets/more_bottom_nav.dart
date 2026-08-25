import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Custom bottom navigation bar for the "More" screen.
///
/// Features fixed icons for Dashboard, Courses, Chat, Notifications, and More.
/// The "More" tab is highlighted with an orange top border indicator.
class MoreBottomNav extends StatelessWidget {
  /// Creates an instance of [MoreBottomNav].
  const MoreBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.moodleBorderGrey, width: 1.h),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: SizedBox(
            height: 56.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.speed,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.dashboard),
                ),
                _buildNavItem(
                  icon: Icons.school,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.myCourses),
                ),
                _buildNavItem(
                  icon: Icons.forum,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.messages),
                ),
                _buildNavItem(
                  icon: Icons.notifications,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.notifications),
                ),
                _buildNavItem(
                  icon: Icons.more_horiz,
                  isActive: true,
                  onTap: () {
                    // Current page
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds an individual navigation icon.
  ///
  /// If [isActive] is true, an orange top indicator is shown.
  Widget _buildNavItem({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            // Active indicator (orange top border)
            Container(
              height: 3.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.moodleOrange : Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(3.r),
                ),
              ),
            ),
            const Spacer(),
            Icon(
              icon,
              size: 24.r,
              color: isActive ? Colors.black : AppTheme.moodleMediumGrey,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
