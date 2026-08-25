// ignore_for_file: comment_references

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/repositories/site_suggestion_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case for resolving a single Moodle site suggestion as the user
/// types into the Base URL input.
///
/// Encapsulates the business rule: "every keystroke (debounced) triggers
/// one call to `core_webservice_get_site_info` against the typed URL".
@injectable
class GetSiteSuggestionUseCase {
  /// Creates a new instance of [GetSiteSuggestionUseCase].
  const GetSiteSuggestionUseCase(this._repository);

  final SiteSuggestionRepository _repository;

  /// Execute the use case.
  Future<Result<SiteSuggestionEntity>> call({
    required String baseUrl,
    CancelToken? cancelToken,
  }) =>
      _repository.getSiteSuggestion(
        baseUrl: baseUrl,
        cancelToken: cancelToken,
      );
}