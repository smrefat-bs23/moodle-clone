// ignore_for_file: comment_references

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// Maps low-level [DioError]s (and other exceptions) into the
/// project-wide [AppFailure] hierarchy, and renders user-friendly
/// messages for the suggestion cubit.
class SiteSuggestionFailureMapper {
  /// Creates a [SiteSuggestionFailureMapper].
  const SiteSuggestionFailureMapper();

  /// Convert a [DioError] into an [AppFailure].
  ///
  /// Returns `null` for cancellation so the caller can treat it as a
  /// benign "ignore this response" signal rather than a hard error.
  AppFailure? fromDioError(DioError e) {
    if (CancelToken.isCancel(e)) {
      return null;
    }

    final wrapped = e.error;
    if (wrapped is AppFailure) return wrapped;

    final response = e.response;
    if (response != null) {
      return NetworkFailure(
        message: 'HTTP ${response.statusCode}',
        statusCode: response.statusCode,
        responseBody: response.data?.toString(),
        stackTrace: e.stackTrace,
      );
    }

    switch (e.type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.transformTimeout:
        return NetworkFailure(
          message: 'Request timed out',
          stackTrace: e.stackTrace,
        );
      case DioErrorType.connectionError:
        return NetworkFailure(
          message: 'No internet connection',
          stackTrace: e.stackTrace,
        );
      case DioErrorType.badCertificate:
        return NetworkFailure(
          message: 'Bad certificate',
          stackTrace: e.stackTrace,
        );
      case DioErrorType.badResponse:
      case DioErrorType.unknown:
        return NetworkFailure(
          message: 'Network error',
          stackTrace: e.stackTrace,
        );
      case DioErrorType.cancel:
        return null;
    }
  }

  /// Render a user-facing error message for [failure].
  String messageFor(AppFailure failure) {
    return switch (failure) {
      NetworkFailure(:final statusCode) when statusCode != null =>
        AppStrings.errorServer,
      NetworkFailure() => AppStrings.errorNetwork,
      ValidationFailure() => failure.message,
      AuthFailure() => failure.message,
      CacheFailure() => failure.message,
      UnknownFailure() => failure.message,
      AppFailure() => failure.message,
    };
  }
}