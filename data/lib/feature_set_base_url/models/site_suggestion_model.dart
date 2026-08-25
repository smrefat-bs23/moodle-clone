// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter_boilerplate_data/feature_set_base_url/models/site_suggestion_dto.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// Data-layer model for a single site suggestion. Extends the domain
/// [SiteSuggestionEntity] so the repository implementation can return
/// the same instance type expected by the domain layer.
class SiteSuggestionModel extends SiteSuggestionEntity {
  /// Creates a [SiteSuggestionModel].
  const SiteSuggestionModel({
    required super.sitename,
    required super.siteUrl,
    required super.username,
    required super.userId,
    required super.raw,
    super.release,
    super.version,
    super.theme,
    super.fullname,
  });

  /// Build a [SiteSuggestionModel] from a [SiteSuggestionDto] (the
  /// raw JSON-decoded payload coming straight from the API).
  factory SiteSuggestionModel.fromDto(SiteSuggestionDto dto) {
    return SiteSuggestionModel(
      sitename: dto.sitename,
      siteUrl: dto.siteUrl,
      username: dto.username,
      userId: dto.userId,
      raw: dto.raw,
      release: dto.release,
      version: dto.version,
      theme: dto.theme,
      fullname: dto.fullname,
    );
  }
}