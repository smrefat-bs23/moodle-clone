import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen displayed when an unhandled error occurs
class ErrorScreen extends StatelessWidget {
  /// Creates an error screen
  const ErrorScreen({
    required this.error,
    this.stackTrace,
    this.onRetry,
    super.key,
  });

  /// Error message
  final String error;

  /// Stack trace (optional)
  final String? stackTrace;

  /// Callback to retry
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.errorContainer,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.lg.h),
            Icon(
              Icons.error_outline,
              size: AppSize.iconXl * 1.5,
              color: colorScheme.error,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              AppStrings.errorSomethingWentWrong,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onErrorContainer,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              AppStrings.errorUnexpectedNotify,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Container(
              padding: EdgeInsets.all(AppSpacing.md.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSize.radiusMd.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.errorDetails,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  SelectableText(
                    error,
                    style: TextStyle(fontSize: 12.sp, fontFamily: 'monospace'),
                  ),
                  if (stackTrace != null) ...[
                    SizedBox(height: AppSpacing.md.h),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.error),
                        borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          AppStrings.errorStackTrace,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(AppSpacing.sm.w),
                            child: SelectableText(
                              stackTrace!,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: colorScheme.error,
                borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
                child: InkWell(
                  onTap: onRetry,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: colorScheme.onError),
                        SizedBox(width: AppSpacing.sm.w),
                        Text(
                          AppStrings.labelTryAgain,
                          style: TextStyle(color: colorScheme.onError),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.error),
                    borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, color: colorScheme.error),
                          SizedBox(width: AppSpacing.sm.w),
                          Text(
                            AppStrings.labelGoHome,
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
