import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_data/feature_home/datasources/moodle_remote_datasource.dart';
import 'package:flutter_boilerplate_domain/flutter_boilerplate_domain.dart';
import 'package:injectable/injectable.dart';

/// Implementation of [MoodleRepository].
///
/// The repository is intentionally thin: it delegates parsing to the
/// datasource and converts [DioError]s to the [AppFailure] subclasses
/// produced by [MoodleErrorInterceptor] (attached to [ApiClient]).
///
/// Pinned to Dio 4 ([DioError]). If the project later upgrades to Dio 5,
/// swap [DioError] for `DioException`; constructors are identical.
@LazySingleton(as: MoodleRepository)
class MoodleRepositoryImpl implements MoodleRepository {
  /// Creates a new instance of [MoodleRepositoryImpl].
  MoodleRepositoryImpl({required MoodleRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  final MoodleRemoteDatasource _remoteDatasource;

  @override
  Future<Result<SiteInfoEntity>> getSiteInfo({String? wstoken}) async {
    try {
      final json = await _remoteDatasource.getSiteInfo(wstoken: wstoken);
      final entity = SiteInfoEntity.fromJson(json);
      return ResultHelper.success(entity);
    } on DioError catch (e) {
      return (null, _failureFromDio(e));
    } catch (e, st) {
      return (
        null,
        UnknownFailure(
          message: 'Unexpected error while reading site info: $e',
          exception: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Convert a [DioError] into an [AppFailure].
  ///
  /// Order of precedence:
  /// 1. `e.error` set by [MoodleErrorInterceptor] (preferred — typed).
  /// 2. Re-derive a [NetworkFailure] from `e.response` (e.g. for HTTP
  ///    4xx/5xx responses that didn't go through the Moodle parser).
  AppFailure _failureFromDio(DioError e) {
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

    return NetworkFailure(
      message: 'Network error',
      stackTrace: e.stackTrace,
    );
  }
}
