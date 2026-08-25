import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Placeholder for the "More" bottom-nav destination.
///
/// Provides a teaser list of common Moodle "More" entries that will be
/// promoted to real features on dedicated branches.
class MorePage extends StatelessWidget {
  /// Creates a [MorePage].
  const MorePage({super.key, this.embedded = false});

  /// Whether the page is rendered inside another [Scaffold].
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);

    if (embedded) {
      return ColoredBox(color: AppColors.background, child: body);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'More',
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.h3.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: body,
    );
  }

  Widget _buildBody(BuildContext context) {
    double safeSp(double size) => size.sp > 0 ? size.sp : size;

    final items = <_MoreEntry>[
      _MoreEntry(Icons.calendar_today_outlined, 'Calendar', 'Manage events'),
      _MoreEntry(Icons.article_outlined, 'Site blog', null),
      _MoreEntry(Icons.bookmark_border, 'Tags', 'Browse tags'),
      _MoreEntry(Icons.qr_code_scanner, 'Scan QR code', null),
      _MoreEntry(Icons.settings_outlined, 'App settings', null),
      _MoreEntry(Icons.account_circle_outlined, 'Switch account', null),
    ];

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.std.h),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.xs.h),
      itemBuilder: (context, index) {
        final entry = items[index];
        return InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${entry.title} will be available in a future update',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            color: AppColors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.std.w,
              vertical: AppSpacing.md.h,
            ),
            child: Row(
              children: [
                Icon(
                  entry.icon,
                  size: AppSize.iconMd.w,
                  color: AppColors.grey700,
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: TextStyle(
                          fontSize: safeSp(AppFontSize.lg),
                          color: AppColors.black87,
                        ),
                      ),
                      if (entry.subtitle != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          entry.subtitle!,
                          style: TextStyle(
                            fontSize: safeSp(AppFontSize.md),
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.black54,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Local data class for the More page row.
class _MoreEntry {
  /// Creates a [_MoreEntry].
  const _MoreEntry(this.icon, this.title, this.subtitle);

  /// Row icon.
  final IconData icon;

  /// Row title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;
}
