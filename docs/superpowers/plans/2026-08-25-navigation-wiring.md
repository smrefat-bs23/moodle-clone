# Navigation Wiring Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Wire the ten independently-built, already-merged PRs into one coherent navigable app — a real state-driven entry flow (site connection + login), a working log-out/reconnect loop, and onTap wiring for every screen that's built and routed but currently unreachable.

**Architecture:** No new architecture. This threads the existing `isLoggedIn` check (already computed in `main.dart`, never read) into `SplashPage`, adds one new persisted key (`siteUrlKey`) alongside the existing `tokenKey`/adds `usernameKey`, and connects existing `onTap`/`onPressed` no-ops to existing, already-routed destinations.

**Tech Stack:** Flutter 3.44 (direct SDK at `/Users/bs01706/develop/sdk/flutter_3.44.6-stable` in this dev environment — fvm is not installed here; use `fvm flutter` if available in the execution environment, per CLAUDE.md), go_router, flutter_bloc, the existing `LocalStorage` abstraction (`core/lib/utils/storage/local_storage.dart`).

**Spec:** `docs/superpowers/specs/2026-08-25-navigation-wiring-design.md`

## Global Constraints

- No new package dependencies — every destination and mechanism used here (go_router, flutter_bloc, `LocalStorage`, `showGeneralDialog`) already exists in the project.
- No widget tests are added — per the project owner's explicit decision, verification is manual (final task in this plan is the manual click-through script from the spec's Testing section).
- `flutter analyze` must report 0 errors after every task (it reports 0 errors on the branch today — this is the regression gate for each task).
- Do not touch anything listed under the spec's "Out of Scope" section: the site-lookup API bug, `CourseDetailsScreen`/`feature_calendar`/dashboard's placeholder `MorePage`/`feature_notification.NotificationScreen`, More menu's Blog/Tags rows, App Settings' General/Space Usage/Sync rows, Reconnect's "Forgot password"/back arrow, any "forget this site" action.
- Every new interactive element (Connect action, bell icon, Enter Course button) matches its screen's existing visual style — no redesigns.

---

### Task 1: New storage keys and route constants

**Files:**
- Modify: `core/lib/utils/constants/app_constants.dart:39` (inside `class AppConstants`, after `userIdKey`)
- Modify: `lib/routes/app_routes.dart:105` (inside `abstract class AppRoutes`, after `help`)

**Interfaces:**
- Produces: `AppConstants.siteUrlKey` (`String`), `AppConstants.usernameKey` (`String`) — used by Tasks 2, 3, 4, 5, 6.
- Produces: `AppRoutes.setBaseUrl` (`String`, `/set-base-url`), `AppRoutes.reconnect` (`String`, `/reconnect`) — used by Tasks 2, 5, 6.

- [ ] **Step 1: Add the two new storage keys**

In `core/lib/utils/constants/app_constants.dart`, inside `class AppConstants`, add after the existing `userIdKey` field (currently the last member before the closing `}` at line 39):

```dart
  /// Saved Moodle site URL key in storage — set once the user confirms a
  /// site from the Set Base URL flow; distinct from [tokenKey], which is
  /// cleared on log out while this key is not.
  static const String siteUrlKey = 'site_url';

  /// Persisted username key in storage — set alongside [tokenKey] on a
  /// successful login so the Reconnect screen can re-authenticate without
  /// asking for it again.
  static const String usernameKey = 'username';
```

- [ ] **Step 2: Add the two new route constants**

In `lib/routes/app_routes.dart`, inside `abstract class AppRoutes`, add after the existing `help` field (currently the last member before the closing `}` at line 105):

```dart

  /// Set Base URL route — the "Connect to Moodle" screen. Owns its own
  /// path now; previously incorrectly shared '/' with [splash].
  static const String setBaseUrl = '/set-base-url';

  /// Reconnect route — shown when a site is saved but the user is logged
  /// out (e.g. after Log out), asking only for the password.
  static const String reconnect = '/reconnect';
```

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze core/lib/utils/constants/app_constants.dart lib/routes/app_routes.dart`
Expected: `No issues found!` (both files are pure constant additions, nothing references the new names yet).

- [ ] **Step 4: Commit**

```bash
git add core/lib/utils/constants/app_constants.dart lib/routes/app_routes.dart
git commit -m "feat(routes): add siteUrlKey/usernameKey and setBaseUrl/reconnect routes"
```

---

### Task 2: Entry-flow routing — dedupe '/', register Reconnect, thread isLoggedIn into Splash

**Files:**
- Modify: `lib/routes/app_router.dart`
- Modify: `lib/feature_splash/pages/splash_page.dart`

**Interfaces:**
- Consumes: `AppConstants.siteUrlKey`, `AppRoutes.setBaseUrl`, `AppRoutes.reconnect` (Task 1); the existing `isLoggedIn: Future<bool> Function()` parameter already threaded into `AppRouter.getRouter` from `main.dart` (unchanged).
- Produces: `SplashPage({required Future<bool> Function() isLoggedIn})` — no other task constructs `SplashPage` directly (it's only built by the router), so this signature change has no other call sites to update.

- [ ] **Step 1: Fix the router — dedupe `/`, register Reconnect, add missing route `name`s**

In `lib/routes/app_router.dart`, add this import alongside the other `feature_*` page imports (alphabetical, after the `feature_post` import):

```dart
import 'package:flutter_boilerplate/feature_reconnect/pages/reconnect_page.dart';
```

Replace the Splash `GoRoute` (currently):
```dart
        // Splash Route
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashPage(),
        ),
