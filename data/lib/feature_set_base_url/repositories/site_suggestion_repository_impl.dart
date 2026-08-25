// ignore_for_file: comment_references

import 'package:dio/dio.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_data/feature_set_base_url/datasources/site_suggestion_remote_datasource.dart';
import 'package:flutter_boilerplate_data/feature_set_base_url/models/site_suggestion_model.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/repositories/site_suggestion_repository.dart';

/// Default implementation of [SiteSuggestionRepository].
///
/// The repository is intentionally thin: it delegates parsing to the
/// datasource and converts [DioError]s to the [AppFailure] subclasses
/// produced by the global error interceptor / [ApiClient].
///
/// Pinned to Dio 4 (`DioError`); if the project migrates to Dio 5
/// later, swap `DioError` for `DioException` — constructors are
/// identical.
class SiteSuggestionRepositoryImpl implements SiteSuggestionRepository {
  /// Creates a new [SiteSuggestionRepositoryImpl].
  const SiteSuggestionRepositoryImpl({
    required SiteSuggestionRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final SiteSuggestionRemoteDatasource _remoteDatasource;

  @override
  Future<Result<SiteSuggestionEntity>> getSiteSuggestion({
    required String baseUrl,
    CancelToken? cancelToken,
  }) async {
    if (baseUrl.trim().isEmpty) {
      return (null, _emptyUrlFailure());
    }

    try {
      final dto = await _remoteDatasource.getSiteSuggestion(
        baseUrl: baseUrl,
        cancelToken: cancelToken,
      );
      return ResultHelper.success<SiteSuggestionEntity>(
        SiteSuggestionModel.fromDto(dto),
      );
    } on DioError catch (e) {
      return (null, _failureFromDio(e));
    } on FormatException catch (e, st) {
      return (
        null,
        ValidationFailure(
          message: e.message,
          field: 'baseUrl',
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return (
        null,
        UnknownFailure(
          message: 'Unexpected error while resolving site: $e',
          exception: e,
          stackTrace: st,
        ),
      );
    }
  }

  AppFailure _emptyUrlFailure() => ValidationFailure(
        message: 'Please enter a Moodle site URL',
        field: 'baseUrl',
      );

  /// Convert a [DioError] into an [AppFailure].
  ///
  /// Order of precedence:
  /// 1. `e.error` set by the Moodle error interceptor (preferred — typed).
  /// 2. Re-derive a [NetworkFailure] from `e.response` for HTTP 4xx/5xx
  ///    that didn't go through the Moodle parser.
  /// 3. Treat cancellation as a benign "no result" signal (`null` failure)
  ///    so the cubit can simply ignore stale responses.
  AppFailure? _failureFromDio(DioError e) {
    // Cancellation is expected — caller already moved on.
    if (CancelToken.isCancel(e)) {
      return null;
    }

    final wrapped = e.error;
    if (wrapped is AppFailure) {
      return wrapped;
    }

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
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return NetworkFailure(
          message: 'Request timed out',
          stackTrace: e.stackTrace,
        );
      case DioExceptionType.cancel:
        return null;
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkFailure(
          message: 'Network error',
          stackTrace: e.stackTrace,
        );
    }
  }
}
