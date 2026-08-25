import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_strings.dart';
import 'package:flutter_boilerplate/feature_course/widgets/course_header_widget.dart';

/// A custom AppBar for the course overview layout block.
class CourseOverviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a [CourseOverviewAppBar].
  const CourseOverviewAppBar({required this.progress, super.key});

  /// Current loading progress value.
  final double progress;

  @override
  Size get preferredSize => const Size.fromHeight(172);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {},
      ),
      actions: [
        IconButton(icon: const Icon(Icons.cloud_download), onPressed: () {}),
        IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(116),
        child: Column(
          children: [
            CourseHeaderWidget(progress: progress),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TabBar(
                    indicatorColor: const Color(0xFFE06B26),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: theme.colorScheme.onSurface,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    tabs: const [
                      Tab(text: AppStrings.course),
                      Tab(text: AppStrings.participants),
                      Tab(text: AppStrings.grades),
                    ],
                  ),
                  Positioned(
                    right: 4,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                      onPressed: () {
                        // Triggers tab scrolling or pagination logic
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