```
with:
```dart
        // Splash Route
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => SplashPage(isLoggedIn: isLoggedIn),
        ),
```

Replace the duplicate-`/` Set Base URL `GoRoute` (currently):
```dart
        // Set base URL screen (added on main)
        // Set Base URL Route (Connect to Moodle)
        GoRoute(
          path: AppRoutes.splash,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SetBaseUrlPage()),
        ),
```
with (new path, adds `name`):
```dart
        // Set Base URL Route (Connect to Moodle)
        GoRoute(
          path: AppRoutes.setBaseUrl,
          name: AppRoutes.setBaseUrl,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SetBaseUrlPage()),
        ),

        // Reconnect Route — site saved, user logged out.
        GoRoute(
          path: AppRoutes.reconnect,
          name: AppRoutes.reconnect,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ReconnectPage()),
        ),
```

Add `name:` to the three Set Base URL feature routes that are missing it (currently):
```dart
        // Set Base URL feature routes (gear icon / help / QR scanner)
        GoRoute(
          path: AppRoutes.qrScanner,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: QrScannerPage()),
        ),
        GoRoute(
          path: AppRoutes.baseUrlSettings,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: base_url_settings.AppSettingsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.help,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HelpPage()),
        ),
```
replace with:
```dart
        // Set Base URL feature routes (gear icon / help / QR scanner)
        GoRoute(
          path: AppRoutes.qrScanner,
          name: AppRoutes.qrScanner,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: QrScannerPage()),
        ),
        GoRoute(
          path: AppRoutes.baseUrlSettings,
          name: AppRoutes.baseUrlSettings,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: base_url_settings.AppSettingsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.help,
          name: AppRoutes.help,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HelpPage()),
        ),
```

- [ ] **Step 2: Rewrite SplashPage with the entry-flow decision tree**

Replace the full contents of `lib/feature_splash/pages/splash_page.dart` with:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Splash Screen for the Moodle Clone application.
///
/// Displays the official Moodle logo, then after a short delay decides
/// where to send the user based on persisted state:
///   - no saved site -> [AppRoutes.setBaseUrl]
///   - saved site, not logged in -> [AppRoutes.reconnect]
///   - saved site, logged in -> [AppRoutes.dashboard]
class SplashPage extends StatefulWidget {
  /// Creates an instance of [SplashPage].
  const SplashPage({required this.isLoggedIn, super.key});

  /// Checks whether a valid auth token is currently persisted.
  final Future<bool> Function() isLoggedIn;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<bool> _hasSite() async {
    final (siteUrl, _) =
        await di.getIt<LocalStorage>().get<String>(AppConstants.siteUrlKey);
    return siteUrl != null && siteUrl.isNotEmpty;
  }

  /// Navigates to the correct destination after a short splash delay,
  /// based on whether a site is saved and whether the user is logged in.
  Future<void> _navigateToNext() async {
    // Standard splash delay (3 seconds)
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (!await _hasSite()) {
      if (!mounted) return;
      context.go(AppRoutes.setBaseUrl);
      return;
    }

    if (!await widget.isLoggedIn()) {
      if (!mounted) return;
      context.go(AppRoutes.reconnect);
      return;
    }

    if (!mounted) return;
    context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          AppAssets.moodleSplashLogo,
          width: AppSize.splashLogoWidth.w,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.school,
            size: AppSize.splashLogoErrorSize.r,
            color: AppBrandColors.moodleOrange,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze lib/routes/app_router.dart lib/feature_splash/pages/splash_page.dart`
Expected: `No issues found!`

- [ ] **Step 4: Manual check (no site, no token persisted yet)**

This can't be fully exercised until Tasks 3–6 add the persistence writers, but confirm the router itself resolves: run the app (`flutter run`), confirm it lands on the Set Base URL screen after the 3s splash delay (empty storage today means `_hasSite()` is `false`), not a crash or blank screen.

