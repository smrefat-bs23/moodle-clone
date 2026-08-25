import 'package:dio/dio.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// Interceptor that detects the Moodle REST error envelope
/// (HTTP 200 + `{errorcode, message, exception}`) and converts it
/// into a [DioError] carrying the matching [AppFailure].
///
/// Pinned to Dio 4 (`DioError`). If the project later upgrades to Dio 5,
/// swap `DioError` for `DioException`; constructors are identical.
///
/// Without this interceptor the success path is reached with an "error"
/// body, and the cubit would treat it as a successful empty response.
///
/// See `docs/COURSE_API_IMPLEMENTATION.md` section 4 for the full
/// mapping table.
class MoodleErrorInterceptor extends Interceptor {
  /// Creates a [MoodleErrorInterceptor].
  MoodleErrorInterceptor();

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final body = response.data;

    if (!MoodleErrorParser.isMoodleError(body)) {
      handler.next(response);
      return;
    }

    final failure = MoodleErrorParser.parse(body);
    final err = DioError(
      requestOptions: response.requestOptions,
      response: response,
      error: failure,
    );
    handler.reject(err);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Pass-through. The AppFailure (if any) is already attached to
    // `err.error` by the upstream `onResponse` branch.
    handler.next(err);
  }
}
