import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Overlay widget that displays user account information and menu options.
class UserAccountOverlay extends StatelessWidget {
  /// Creates a [UserAccountOverlay].
  const UserAccountOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'User account',
          style: TextStyle(
            color: AppColors.black,
            fontSize: safeSp(AppFontSize.xxl),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: AppColors.black,
              size: AppSize.iconMdLg.w,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppSpacing.lg.h),
            // Moodle Logo and Site Info
            Center(
              child: Column(
                children: [
                  Image.network(
                    'https://download.moodle.org/logo/moodle-logo-rgb.png',
                    height: 40.h,
                    errorBuilder: (context, error, stackTrace) => Text(
                      'moodle',
                      style: TextStyle(
                        fontSize: safeSp(AppFontSize.h1),
                        fontWeight: FontWeight.bold,
                        color: AppColors.moodleOrange,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    'eLearning23',
                    style: TextStyle(
                      fontSize: safeSp(AppFontSize.xl),
                      fontWeight: FontWeight.w500,
                      color: AppColors.black87,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    'https://lmsmobile.ahnafmuttaki.com',
                    style: TextStyle(
                      fontSize: safeSp(AppFontSize.md),
                      color: AppColors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            // User Info - Leads to User Details Page
            _buildListTile(
              context: context,
              leading: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.grey100,
                child: Text(
                  'SU',
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: safeSp(AppFontSize.md),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: 'Student User',
              safeSp: safeSp,
              onTap: () {
                Navigator.of(context).pop(); // Close overlay
                context.pushNamed(AppRoutes.userDetails);
              },
            ),
            const Divider(height: 1, color: AppColors.divider),
            // Menu Items
            _buildListTile(
              context: context,
              leading: Icon(
                Icons.format_list_bulleted,
                size: AppSize.iconMd.w,
                color: AppColors.grey700,
              ),
              title: 'Grades',
              safeSp: safeSp,
            ),
            _buildListTile(
              context: context,
              leading: Icon(
                Icons.folder_outlined,
                size: AppSize.iconMd.w,
                color: AppColors.grey700,
              ),
              title: 'Files',
              safeSp: safeSp,
            ),
            _buildListTile(
              context: context,
              leading: Icon(
                Icons.grid_view_outlined,
                size: AppSize.iconMd.w,
                color: AppColors.grey700,
              ),
              title: 'Reports',
              safeSp: safeSp,
            ),
            _buildListTile(
              context: context,
              leading: Icon(
                Icons.emoji_events_outlined,
                size: AppSize.iconMd.w,
                color: AppColors.grey700,
              ),
              title: 'Badges',
              safeSp: safeSp,
              onTap: () {
                Navigator.of(context).pop(); // Close overlay
                context.pushNamed(AppRoutes.badges);
              },
            ),
            _buildListTile(
              context: context,
              leading: Icon(
                Icons.contact_page_outlined,
                size: AppSize.iconMd.w,
                color: AppColors.grey700,
              ),
              title: 'Blog entries',
              safeSp: safeSp,
              onTap: () {
                Navigator.of(context).pop(); // Close overlay
                context.pushNamed(AppRoutes.blogEntries);
              },
            ),
            _buildListTile(
              context: context,
              leading: Icon(
                Icons.build_outlined,
                size: AppSize.iconMd.w,
                color: AppColors.grey700,
              ),
              title: 'Preferences',
              safeSp: safeSp,
            ),
            _buildListTile(
              context: context,
              leading: Icon(
                Icons.email_outlined,
                size: AppSize.iconMd.w,
                color: AppColors.grey700,
              ),
              title: 'Contact site support',
              trailing: Icon(
                Icons.open_in_new,
                size: AppSpacing.lg.w - 4,
                color: AppColors.grey500,
              ),
              safeSp: safeSp,
            ),
            SizedBox(height: AppSpacing.lg.h),
            const Divider(height: 1, color: AppColors.divider),
            _buildListTile(
              context: context,
              leading: Icon(
                Icons.swap_horiz,
                size: AppSize.iconMd.w,
                color: AppColors.grey700,
              ),
              title: 'Switch account',
              safeSp: safeSp,
            ),
            SizedBox(height: AppSpacing.xl.h),
            // Logout Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w - 4),
              child: ElevatedButton(
                onPressed: () =>
                    _showNotImplemented(context, 'Log out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: AppColors.white,
                      size: AppSpacing.lg.w - 4,
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    Text(
                      'Log out',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: safeSp(AppFontSize.lg),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xxl.h),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required Widget leading,
    required String title,
    required double Function(double) safeSp,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontSize: safeSp(AppFontSize.lg),
          color: AppColors.black87,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            size: AppSize.iconMd.w,
            color: AppColors.black54,
          ),
      onTap: onTap ?? () => _showNotImplemented(context, title),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w - 4,
        vertical: AppSpacing.xs.h,
      ),
    );
  }

  void _showNotImplemented(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label is coming in a future update'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
