import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_course/widgets/course_folder_section.dart';
import 'package:flutter_boilerplate/feature_course/widgets/course_video_preview.dart';

/// A card that displays expanding course information matching the design spec.
class CourseContentCard extends StatelessWidget {
  /// Creates a [CourseContentCard].
  const CourseContentCard({
    required this.title,
    required this.description,
    required this.isExpanded,
    required this.onExpansionChanged,
    super.key,
  });

  /// The title text fallback parameter.
  final String title;

  /// The body text string.
  final String description;

  /// Whether the card contents are visible.
  final bool isExpanded;

  /// Callback executed when changing state.
  final ValueChanged<bool> onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => onExpansionChanged(!isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black87,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      // ignore: subheading_word_typo, spell_checker
                      'Welcome! Aloha! Bonvenon!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  // Adjusted structural padding gaps to align spacing metrics
                  const SizedBox(height: 12),
                  const CourseVideoPreview(),
                  const SizedBox(height: 20),
                  const CourseFolderSection(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