- [ ] **Step 5: Commit**

```bash
git add lib/routes/app_router.dart lib/feature_splash/pages/splash_page.dart
git commit -m "feat(routes): entry-flow decision tree, dedupe '/', register Reconnect route"
```

---

### Task 3: Wire the "Connect" action on the Set Base URL success state

**Files:**
- Modify: `lib/feature_set_base_url/widgets/suggestion/site_verification_section.dart`

**Interfaces:**
- Consumes: `AppConstants.siteUrlKey` (Task 1), `AppRoutes.login`, `AppRoutes.dashboard` (pre-existing), `SiteSuggestionEntity.siteUrl` (pre-existing, `domain/lib/feature_set_base_url/entities/site_suggestion_entity.dart`).
- Produces: nothing new consumed elsewhere — this is the terminal action of the Set Base URL flow.

- [ ] **Step 1: Add the imports needed for persistence and navigation**

In `lib/feature_set_base_url/widgets/suggestion/site_verification_section.dart`, add these three imports (alphabetical, alongside the existing ones):

```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:go_router/go_router.dart';
```

- [ ] **Step 2: Add the `_onConnect` handler and wire it to the existing `ConnectToYourSiteTile.onTap`**

Add this method to the `SiteVerificationSection` class (after `_buildBody`, before the closing `}` of the class):

```dart
  Future<void> _onConnect(
    BuildContext context,
    SiteSuggestionEntity suggestion,
  ) async {
    await di.getIt<LocalStorage>().set<String>(
          AppConstants.siteUrlKey,
          suggestion.siteUrl,
        );
    if (!context.mounted) return;

    final (token, _) =
        await di.getIt<LocalStorage>().get<String>(AppConstants.tokenKey);
    if (!context.mounted) return;

    if (token != null && token.isNotEmpty) {
      context.go(AppRoutes.dashboard);
    } else {
      context.go(AppRoutes.login);
    }
  }
```

This needs `SiteSuggestionEntity` in scope — add its import too:
```dart
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';
```

Then change the `SiteSuggestionSuccess` branch of `_buildBody` from (currently):
```dart
      SiteSuggestionSuccess(:final query, :final suggestions) =>
        _SuggestionContainer(
          key: ValueKey('success-$query'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConnectToYourSiteTile(typedValue: query),
              if (suggestions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                SiteVerificationCard(suggestion: suggestions.first),
              ],
            ],
          ),
        ),
```
to:
```dart
      SiteSuggestionSuccess(:final query, :final suggestions) =>
        _SuggestionContainer(
          key: ValueKey('success-$query'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConnectToYourSiteTile(
                typedValue: query,
                onTap: suggestions.isNotEmpty
                    ? () => _onConnect(context, suggestions.first)
                    : null,
              ),
              if (suggestions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                SiteVerificationCard(suggestion: suggestions.first),
              ],
            ],
          ),
        ),
```

- [ ] **Step 2: Verify it compiles**

Run: `flutter analyze lib/feature_set_base_url/widgets/suggestion/site_verification_section.dart`
Expected: `No issues found!`

- [ ] **Step 3: Manual check**

`flutter run`, land on Set Base URL, type anything and submit — the "Connect to your site" row (with pencil icon) should now show a tap ripple. Tapping it should persist the site and navigate to Login (no token exists yet at this point in the flow).

- [ ] **Step 4: Commit**

```bash
git add lib/feature_set_base_url/widgets/suggestion/site_verification_section.dart
git commit -m "feat(set-base-url): wire Connect action to persist site and navigate on"
```

---

### Task 4: Persist username at login, fix post-login redirect to Dashboard

**Files:**
- Modify: `lib/feature_auth/cubit/login_cubit.dart`
- Modify: `lib/feature_auth/pages/login_page_scaffold.dart`
- Modify: `lib/feature_auth/cubit/login_state.dart` (doc comment only)

