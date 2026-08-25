import 'package:flutter/material.dart';

import 'package:flutter_boilerplate/feature_course_details/widgets/course_banner.dart';
import 'package:flutter_boilerplate/feature_course_details/widgets/course_card.dart';
import 'package:flutter_boilerplate/feature_course_details/widgets/course_header.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF2E2E2E),
      body: Stack(
        children: [
          /// Banner
          CourseBanner(),

          /// Back & Close Buttons
          CourseHeader(),

          /// Course Details Card
          CourseCard(),
        ],
      ),
    );
  }
}
