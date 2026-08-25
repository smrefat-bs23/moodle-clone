import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

class TeacherTile extends StatelessWidget {
  const TeacherTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 26.h),

        Text(
          AppStrings.teachers,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
            color: context.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 12.h),

        Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 22.r,
              backgroundColor: context.colorScheme.surfaceContainerHighest,
              child: Text(
                AppStrings.teacherInitials,
                style: TextStyle(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
            title: Text(
              AppStrings.teacherName,
              style: TextStyle(
                fontSize: 16.sp,
                color: context.colorScheme.onSurface,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: context.colorScheme.onSurface,
            ),
            onTap: () {},
          ),
        ),

        SizedBox(height: 20.h),
      ],
    );
  }
}