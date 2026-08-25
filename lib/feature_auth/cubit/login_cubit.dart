import 'package:bloc/bloc.dart';
import 'package:flutter_boilerplate/feature_auth/cubit/login_state.dart';
import 'package:flutter_boilerplate/feature_auth/data/repositories/login_auth_messages.dart';
import 'package:flutter_boilerplate/feature_auth/domain/entities/login_token_entity.dart';
import 'package:flutter_boilerplate/feature_auth/domain/usecases/login_usecase.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:injectable/injectable.dart';

/// Cubit to manage Login logic and state.
///
/// Orchestrates the login flow:
///   1. Validate that the credentials are non-empty.
///   2. Emit [LoginLoading].
///   3. Delegate the actual network call to [LoginUseCase].
///   4. Persist the returned token so the [AuthInterceptor] can attach it
///      as `Bearer` on subsequent requests.
///   5. Emit [LoginSuccess] or [LoginError] depending on the [Result].
@injectable
class LoginCubit extends Cubit<LoginState> {
  /// Creates a [LoginCubit].
  LoginCubit({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginInitial());

  final LoginUseCase _loginUseCase;

  /// Attempts to log in with the provided credentials.
  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      _emitValidationError(loginEmptyCredentialsMessage);
      return;
    }

    emit(const LoginLoading());

    final (token, failure) =
        await _loginUseCase(username: username, password: password);

    if (failure != null) {
      emit(LoginError(message: failure.message));
      return;
    }

    await _persistCredentials(token, username);
    emit(const LoginSuccess());
  }

  /// Emits a [LoginError] for client-side validation failures.
  ///
  /// Resets to [LoginInitial] first so each empty-attempt is a real state
  /// change. Without the reset, two consecutive empty submissions would
  /// emit the same `LoginError` value back-to-back, and bloc would
  /// deduplicate the second one — the SnackBar in `LoginPageScaffold`
  /// would only fire on the first tap.
  void _emitValidationError(String message) {
    emit(const LoginInitial());
    emit(LoginError(message: message));
  }

  /// Persists the obtained token (if any) under [AppConstants.tokenKey],
  /// and the [username] under [AppConstants.usernameKey] so the Reconnect
  /// screen can re-authenticate later without asking for it again.
  ///
  /// Best-effort: a storage failure is intentionally swallowed because the
  /// user has already authenticated and we'd rather complete the navigation
  /// than show a confusing error for a failed cache write.
  Future<void> _persistCredentials(
    LoginTokenEntity? token,
    String username,
  ) async {
    if (token == null) return;
    await di.getIt<LocalStorage>().set<String>(
          AppConstants.tokenKey,
          token.token,
        );
    await di.getIt<LocalStorage>().set<String>(
          AppConstants.usernameKey,
          username,
        );
  }

  /// Resets the state to initial.
  void reset() => emit(const LoginInitial());
}
