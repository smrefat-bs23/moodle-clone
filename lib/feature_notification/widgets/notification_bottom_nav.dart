import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class NotificationBottomNav extends StatelessWidget {
  const NotificationBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3,
      type: BottomNavigationBarType.fixed,
      backgroundColor: context.colorScheme.surface,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0.sp,
      unselectedFontSize: 0.sp,
      selectedItemColor: context.colorScheme.primary,
      unselectedItemColor: context.colorScheme.outline,
      elevation: AppSize.elevationLg,
      onTap: (_) {},
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: AppStrings.empty,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_outlined),
          activeIcon: const Icon(Icons.dashboard),
          label: AppStrings.empty,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_bubble_outline),
          activeIcon: const Icon(Icons.chat),
          label: AppStrings.empty,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications, color: context.colorScheme.primary),
          activeIcon: Icon(
            Icons.notifications,
            color: context.colorScheme.primary,
          ),
          label: AppStrings.empty,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.more_horiz),
          activeIcon: const Icon(Icons.more_horiz),
          label: AppStrings.empty,
        ),
      ],
    );
  }
}
