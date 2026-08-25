import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/feature_course/models/course_model.dart';

/// Service to handle course-related API requests using Dio.
class CourseService {
  /// The Dio instance for network requests.
  final Dio _dio = Dio(
    BaseOptions(
      // Ensure this URL is replaced with your specific Moodle instance URL
      baseUrl: 'https://api.your-moodle-site.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  /// Fetches course details from the Moodle API.
  Future<CourseModel> fetchCourseDetails(String courseId) async {
    try {
      // Explicitly type the response to Map<String, dynamic>
      final response = await _dio.get<Map<String, dynamic>>(
        '/webservice/rest/server.php',
        queryParameters: {
          // ignore: spell_checking_inspection
          'wsfunction': 'core_course_get_contents',
          // ignore: spell_checking_inspection
          'courseid': courseId,
          // ignore: spell_checking_inspection
          'moodlewsrestformat': 'json',
        },
      );

      final data = response.data;

      if (data == null) {
        throw Exception('API returned null data');
      }

      return CourseModel.fromJson(data);
    } on DioException catch (e) {
      // Handle network errors gracefully
      throw Exception('Failed to load course: ${e.message}');
    }
  }
}
