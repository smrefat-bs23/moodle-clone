import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class CourseHeader extends StatelessWidget {
  const CourseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 16.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _circleButton(context, Icons.arrow_back),
            _circleButton(context, Icons.close),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(BuildContext context, IconData icon) {
    return CircleAvatar(
      radius: 22.r,
      backgroundColor: context.colorScheme.surface,
      child: Icon(
        icon,
        color: context.colorScheme.onSurface,
        size: 30.sp,
      ),
    );
  }
}