import 'package:flutter/material.dart';

/// A widget displaying the folder link and description subtext.
class CourseFolderSection extends StatelessWidget {
  /// Creates a [CourseFolderSection].
  const CourseFolderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.folder_open_outlined,
              color: Color(0xFF009688),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Interesting cities',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Fixed text style coloring to mirror paragraph styling tokens
        const Text(
          'No need to download these images - view them',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