**Interfaces:**
- Consumes: `AppConstants.usernameKey` (Task 1).
- Produces: `usernameKey` now reliably persisted after every successful login — consumed by Task 6 (Reconnect's login button).

- [ ] **Step 1: Persist the username alongside the token**

In `lib/feature_auth/cubit/login_cubit.dart`, change the call site inside `login()` from:
```dart
    await _persistToken(token);
    emit(const LoginSuccess());
```
to:
```dart
    await _persistCredentials(token, username);
    emit(const LoginSuccess());
```

Replace the `_persistToken` method:
```dart
  /// Persists the obtained token (if any) under [AppConstants.tokenKey].
  ///
  /// Best-effort: a storage failure is intentionally swallowed because the
  /// user has already authenticated and we'd rather complete the navigation
  /// than show a confusing error for a failed cache write.
  Future<void> _persistToken(LoginTokenEntity? token) async {
    if (token == null) return;
    await di.getIt<LocalStorage>().set<String>(
          AppConstants.tokenKey,
          token.token,
        );
  }
```
with:
```dart
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
```

- [ ] **Step 2: Fix the post-login redirect and its stale doc comment**

In `lib/feature_auth/pages/login_page_scaffold.dart`, change:
```dart
        state.whenOrNull(
          success: () => context.go(AppRoutes.posts),
```
to:
```dart
        state.whenOrNull(
          success: () => context.go(AppRoutes.dashboard),
```

In `lib/feature_auth/cubit/login_state.dart`, the `LoginState.success()` doc comment currently reads:
```dart
  /// Success state after a valid Moodle login response.
  ///
  /// Parameterless on purpose: the existing `LoginPage` consumes this state
  /// as `state.whenOrNull(success: () => context.go(AppRoutes.posts))`. The
  /// obtained token is persisted to `LocalStorage` before this state is
  /// emitted so subsequent requests can authenticate via
  /// `AuthInterceptor`.
  const factory LoginState.success() = LoginSuccess;
```
Change the middle sentence to match the corrected redirect:
```dart
  /// Success state after a valid Moodle login response.
  ///
  /// Parameterless on purpose: the existing `LoginPage` consumes this state
  /// as `state.whenOrNull(success: () => context.go(AppRoutes.dashboard))`.
  /// The obtained token (and username) is persisted to `LocalStorage`
  /// before this state is emitted so subsequent requests can authenticate
  /// via `AuthInterceptor`, and so a later Reconnect can re-use the
  /// username.
  const factory LoginState.success() = LoginSuccess;
```

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze lib/feature_auth/`
Expected: `No issues found!`

- [ ] **Step 4: Manual check**

`flutter run`, complete Connect → Login with any non-empty username/password (the demo `LoginRemoteDatasource` accepts anything against the hardcoded Moodle host) — should land on Dashboard, not the JSONPlaceholder Posts demo screen.

- [ ] **Step 5: Commit**

```bash
git add lib/feature_auth/cubit/login_cubit.dart lib/feature_auth/pages/login_page_scaffold.dart lib/feature_auth/cubit/login_state.dart
git commit -m "fix(auth): persist username at login, redirect to Dashboard not Posts demo"
```

---

### Task 5: Wire Log out to clear the token and route to Reconnect

**Files:**
- Modify: `lib/feature_dashboard/widgets/user_account_overlay.dart`

**Interfaces:**
- Consumes: `AppConstants.tokenKey` (pre-existing, shared `core` package), `AppRoutes.reconnect` (Task 1).

- [ ] **Step 1: Add the imports needed for clearing the token**

`user_account_overlay.dart` already imports a *different*, dashboard-local `AppConstants` (from `feature_dashboard/utils/app_constants.dart`) unprefixed — importing the shared `core` package's `AppConstants`/`LocalStorage` under the same bare name would collide. Add these two imports, aliasing the core package:

```dart
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart' as core;
```

- [ ] **Step 2: Replace the Log out button's no-op**

Change:
```dart
              child: ElevatedButton(
                onPressed: () =>
                    _showNotImplemented(context, 'Log out'),
```
to:
```dart
              child: ElevatedButton(
                onPressed: () async {
                  await di.getIt<core.LocalStorage>().remove(
                        core.AppConstants.tokenKey,
                      );
                  if (!context.mounted) return;
                  context.go(AppRoutes.reconnect);
                },
```

This needs `go_router`'s `context.go` — the file already imports `package:go_router/go_router.dart` (confirmed present), so no new import needed for that part.

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze lib/feature_dashboard/widgets/user_account_overlay.dart`
Expected: `No issues found!`

- [ ] **Step 4: Manual check**

From Dashboard, tap the avatar (top-right) to open the account overlay, tap "Log out" — should land on the Reconnect screen (not Set Base URL, not a crash).

- [ ] **Step 5: Commit**

```bash
git add lib/feature_dashboard/widgets/user_account_overlay.dart
git commit -m "feat(dashboard): wire Log out to clear token and route to Reconnect"
```

---

### Task 6: Wire Reconnect's own login, help, and QR actions

**Files:**
- Modify: `lib/feature_reconnect/widgets/login_button.dart`
- Modify: `lib/feature_reconnect/pages/reconnect_page.dart`
- Modify: `lib/feature_reconnect/widgets/reconnect_header.dart`
- Modify: `lib/feature_reconnect/widgets/reconnect_qr_button.dart`

**Interfaces:**
- Consumes: `AppConstants.usernameKey` (Task 1, populated by Task 4), `AppRoutes.dashboard`, `AppRoutes.help`, `AppRoutes.qrScanner` (pre-existing/Task 2), `LoginCubit`/`LoginState` (pre-existing, `lib/feature_auth/cubit/login_cubit.dart` and `login_state.dart`).
- Produces: `LoginButton({required bool isEnabled, required VoidCallback onPressed})` — new required param; `LoginButton`'s only two call sites are within `feature_reconnect` (just `reconnect_page.dart`, updated in this same task), so no other file needs updating for this signature change.

- [ ] **Step 1: Give `LoginButton` a real `onPressed`**

In `lib/feature_reconnect/widgets/login_button.dart`, change:
```dart
class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.isEnabled});

  final bool isEnabled;
```
to:
```dart
class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isEnabled;
  final VoidCallback onPressed;
```
and change:
```dart
        onPressed: isEnabled ? () {} : null,
```
to:
```dart
        onPressed: isEnabled ? onPressed : null,
```

- [ ] **Step 2: Rewrite ReconnectPage to actually re-authenticate**

Replace the full contents of `lib/feature_reconnect/pages/reconnect_page.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_auth/cubit/login_cubit.dart';
import 'package:flutter_boilerplate/feature_auth/cubit/login_state.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/forgot_password.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/login_button.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/password_field.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_header.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_logo.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_or_divider.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_qr_button.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/user_avatar.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';
import 'package:flutter_boilerplate_core/utils/storage/local_storage.dart';
import 'package:go_router/go_router.dart';

/// Reconnect screen — shown when a site is saved but the user is logged
/// out. Asks only for the password; the username is read back from
/// [AppConstants.usernameKey], persisted by a prior successful login.
class ReconnectPage extends StatefulWidget {
  const ReconnectPage({super.key});

  @override
  State<ReconnectPage> createState() => _ReconnectPageState();
}

class _ReconnectPageState extends State<ReconnectPage> {
  bool _hasPassword = false;
  String _password = '';

  void _onPasswordChanged(String value) {
    _password = value;
    final hasPassword = value.trim().isNotEmpty;

    if (_hasPassword != hasPassword) {
      setState(() {
        _hasPassword = hasPassword;
      });
    }
  }

  Future<void> _onLoginPressed(BuildContext context) async {
    final (username, _) =
        await di.getIt<LocalStorage>().get<String>(AppConstants.usernameKey);
    if (!context.mounted || username == null || username.isEmpty) return;
    context.read<LoginCubit>().login(username: username, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () => context.go(AppRoutes.dashboard),
            error: (message) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            ),
          );
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.mdLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xxs),

                  const ReconnectHeader(),

                  const SizedBox(height: AppSpacing.md),

                  const ReconnectLogo(),

                  const SizedBox(height: AppSpacing.lgXs),

                  const UserAvatar(),

                  const SizedBox(height: AppSpacing.xlSm),

                  PasswordField(onChanged: _onPasswordChanged),

                  const SizedBox(height: AppSpacing.lgMd),

                  LoginButton(
                    isEnabled: _hasPassword,
                    onPressed: () => _onLoginPressed(context),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  const ForgotPassword(),

                  const SizedBox(height: AppSpacing.lg),

                  const ReconnectOrDivider(),

                  const SizedBox(height: AppSpacing.mdLg),

                  const ReconnectQrButton(),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Wire the help icon**

In `lib/feature_reconnect/widgets/reconnect_header.dart`, add these two imports:
```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
```
Change the second `IconButton` (the `help_outline` one) from:
```dart
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSize.headerIconButtonSize,
              minHeight: AppSize.headerIconButtonSize,
            ),
            icon: const Icon(
              Icons.help_outline,
              size: AppSize.headerIconSize,
              color: Color(0xFF212121),
            ),
          ),
```
to:
```dart
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.help),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSize.headerIconButtonSize,
              minHeight: AppSize.headerIconButtonSize,
            ),
            icon: const Icon(
              Icons.help_outline,
              size: AppSize.headerIconSize,
              color: Color(0xFF212121),
            ),
          ),
