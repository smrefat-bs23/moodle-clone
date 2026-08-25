// ignore_for_file: comment_references

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Remote data source for the Moodle `core_webservice_get_site_info`
/// endpoint.
///
/// Uses plain [Dio] (rather than Retrofit) because the endpoint's
/// authentication is a `wstoken` query parameter — Retrofit regeneration
/// would be unnecessary friction for one query-string call.
///
/// Failures inside the Moodle response body are detected and rejected by
/// the global [MoodleErrorInterceptor] added in [ApiClient._setupDio].
/// This means callers see a normal [DioError] whose `error` field is
/// the mapped [AppFailure] (e.g. `AuthFailure`, `ValidationFailure`).
@lazySingleton
class MoodleRemoteDatasource {
  /// Creates a [MoodleRemoteDatasource].
  MoodleRemoteDatasource({
    required Dio dio,
    @Named('moodleBaseUrl') String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl ?? defaultBaseUrl;

  /// Dio instance used to perform requests.
  final Dio _dio;

  /// Base URL resolved from the flavour or [defaultBaseUrl].
  final String _baseUrl;

  /// Default fallback URL. Real base URLs come from `FlavorConfig`.
  static const String defaultBaseUrl =
      'https://lmsmobile.ahnafmuttaki.com/webservice/rest/server.php';

  /// Documented fallback token used when no storage token is available.
  ///
  /// See `docs/COURSE_API_IMPLEMENTATION.md` (Trigger & Token Resolution)
  /// and Open Gap #4 in the same doc.
  static const String fallbackWstoken =
      '5dc0f086abc4b82a1562b01a20637705';

  /// Call `core_webservice_get_site_info`.
  ///
  /// Returns the decoded JSON body as a [Map]. The [MoodleErrorInterceptor]
  /// rejects the response with the proper [AppFailure] if the body is a
  /// Moodle error envelope.
  ///
  /// If [wstoken] is null or empty, [fallbackWstoken] is used.
  Future<Map<String, dynamic>> getSiteInfo({String? wstoken}) async {
    final token = (wstoken == null || wstoken.isEmpty)
        ? fallbackWstoken
        : wstoken;

    final response = await _dio.get<dynamic>(
      _baseUrl,
      queryParameters: <String, dynamic>{
        'moodlewsrestformat': 'json',
        'wstoken': token,
        'wsfunction': 'core_webservice_get_site_info',
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      // Defensive: not a JSON object. Surface as a generic parse error
      // so the cubit treats it as a failure rather than as data.
      throw DioError(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unexpected Moodle response shape: ${data.runtimeType}',
      );
    }
    return data;
  }
}
