import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_course/logic/course_overview_controller.dart';
import 'package:flutter_boilerplate/feature_course/models/course_model.dart';
import 'package:flutter_boilerplate/feature_course/widgets/course_content_card.dart';
import 'package:flutter_boilerplate/feature_course/widgets/course_overview_app_bar.dart';
import 'package:flutter_boilerplate/feature_course/widgets/floating_side_toggle.dart';

/// The screen displaying the course overview layout framework.
class CourseOverviewScreen extends StatefulWidget {
  /// Creates a [CourseOverviewScreen].
  const CourseOverviewScreen({super.key});

  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen> {
  final CourseOverviewController _controller = CourseOverviewController();

  @override
  void initState() {
    super.initState();
    _controller.fetchCourseData('1');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CourseOverviewAppBar(progress: _controller.progress),
        body: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final course = _controller.courseData ?? const CourseModel(
              title: 'Celebrating Cultures',
              description: 'We are all from different communities but we '
                  'are all one community at Mount Orange. This course is for '
                  'students, teachers and the wider community members to '
                  'share and learn about our cultural diversity.',
            );

            return TabBarView(
              children: [
                // Screen level Stack gives the toggle zero hit-test clipping
                Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        CourseContentCard(
                          title: course.title,
                          description: course.description,
                          isExpanded: _controller.isExpanded,
                          onExpansionChanged: (_) =>
                              _controller.toggleExpanded(),
                        ),
                      ],
                    ),
                    const FloatingSideToggle(),
                  ],
                ),
                const Center(child: Text('Participants')),
                const Center(child: Text('Grades')),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: const CircleBorder(),
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.format_list_bulleted,
            size: 26,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
