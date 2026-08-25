// ignore_for_file: comment_references

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_home/entities/site_info_entity.dart';
import 'package:flutter_boilerplate_domain/feature_home/repositories/moodle_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case for fetching the Moodle site info.
///
/// Encapsulates the business rule "call `core_webservice_get_site_info`
/// when the user opens the dashboard", described at the top of
/// `docs/COURSE_API_IMPLEMENTATION.md`.
///
/// Currently the caller must supply the [wstoken]; a future revision
/// should resolve it from [LocalStorage] with the documented fallback
/// (see Open Gap #4).
@injectable
class GetSiteInfoUseCase {
  /// Creates a new instance of [GetSiteInfoUseCase].
  const GetSiteInfoUseCase(this._repository);

  final MoodleRepository _repository;

  /// Execute the use case.
  Future<Result<SiteInfoEntity>> call({String? wstoken}) =>
      _repository.getSiteInfo(wstoken: wstoken);
}
