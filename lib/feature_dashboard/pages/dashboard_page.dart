import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/messages_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/more_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/my_courses_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/pages/notifications_page.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/available_courses_card.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/calendar_card.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/dashboard_bottom_navigation.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/dashboard_header.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/dashboard_tabs.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/timeline_card.dart';
import 'package:flutter_boilerplate/feature_dashboard/widgets/user_account_overlay.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate/feature_dashboard/utils/app_colors.dart';
import 'package:flutter_boilerplate/feature_dashboard/utils/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// The main dashboard page of the application.
class DashboardPage extends StatelessWidget {
  /// Creates a [DashboardPage].
  const DashboardPage({super.key});

  void _showUserAccount(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'UserAccount',
      barrierColor: AppColors.barrier,
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getIt<DashboardCubit>()..fetchDashboardCourses(),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (previous, current) =>
            previous.bottomNavIndex != current.bottomNavIndex,
        builder: (context, navState) {
          final body = switch (navState.bottomNavIndex) {
            DashboardNavTab.dashboard => const _DashboardTabBody(),
            DashboardNavTab.myCourses => const MyCoursesPage(embedded: true),
            DashboardNavTab.messages => const MessagesPage(embedded: true),
            DashboardNavTab.notifications =>
              const NotificationsPage(embedded: true),
            DashboardNavTab.more => const MorePage(embedded: true),
          };

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: navState.bottomNavIndex == DashboardNavTab.dashboard
                ? const DashboardHeader()
                : _buildSimpleHeader(context, navState.bottomNavIndex),
            body: Stack(
              children: [
                body,
                // Floating Right Side Arrow Button to open user-account overlay
                Positioned(
                  right: 0,
                  top: MediaQuery.of(context).size.height * 0.4,
                  child: GestureDetector(
                    onTap: () => _showUserAccount(context),
                    child: Container(
                      width: 36.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSize.radiusFull.r),
                          bottomLeft: Radius.circular(AppSize.radiusFull.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 4.r,
                            offset: const Offset(-1, 0),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.grey800,
                        size: 24.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const DashboardBottomNavigation(),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildSimpleHeader(
    BuildContext context,
    DashboardNavTab tab,
  ) {
    final title = switch (tab) {
      DashboardNavTab.myCourses => 'My Courses',
      DashboardNavTab.messages => 'Messages',
      DashboardNavTab.notifications => 'Notifications',
      DashboardNavTab.more => 'More',
      DashboardNavTab.dashboard => 'Dashboard',
    };
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.black,
          fontSize: AppFontSize.h3.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            tab == DashboardNavTab.messages
                ? Icons.search
                : Icons.more_vert,
            color: AppColors.black87,
            size: AppSize.iconMdLg.w,
          ),
          onPressed: () {
            if (tab == DashboardNavTab.messages) {
              context.pushNamed(AppRoutes.search);
            }
          },
        ),
      ],
    );
  }
}

/// Body for the Dashboard tab (sub-tabs + tab content).
class _DashboardTabBody extends StatelessWidget {
  /// Creates a [_DashboardTabBody].
  const _DashboardTabBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashboardTabs(),
        Expanded(
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              return IndexedStack(
                index: state.selectedTabIndex,
                children: [
                  _DashboardContent(),
                  _SiteHomeContent(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Dashboard sub-tab content (Timeline + Calendar).
class _DashboardContent extends StatelessWidget {
  /// Builds the inner dashboard sub-tab.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const TimelineCard(),
          const CalendarCard(),
          SizedBox(height: AppSpacing.xl.h),
        ],
      ),
    );
  }
}

/// Site home sub-tab content (Available Courses card + section rows).
class _SiteHomeContent extends StatelessWidget {
  /// Builds the site home sub-tab.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const AvailableCoursesCard(),
          SizedBox(height: AppSpacing.xl.h),
        ],
      ),
    );
  }
}
