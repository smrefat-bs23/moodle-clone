import 'package:flutter/material.dart';

/// A styled media player layout block matching the design spec.
class CourseVideoPreview extends StatelessWidget {
  /// Creates a [CourseVideoPreview].
  const CourseVideoPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.play_circle_fill,
            size: 54,
            color: Colors.white,
          ),
          Positioned(
            left: 12,
            bottom: 8,
            child: Text(
              '0:00 / 0:36',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
