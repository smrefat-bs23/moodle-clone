import 'dart:convert';

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// Parses the Moodle REST error envelope into an [AppFailure].
///
/// Moodle REST endpoints return **HTTP 200** with an error body when the
/// call fails. The body shape is:
///
/// ```json
/// {
///   "errorcode": "invalidtoken",
///   "message":   "Invalid token - token not found",
///   "exception": "moodle_exception"
/// }
/// ```
///
/// Because [ApiClient._mapError] keys off `response.statusCode`, it does not
/// catch this envelope. The [MoodleErrorInterceptor] calls this parser for
/// every successful response and, when it detects the envelope, replaces the
/// successful response with a `DioException` carrying the mapped
/// [AppFailure].
///
/// The mapping implemented here mirrors §4 of
/// `docs/COURSE_API_IMPLEMENTATION.md`:
///
/// | `errorcode`                              | `AppFailure`                |
/// | ---------------------------------------- | --------------------------- |
/// | `invalidtoken`                           | `AuthFailure` (no refresh)  |
/// | `accessexception`, `nopermission`,       | `AuthFailure` (no refresh)  |
/// |   `requireloginerror`                    |                             |
/// | `invalidparameter`, `missingparameter`,  | `ValidationFailure`         |
/// |   `invalidresponse`                      |                             |
/// | `wsnotavailable`, `servicerequired`,     | `UnknownFailure`            |
/// |   `externalservice`, `servicenotavailable` |                            |
/// | anything else                            | `UnknownFailure`            |
class MoodleErrorParser {
  /// Whether the given response body is a Moodle error envelope.
  ///
  /// Returns `true` when the body is a JSON object containing non-empty
  /// `errorcode` and `message` strings.
  static bool isMoodleError(Object? body) {
    if (body is! Map) return false;
    final code = body['errorcode'];
    final message = body['message'];
    return code is String &&
        code.isNotEmpty &&
        message is String &&
        message.isNotEmpty;
  }

  /// Parse a response body (already decoded) into an [AppFailure].
  ///
  /// Throws [ArgumentError] if [body] is not a Moodle error envelope —
  /// callers must guard with [isMoodleError] first.
  static AppFailure parse(Object? body) {
    if (body is! Map) {
      throw ArgumentError.value(
        body,
        'body',
        'Not a Moodle error envelope; '
        'check MoodleErrorParser.isMoodleError first.',
      );
    }

    final code = (body['errorcode'] as String?)?.toLowerCase() ?? '';
    final message = (body['message'] as String?) ?? 'Moodle error';
    final exception = body['exception'] as String?;

    switch (code) {
      case 'invalidtoken':
        return AuthFailure(message: message);

      case 'accessexception':
      case 'nopermission':
      case 'requireloginerror':
        return AuthFailure(message: message);

      case 'invalidparameter':
      case 'missingparameter':
      case 'invalidresponse':
        return ValidationFailure(
          message: message,
          errors: [if (exception != null) exception],
        );

      case 'wsnotavailable':
      case 'servicerequired':
      case 'externalservice':
      case 'servicenotavailable':
        return UnknownFailure(
          message: message,
          exception: body,
        );

      default:
        return UnknownFailure(
          message: message,
          exception: body,
        );
    }
  }

  /// Convenience: parse the raw response body string. Returns `null` if the
  /// body is not JSON or is not a Moodle error envelope.
  static AppFailure? tryParseString(String? rawBody) {
    if (rawBody == null || rawBody.isEmpty) return null;
    Object? decoded;
    try {
      decoded = jsonDecode(rawBody);
    } catch (_) {
      return null;
    }
    if (!isMoodleError(decoded)) return null;
    return parse(decoded);
  }
}