```
(Leave the first `IconButton`, the `arrow_back` one, untouched — the back arrow stays a no-op per the spec.)

- [ ] **Step 4: Wire the QR button**

In `lib/feature_reconnect/widgets/reconnect_qr_button.dart`, add these two imports:
```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
```
Change:
```dart
        onPressed: () {},
```
to:
```dart
        onPressed: () => context.pushNamed(AppRoutes.qrScanner),
```

- [ ] **Step 5: Verify it compiles**

Run: `flutter analyze lib/feature_reconnect/`
Expected: `No issues found!`

- [ ] **Step 6: Manual check**

Log out from Dashboard to reach Reconnect (per Task 5), type any non-empty password, tap "Log in" — should land back on Dashboard. Tap the help icon — should open the Help page. Tap "Scan QR code" — should open the QR scanner page.

- [ ] **Step 7: Commit**

```bash
git add lib/feature_reconnect/
git commit -m "feat(reconnect): wire login/help/QR actions, complete the reconnect loop"
```

---

### Task 7: Wire the More menu's Calendar/QR rows, bottom-nav icons, and avatar

**Files:**
- Modify: `lib/feature_more/widgets/more_calendar_item.dart`
- Modify: `lib/feature_more/widgets/more_qr_item.dart`
- Modify: `lib/feature_more/widgets/more_bottom_nav.dart`
- Modify: `lib/feature_more/pages/more_page.dart`

**Interfaces:**
- Consumes: `AppRoutes.calendar`, `AppRoutes.qrScanner` (Task 2 added `name:` to the latter), `AppRoutes.dashboard`, `AppRoutes.myCourses`, `AppRoutes.messages`, `AppRoutes.notifications` (all pre-existing, all already have `name:`), `UserAccountOverlay` (pre-existing, `lib/feature_dashboard/widgets/user_account_overlay.dart`).

- [ ] **Step 1: Wire the Calendar row**

In `lib/feature_more/widgets/more_calendar_item.dart`, add imports:
```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
```
Change:
```dart
      onTap: () {
        // Will navigate to detailed Calendar page later
      },
