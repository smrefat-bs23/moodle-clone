// ignore_for_file: comment_references

import 'package:dio/dio.dart';
import 'package:flutter_boilerplate_data/feature_set_base_url/models/site_suggestion_dto.dart';

/// Static configuration for the Moodle `core_webservice_get_site_info`
/// endpoint.
///
/// Kept in one place so the same token/function name is reused across
/// every feature that talks to the Moodle REST API.
class SiteSuggestionApiConfig {
  /// Private constructor — use the static members instead.
  const SiteSuggestionApiConfig._();

  /// Documented fallback token used when no storage token is available.
  ///
  /// Mirrors `MoodleRemoteDatasource.fallbackWstoken` from
  /// `feature_home`; kept duplicated here so this feature does not have
  /// to depend on `feature_home`'s internals.
  static const String fallbackWstoken =
      '5dc0f086abc4b82a1562b01a20637705';

  /// Web-service function name on the Moodle REST endpoint.
  static const String wsFunction = 'core_webservice_get_site_info';

  /// Response format expected by Moodle.
  static const String moodleWsRestFormat = 'json';
}

/// Remote data source for the Moodle `core_webservice_get_site_info`
/// endpoint, parameterised by the user-typed base URL.
///
/// Unlike [MoodleRemoteDatasource] in `feature_home`, this datasource
/// takes the base URL from the caller every call so it can target the
/// exact host the user is typing — that is what enables the search/
/// suggestion behaviour.
abstract class SiteSuggestionRemoteDatasource {
  /// Resolve the site located at [baseUrl].
  ///
  /// The [baseUrl] is normalised: a trailing `/webservice/rest/server.php`
  /// or trailing slashes are accepted; the method always POSTs to
  /// `{host}/webservice/rest/server.php` with
  /// `application/x-www-form-urlencoded`.
  ///
  /// Pass [cancelToken] to abort an in-flight request when the user
  /// keeps typing.
  Future<SiteSuggestionDto> getSiteSuggestion({
    required String baseUrl,
    CancelToken? cancelToken,
  });
}

/// Default implementation of [SiteSuggestionRemoteDatasource] backed by
/// plain [Dio].
class SiteSuggestionRemoteDatasourceImpl
    implements SiteSuggestionRemoteDatasource {
  /// Creates a [SiteSuggestionRemoteDatasourceImpl].
  const SiteSuggestionRemoteDatasourceImpl({
    required Dio dio,
  }) : _dio = dio;

  /// Shared Dio instance.
  final Dio _dio;

  @override
  Future<SiteSuggestionDto> getSiteSuggestion({
    required String baseUrl,
    CancelToken? cancelToken,
  }) async {
    final endpoint = _buildEndpoint(baseUrl);

    final response = await _dio.post<dynamic>(
      endpoint,
      data: <String, dynamic>{
        'moodlewsrestformat': SiteSuggestionApiConfig.moodleWsRestFormat,
        'wstoken': SiteSuggestionApiConfig.fallbackWstoken,
        'wsfunction': SiteSuggestionApiConfig.wsFunction,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: <String, dynamic>{
          'Accept': 'application/json',
        },
      ),
      cancelToken: cancelToken,
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const _InvalidResponseShapeException();
    }

    return SiteSuggestionDto.fromJson(data);
  }

  /// Normalise the user-typed [baseUrl] into the canonical Moodle REST
  /// endpoint.
  ///
  /// Accepts forms like:
  /// - `https://lms.example.edu`
  /// - `https://lms.example.edu/`
  /// - `https://lms.example.edu/webservice/rest/server.php`
  static String _buildEndpoint(String baseUrl) {
    var url = baseUrl.trim();
    if (url.isEmpty) {
      throw const FormatException('Base URL cannot be empty');
    }

    // Strip trailing slashes.
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }

    // If the user already pasted the canonical endpoint, keep it.
    const suffix = '/webservice/rest/server.php';
    if (url.toLowerCase().endsWith(suffix)) {
      return url;
    }

    return '$url$suffix';
  }
}

/// Thrown by [SiteSuggestionRemoteDatasourceImpl] when the response
/// body is not a JSON object.
class _InvalidResponseShapeException implements Exception {
  /// Creates a [_InvalidResponseShapeException].
  const _InvalidResponseShapeException();

  @override
  String toString() => 'Unexpected Moodle response shape';
}