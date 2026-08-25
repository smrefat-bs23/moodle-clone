/// Dependency Injection Setup
///
/// Layers app, domain, and data registrations on top of the core package's
/// generated config. The injectable generator cannot see annotations across
/// package boundaries, so these cross-package registrations are wired
/// manually here.
library;

import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/feature_auth/cubit/login_cubit.dart';
import 'package:flutter_boilerplate/feature_auth/data/datasources/login_remote_datasource.dart';
import 'package:flutter_boilerplate/feature_auth/data/repositories/login_repository_impl.dart';
import 'package:flutter_boilerplate/feature_auth/domain/repositories/login_repository.dart';
import 'package:flutter_boilerplate/feature_auth/domain/usecases/login_usecase.dart';
import 'package:flutter_boilerplate/feature_dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_boilerplate/feature_post/cubit/post_cubit.dart';
import 'package:flutter_boilerplate_core/utils/injection/di.dart' as core_di;
import 'package:flutter_boilerplate_data/feature_post/datasources/post_remote_datasource.dart';
import 'package:flutter_boilerplate_data/feature_post/repositories/post_repository_impl.dart';
import 'package:flutter_boilerplate_domain/flutter_boilerplate_domain.dart';
import 'package:get_it/get_it.dart';

export 'package:flutter_boilerplate_core/utils/injection/di.dart'
    hide configureDependencies;

/// Global service locator instance
final GetIt getIt = core_di.getIt;

/// Base URL of the Moodle web service used by the login flow.
///
/// The core package owns the shared `Dio` and the `ApiClient` that mutates
/// its `baseUrl` for the JSONPlaceholder-backed `feature_post`. Because we
/// cannot change `core/`, the login feature uses a fully-qualified URL built
/// from this constant — the shared Dio's `baseUrl` is intentionally bypassed.
const String _moodleBaseUrl = 'https://lmsmobile.ahnafmuttaki.com';

/// Main entry point for configuring dependencies
///
/// Call this function in `main()` before `runApp()`
Future<void> configureDependencies([String? environment]) async {
  await core_di.configureDependencies(environment);

  getIt
    ..registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(remoteDatasource: getIt<PostRemoteDatasource>()),
    )
    ..registerFactory<GetPostsUseCase>(
      () => GetPostsUseCase(getIt<PostRepository>()),
    )
    ..registerFactory<GetPostUseCase>(
      () => GetPostUseCase(getIt<PostRepository>()),
    )
    ..registerFactory<CreatePostUseCase>(
      () => CreatePostUseCase(getIt<PostRepository>()),
    )
    ..registerFactory<UpdatePostUseCase>(
      () => UpdatePostUseCase(getIt<PostRepository>()),
    )
    ..registerFactory<PatchPostUseCase>(
      () => PatchPostUseCase(getIt<PostRepository>()),
    )
    ..registerFactory<DeletePostUseCase>(
      () => DeletePostUseCase(getIt<PostRepository>()),
    )
    ..registerFactory<PostCubit>(
      () => PostCubit(
        getPostsUseCase: getIt<GetPostsUseCase>(),
        createPostUseCase: getIt<CreatePostUseCase>(),
        updatePostUseCase: getIt<UpdatePostUseCase>(),
        patchPostUseCase: getIt<PatchPostUseCase>(),
        deletePostUseCase: getIt<DeletePostUseCase>(),
      ),
    )
    // ---- Feature Auth (Login) ----
    // The login datasource is the only auth dependency that needs the shared
    // Dio instance. Everything else below resolves through it via the
    // repository and use case, mirroring the feature_post pattern.
    ..registerLazySingleton<LoginRemoteDatasource>(
      () => LoginRemoteDatasource(
        getIt<Dio>(),
        baseUrl: _moodleBaseUrl,
      ),
    )
    ..registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(
        remoteDatasource: getIt<LoginRemoteDatasource>(),
      ),
    )
    ..registerFactory<LoginUseCase>(
      () => LoginUseCase(getIt<LoginRepository>()),
    )
    ..registerFactory<LoginCubit>(
      () => LoginCubit(loginUseCase: getIt<LoginUseCase>()),
    )
    ..registerFactory<DashboardCubit>(
      DashboardCubit.new,
    );
}