```
to:
```dart
      onTap: () => context.pushNamed(AppRoutes.calendar),
```

- [ ] **Step 2: Wire the QR row**

In `lib/feature_more/widgets/more_qr_item.dart`, add imports:
```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
```
Change:
```dart
      onTap: () {
        // Will navigate to detailed Scan QR Code page later
      },
```
to:
```dart
      onTap: () => context.pushNamed(AppRoutes.qrScanner),
```

- [ ] **Step 3: Wire the bottom-nav icons**

In `lib/feature_more/widgets/more_bottom_nav.dart`, add imports:
```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
```
Change the four `TODO`-marked `onTap`s:
```dart
                _buildNavItem(
                  icon: Icons.speed,
                  isActive: false,
                  onTap: () {
                    // TODO(Nadim): Navigate to Dashboard
                  },
                ),
                _buildNavItem(
                  icon: Icons.school,
                  isActive: false,
                  onTap: () {
                    // TODO(Nadim): Navigate to Courses
                  },
                ),
                _buildNavItem(
                  icon: Icons.forum,
                  isActive: false,
                  onTap: () {
                    // TODO(Nadim): Navigate to Chat
                  },
                ),
                _buildNavItem(
                  icon: Icons.notifications,
                  isActive: false,
                  onTap: () {
                    // TODO(Nadim): Navigate to Notifications
                  },
                ),
```
to:
```dart
                _buildNavItem(
                  icon: Icons.speed,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.dashboard),
                ),
                _buildNavItem(
                  icon: Icons.school,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.myCourses),
                ),
                _buildNavItem(
                  icon: Icons.forum,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.messages),
                ),
                _buildNavItem(
                  icon: Icons.notifications,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.notifications),
                ),
```
(Leave the fifth, `more_horiz`/"Current page" item untouched.)

- [ ] **Step 4: Wire the avatar tap to open the account overlay**

In `lib/feature_more/pages/more_page.dart`, add this import:
```dart
import 'package:flutter_boilerplate/feature_dashboard/widgets/user_account_overlay.dart';
```
Change the avatar's `onTap` in `_buildAppBar` from:
```dart
          child: MoreAvatar(
            name: 'Student User',
            onTap: () {
              // User Profile navigation placeholder
            },
          ),
```
to:
```dart
          child: MoreAvatar(
            name: 'Student User',
            onTap: () => _showUserAccountOverlay(context),
          ),
```
Add this new method to the `MorePage` class (after `_buildAppBar`, before `_buildTopMenu`):
```dart
  /// Shows the shared [UserAccountOverlay], sliding in from the right —
  /// same presentation as the dashboard header's avatar tap.
  void _showUserAccountOverlay(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'UserAccount',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: const UserAccountOverlay(),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(anim1),
          child: child,
        );
      },
    );
  }
