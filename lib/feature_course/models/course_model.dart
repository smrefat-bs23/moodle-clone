import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart'; // This file will be generated

/// Model representing a Course.
@JsonSerializable()
class CourseModel {
  /// Creates a [CourseModel].
  const CourseModel({
    required this.title,
    required this.description,
  });

  /// Factory for JSON deserialization.
  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  /// Course title.
  final String title;

  /// Course description.
  final String description;

  /// Converts model to JSON.
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
}
