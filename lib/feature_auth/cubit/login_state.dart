import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// States for the Login process.
@freezed
class LoginState with _$LoginState {
  /// Initial state before any action.
  const factory LoginState.initial() = LoginInitial;

  /// Loading state while authenticating.
  const factory LoginState.loading() = LoginLoading;

  /// Success state after a valid Moodle login response.
  ///
  /// Parameterless on purpose: the existing `LoginPage` consumes this state
  /// as `state.whenOrNull(success: () => context.go(AppRoutes.dashboard))`.
  /// The obtained token (and username) is persisted to `LocalStorage`
  /// before this state is emitted so subsequent requests can authenticate
  /// via `AuthInterceptor`, and so a later Reconnect can re-use the
  /// username.
  const factory LoginState.success() = LoginSuccess;

  /// Error state with a descriptive message.
  const factory LoginState.error({required String message}) = LoginError;
}
