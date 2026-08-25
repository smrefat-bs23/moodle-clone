import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class CourseBanner extends StatelessWidget {
  const CourseBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 270.h,
      child: Image.asset(
        AppStrings.courseBanner,
        fit: BoxFit.cover,
      ),
    );
  }
}