```

- [ ] **Step 5: Verify it compiles**

Run: `flutter analyze lib/feature_more/`
Expected: `No issues found!`

- [ ] **Step 6: Manual check**

From the More page: tap Calendar (opens Calendar), tap "Scan QR code" (opens QR scanner), tap each of the 4 bottom-nav icons (Dashboard/Courses/Chat/Notifications — each opens its screen), tap the avatar (opens the account overlay sliding in from the right).

- [ ] **Step 7: Commit**

```bash
git add lib/feature_more/
git commit -m "feat(more): wire Calendar/QR rows, bottom-nav icons, and avatar tap"
```

---

### Task 8: Wire the Set Base URL page's gear icon and help link

**Files:**
- Modify: `lib/feature_set_base_url/widgets/base_url_header.dart`
- Modify: `lib/feature_set_base_url/widgets/help_link.dart`
- Modify: `lib/feature_set_base_url/widgets/qr_scan_button.dart`

**Interfaces:**
- Consumes: `AppRoutes.baseUrlSettings`, `AppRoutes.help`, `AppRoutes.qrScanner` (all given `name:` in Task 2).

- [ ] **Step 1: Wire the gear icon**

In `lib/feature_set_base_url/widgets/base_url_header.dart`, add imports:
```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
```
Change:
```dart
          IconButton(
            onPressed: () {
              // Tap-only: no navigation. The ripple / press state still
              // plays so the button feels responsive.
            },
            splashRadius: AppSize.splashRadius,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSize.iconButtonMinSize,
              minHeight: AppSize.iconButtonMinSize,
            ),
            icon: const Icon(
              Icons.settings,
              size: AppSize.iconSettings,
              color: Color(0xFF212121),
            ),
          ),
```
to:
```dart
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.baseUrlSettings),
            splashRadius: AppSize.splashRadius,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSize.iconButtonMinSize,
              minHeight: AppSize.iconButtonMinSize,
            ),
            icon: const Icon(
              Icons.settings,
              size: AppSize.iconSettings,
              color: Color(0xFF212121),
            ),
          ),
```

- [ ] **Step 2: Wire the help link**

In `lib/feature_set_base_url/widgets/help_link.dart`, add imports:
```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
```
Change:
```dart
        onTap: () {
          // Tap-only: no navigation. The InkWell ripple still plays so
          // the user gets visual feedback that the link was tapped.
        },
```
to:
```dart
        onTap: () => context.pushNamed(AppRoutes.help),
```

- [ ] **Step 3: Replace the QR dialog with real navigation**

In `lib/feature_set_base_url/widgets/qr_scan_button.dart`, remove the now-unused import:
```dart
import 'package:flutter_boilerplate/feature_set_base_url/widgets/qr_info_dialog.dart';
```
Add these two imports in its place:
```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
```
Change:
```dart
        onPressed: () {
          // Tap-only: do NOT navigate to the QR scanner page —
          // just show the informational dialog and dismiss.
          QrInfoDialog.show(context);
        },
```
to:
```dart
        onPressed: () => context.pushNamed(AppRoutes.qrScanner),
```

- [ ] **Step 4: Verify it compiles**

Run: `flutter analyze lib/feature_set_base_url/`
Expected: `No issues found!`

- [ ] **Step 5: Manual check**

From a fresh install (before connecting to a site), on the Set Base URL screen: tap the gear icon (opens the base-URL Settings page), tap "Need help?" (opens Help), tap "Scan QR code" (opens the QR scanner — no dialog).

- [ ] **Step 6: Commit**

```bash
git add lib/feature_set_base_url/widgets/base_url_header.dart lib/feature_set_base_url/widgets/help_link.dart lib/feature_set_base_url/widgets/qr_scan_button.dart
git commit -m "feat(set-base-url): wire gear/help icons, replace QR dialog with real navigation"
```

---

### Task 9: Add the "Enter course" action to DetailsPage

**Files:**
- Modify: `lib/feature_dashboard/pages/details_page.dart`

**Interfaces:**
- Consumes: `AppRoutes.courseOverview` (pre-existing, already has `name:`).

- [ ] **Step 1: Add the button to the course detail layout**

In `lib/feature_dashboard/pages/details_page.dart`, change the children list inside `build`'s `SingleChildScrollView` from:
```dart
                    children: [
                      SizedBox(height: AppSpacing.lg.h),
                      _buildTitleBlock(context, course, safeSp),
                      SizedBox(height: AppSpacing.lg.h),
                      _buildSectionLabel('Teachers', safeSp),
                      SizedBox(height: AppSpacing.sm.h),
                      _buildTeacherRow(context, course, safeSp),
                      Divider(height: AppSpacing.lg.h),
                      _buildComplianceRow(course, safeSp),
                      Divider(height: AppSpacing.lg.h),
                    ],
```
to:
```dart
                    children: [
                      SizedBox(height: AppSpacing.lg.h),
                      _buildTitleBlock(context, course, safeSp),
                      SizedBox(height: AppSpacing.lg.h),
                      _buildSectionLabel('Teachers', safeSp),
                      SizedBox(height: AppSpacing.sm.h),
                      _buildTeacherRow(context, course, safeSp),
                      Divider(height: AppSpacing.lg.h),
                      _buildComplianceRow(course, safeSp),
                      Divider(height: AppSpacing.lg.h),
                      _buildEnterCourseButton(context, safeSp),
                    ],
