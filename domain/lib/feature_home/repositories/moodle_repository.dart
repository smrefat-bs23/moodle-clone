// ignore_for_file: comment_references, one_member_abstracts

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_home/entities/site_info_entity.dart';

/// Repository contract for the Moodle `core_webservice_get_site_info`
/// endpoint.
///
/// See `docs/COURSE_API_IMPLEMENTATION.md` for the API spec and the
/// error-handling contract (failures are mapped from Moodle's body
/// envelope by `MoodleErrorInterceptor`).
abstract class MoodleRepository {
  /// Call `core_webservice_get_site_info` on the Moodle backend.
  ///
  /// [wstoken] is required — Moodle expects it as a query parameter.
  /// If [wstoken] is `null` or empty the implementation falls back to
  /// the literal token from `docs/COURSE_API_IMPLEMENTATION.md`
  /// (`5dc0f086abc4b82a1562b01a20637705`) until storage-based retrieval
  /// is wired in. See Open Gap #4.
  Future<Result<SiteInfoEntity>> getSiteInfo({String? wstoken});
}
