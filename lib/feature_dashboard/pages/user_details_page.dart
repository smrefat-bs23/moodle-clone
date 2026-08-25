import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Page displaying details of a specific user.
class UserDetailsPage extends StatelessWidget {
  /// Creates a [UserDetailsPage].
  const UserDetailsPage({super.key});

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppSpacing.lg.h),
            _buildProfileHeader(safeSp),
            SizedBox(height: AppSpacing.xl.h),
            _buildActionButtons(context, safeSp),
            SizedBox(height: AppSpacing.lg.h),
            _buildMenuItems(context, safeSp),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(double Function(double) safeSp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45.r,
            backgroundColor: AppColors.grey100,
            child: Text(
              'AU',
              style: TextStyle(
                fontSize: safeSp(28),
                color: AppColors.grey700,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.lg.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin User',
                  style: TextStyle(
                    fontSize: safeSp(AppFontSize.h1),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black87,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  'Last access: 4 days ago',
                  style: TextStyle(
                    fontSize: safeSp(AppFontSize.lg),
                    color: AppColors.grey700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, double Function(double) safeSp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        children: [
          _buildButton(
            icon: Icons.send,
            label: 'Message',
            onPressed: () => context.pushNamed(AppRoutes.messages),
            safeSp: safeSp,
          ),
          SizedBox(height: AppSpacing.md.h),
          _buildButton(
            icon: Icons.email,
            label: 'Email',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compose email coming soon')),
              );
            },
            safeSp: safeSp,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required double Function(double) safeSp,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.moodleOrange,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: AppSize.iconSmMd.w),
            SizedBox(width: AppSpacing.sm.w),
            Text(
              label,
              style: TextStyle(
                color: AppColors.white,
                fontSize: safeSp(AppFontSize.xl),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, double Function(double) safeSp) {
    return Column(
      children: [
        _buildListTile(
          icon: Icons.person,
          title: 'Details',
          onTap: () => context.pushNamed(AppRoutes.details),
          safeSp: safeSp,
        ),
        _buildListTile(
          icon: Icons.emoji_events,
          title: 'Badges',
          onTap: () => context.pushNamed(AppRoutes.badges),
          safeSp: safeSp,
        ),
        _buildListTile(
          icon: Icons.article_outlined,
          title: 'Blog entries',
          onTap: () => context.pushNamed(AppRoutes.blogEntries),
          safeSp: safeSp,
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double Function(double) safeSp,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey800, size: AppSize.iconLg.w),
      title: Text(
        title,
        style: TextStyle(
          fontSize: safeSp(AppFontSize.xl),
          color: AppColors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.black54,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.xs.h,
      ),
    );
  }
}
