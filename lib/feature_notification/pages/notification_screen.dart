import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate/feature_notification/widgets/mark_read_button.dart';
import 'package:flutter_boilerplate/feature_notification/widgets/notification_bottom_nav.dart';
import 'package:flutter_boilerplate/feature_notification/widgets/notification_header.dart';
import 'package:flutter_boilerplate/feature_notification/widgets/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Brightness: ${Theme.of(context).brightness}');
    return Scaffold(
      backgroundColor: context.colorScheme.onInverseSurface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const NotificationHeader(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const NotificationItem(),
                      SizedBox(height: AppSpacing.xxl.h),
                    ],
                  ),
                ),
              ],
            ),
            const MarkReadButton(),
          ],
        ),
      ),
      bottomNavigationBar: const NotificationBottomNav(),
    );
  }
}
