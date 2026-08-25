import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/user_account_overlay.dart';
import 'package:flutter_boilerplate/feature_more/widgets/more_avatar.dart';
import 'package:flutter_boilerplate/feature_more/widgets/more_blog_item.dart';
import 'package:flutter_boilerplate/feature_more/widgets/more_bottom_nav.dart';
import 'package:flutter_boilerplate/feature_more/widgets/more_calendar_item.dart';
import 'package:flutter_boilerplate/feature_more/widgets/more_qr_item.dart';
import 'package:flutter_boilerplate/feature_more/widgets/more_settings_item.dart';
import 'package:flutter_boilerplate/feature_more/widgets/more_tags_item.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The "More" screen providing access to secondary app features.
///
/// This screen provides entry points to features like Calendar, Site Blog,
/// Tags, and App Settings. It is highly modularized for future extensibility.
class MorePage extends StatelessWidget {
  /// Creates an instance of [MorePage].
  const MorePage({super.key, this.embedded = false});

  /// Whether the page is rendered inside another [Scaffold] — the
  /// Dashboard shell already supplies an app bar, bottom nav, and the
  /// account-overlay entry point (its floating avatar arrow) for every
  /// embedded tab, so this page's own versions of those are skipped.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        _buildTopMenu(),
        const Spacer(),
        _buildSettingsSection(),
      ],
    );

    if (embedded) {
      return ColoredBox(color: Colors.white, child: body);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: body,
      bottomNavigationBar: const MoreBottomNav(),
    );
  }

  /// Builds the top-aligned AppBar with interactive avatar.
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: Text(
        AppStrings.labelMore,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: AppSpacing.md.w),
          child: MoreAvatar(
            name: 'Student User',
            onTap: () => _showUserAccountOverlay(context),
          ),
        ),
      ],
    );
  }

  /// Shows the shared [UserAccountOverlay], sliding in from the right —
  /// same presentation as the dashboard header's avatar tap.
  void _showUserAccountOverlay(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'UserAccount',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: const UserAccountOverlay(),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

  /// Builds the main list of navigational items.
  Widget _buildTopMenu() {
    return const Column(
      children: [
        MoreCalendarItem(),
        MoreBlogItem(),
        MoreTagsItem(),
        MoreQrItem(),
      ],
    );
  }

  /// Builds the bottom-aligned settings section with a top divider.
  Widget _buildSettingsSection() {
    return Column(
      children: [
        Divider(
          height: 1.h,
          thickness: 1.h,
          color: AppTheme.moodleBorderGrey,
        ),
        const MoreSettingsItem(),
      ],
    );
  }
}
