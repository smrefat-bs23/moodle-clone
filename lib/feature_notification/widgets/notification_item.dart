import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSize.radiusFull.r),
                ),
                child: Icon(
                  Icons.login,
                  color: context.colorScheme.onSurface,
                  size: AppSize.iconMd.sp,
                ),
              ),

              SizedBox(width: AppSpacing.md.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontSize: 16.sp,
                                color: context.colorScheme.onSurface,
                              ),
                              children: [
                                TextSpan(text: AppStrings.signInMessage),
                                TextSpan(
                                  text: AppStrings.mountOrange,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: AppStrings.account),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: AppSpacing.sm.w),

                        Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: context.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.sm.h),

                    Text(
                      AppStrings.notificationTime,
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Divider(
          height: 1.h,
          indent: 86.w,
          color: context.colorScheme.outlineVariant,
        ),
      ],
    );
  }
}
