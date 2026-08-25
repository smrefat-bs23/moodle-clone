// ignore_for_file: comment_references

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// Repository contract for the "site suggestion" lookup performed
/// while the user types in the Base URL input.
///
/// Concrete implementations live in `data/lib/feature_set_base_url/`.
///
/// Failures are returned via the project-wide [Result] type
/// (`(data?, failure?)`), so the presentation layer never has to catch
/// exceptions.
abstract class SiteSuggestionRepository {
  /// Resolve the Moodle site located at [baseUrl].
  ///
  /// Implementations are expected to:
  /// - honour [cancelToken] so that outdated in-flight requests can be
  ///   cancelled when the user keeps typing;
  /// - return a [Result] with a non-null failure on any error
  ///   (network, timeout, server, parser, …).
  Future<Result<SiteSuggestionEntity>> getSiteSuggestion({
    required String baseUrl,
    CancelToken? cancelToken,
  });
}
