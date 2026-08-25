import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/search_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/user_account_overlay.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A custom header widget for the dashboard.
class DashboardHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [DashboardHeader].
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper to ensure font size is always > 0.
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      title: Text(
        'eLearning23',
        style: TextStyle(
          color: AppColors.black,
          fontSize: safeSp(AppFontSize.h3),
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: AppColors.black87,
            size: AppSize.iconMdLg.w,
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const SearchPage(),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showGeneralDialog<void>(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'UserAccount',
              barrierColor: AppColors.barrier,
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (
                BuildContext context,
                Animation<double> anim1,
                Animation<double> anim2,
              ) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: const UserAccountOverlay(),
                  ),
                );
              },
              transitionBuilder: (
                BuildContext context,
                Animation<double> anim1,
                Animation<double> anim2,
                Widget child,
              ) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(anim1),
                  child: child,
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: AppSpacing.std.w,
              left: AppSpacing.xs.w,
            ),
            child: CircleAvatar(
              radius: AppSize.radiusXl.r,
              backgroundColor: AppColors.grey300,
              child: Text(
                'SU',
                style: TextStyle(
                  color: AppColors.grey700,
                  fontWeight: FontWeight.w500,
                  fontSize: safeSp(AppFontSize.sm),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}