```

Add this new method (after `_buildComplianceRow`, before `_buildInfoBanner`):
```dart
  Widget _buildEnterCourseButton(
    BuildContext context,
    double Function(double) safeSp,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.pushNamed(AppRoutes.courseOverview),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.moodleOrange,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusSm.r),
          ),
        ),
        child: Text(
          'Enter course',
          style: TextStyle(
            fontSize: safeSp(AppFontSize.lg),
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
```

- [ ] **Step 2: Verify it compiles**

Run: `flutter analyze lib/feature_dashboard/pages/details_page.dart`
Expected: `No issues found!`

- [ ] **Step 3: Manual check**

From Dashboard, open Available Courses or My Courses, tap a course card to reach its detail page, tap "Enter course" at the bottom — should open the Course Overview screen (content/folders/video preview).

- [ ] **Step 4: Commit**

```bash
git add lib/feature_dashboard/pages/details_page.dart
git commit -m "feat(dashboard): add Enter Course action to DetailsPage -> CourseOverviewScreen"
```

---

### Task 10: Add a notification bell to the dashboard header

**Files:**
- Modify: `lib/feature_dashboard/widgets/dashboard_header.dart`

**Interfaces:**
- Consumes: `AppRoutes.notifications` (pre-existing, already has `name:`).

- [ ] **Step 1: Add the bell icon and its import**

In `lib/feature_dashboard/widgets/dashboard_header.dart`, add these two imports:
```dart
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
```

Add a new `IconButton` between the existing search `IconButton` and the avatar `GestureDetector` in the `actions` list:
```dart
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: AppColors.black87,
            size: AppSize.iconMdLg.w,
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const SearchPage(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: AppColors.black87,
            size: AppSize.iconMdLg.w,
          ),
          onPressed: () => context.pushNamed(AppRoutes.notifications),
        ),
        GestureDetector(
```
(the `GestureDetector` that follows is the existing avatar block — leave it and everything inside it unchanged.)

- [ ] **Step 2: Verify it compiles**

Run: `flutter analyze lib/feature_dashboard/widgets/dashboard_header.dart`
Expected: `No issues found!`

- [ ] **Step 3: Manual check**

From Dashboard, the header now shows a bell icon between the search icon and the avatar. Tapping it opens the full-screen Notifications page (distinct from the bottom nav's embedded Notifications tab).

- [ ] **Step 4: Commit**

```bash
git add lib/feature_dashboard/widgets/dashboard_header.dart
git commit -m "feat(dashboard): add notification bell icon to header"
```

---

### Task 11: Full-repo static check and end-to-end manual verification

**Files:** none (verification only)

**Interfaces:** none — this task exercises every interface produced by Tasks 1–10 together.

- [ ] **Step 1: Full-repo analyze**

Run: `flutter analyze`
Expected: `No issues found!` — 0 errors, 0 new warnings introduced by this plan (the pre-existing ~500 info-level lints unrelated to these files are unaffected and not a regression).

- [ ] **Step 2: Fresh-state manual walkthrough**

Uninstall/reset the app's local storage (or run on a fresh simulator), then `flutter run`, and walk through the spec's verification script exactly:

1. App should land on Set Base URL (not the old hardcoded Login redirect).
2. Type a URL, submit, tap the "Connect to your site" row — should navigate to Login (no token saved yet).
3. Log in with any credentials — should land on Dashboard (not the Posts demo).
4. From Dashboard, tap avatar → Log out — should land on Reconnect (not Set Base URL).
5. On Reconnect, type a password, tap "Log in" — should re-authenticate and land back on Dashboard.
6. Force-quit and relaunch — should land on Dashboard directly (site + token both persisted, no Set Base URL or Reconnect detour).
7. Tap through: More → Calendar, More → QR, More's 4 bottom-nav icons, More's avatar; Set Base URL's gear/help/QR (from a fresh install, before connecting); a course card → DetailsPage → "Enter course" → CourseOverviewScreen; the dashboard header's bell icon → Notifications.
8. Confirm More menu's Blog/Tags rows and App Settings' General/Space Usage/Sync rows remain visibly inert (no crash, no navigation, no snackbar surprise) — expected, not a bug.

- [ ] **Step 3: Report back**

If every step in the walkthrough matches its expected outcome, the plan is complete — no commit needed for this task (verification only). If anything doesn't match, note exactly which step and what happened, and treat it as a new, scoped bug fix rather than reopening an earlier task.
