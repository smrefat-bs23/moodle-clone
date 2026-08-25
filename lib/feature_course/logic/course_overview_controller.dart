import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_course/models/course_model.dart';
import 'package:flutter_boilerplate/feature_course/services/course_service.dart';

/// Controller for managing the dynamic course overview data.
class CourseOverviewController extends ChangeNotifier {
  final CourseService _service = CourseService();

  CourseModel? _courseData;
  bool _isLoading = true;
  bool _isExpanded = true;
  String? _errorMessage;
  final double _progress = 0.27;

  /// The loaded course data.
  CourseModel? get courseData => _courseData;

  /// Whether the data is currently loading.
  bool get isLoading => _isLoading;

  /// Whether the content card is expanded.
  bool get isExpanded => _isExpanded;

  /// The progress value.
  double get progress => _progress;

  /// Any error message encountered during data fetch.
  String? get errorMessage => _errorMessage;

  /// Fetches data using the service.
  Future<void> fetchCourseData(String courseId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _courseData = await _service.fetchCourseDetails(courseId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggles the expanded state.
  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}
