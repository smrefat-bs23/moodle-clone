import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: AppSpacing.md.h,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.notifications,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(AppSize.radiusFull.r),
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: context.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    size: 26.sp,
                    color: context.colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1.h,
          thickness: 1.h,
          color: context.colorScheme.outlineVariant,
        ),
      ],
    );
  }
}
