import 'package:flutter/material.dart';

/// A widget that displays the course header with thumbnail, title, and
/// progress.
class CourseHeaderWidget extends StatelessWidget {
  /// Creates a [CourseHeaderWidget].
  const CourseHeaderWidget({
    required this.progress,
    super.key,
  });

  /// The progress value between 0.0 and 1.0.
  final double progress;

  @override
  Widget build(BuildContext context) {
    // Fixed hexadecimal color notation (0xFF...) to prevent Symbol error
    const orangePrimary = Color(0xFFE06B26);
    const orangeTrack = Color(0xFFFDF0E6);

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 52,
              height: 52,
              color: Colors.grey.shade300,
              child: const Icon(
                Icons.map_outlined,
                color: Colors.grey,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Celebrating Cultures',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: orangeTrack,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            orangePrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
