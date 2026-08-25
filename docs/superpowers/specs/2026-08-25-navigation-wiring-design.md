# Navigation Wiring Design

**Date:** 2026-08-25
**Branch:** `integration/open-prs`
**Status:** Approved (design), pending implementation plan

## Problem

Ten independently-built PRs were merged into `integration/open-prs` (see prior
merge-resolution work in this branch's history). Each feature compiles and
renders correctly in isolation, but they were never arranged to work together:

- Several screens are unreachable from any UI — built and routed, but nothing
  ever navigates to them.
- Several duplicate screens exist for the same purpose (e.g. two calendar
  screens, two "More" screens, three course-detail-shaped screens) because
  each PR assumed it owned that concept.
- The app's entry flow (splash → ??? ) doesn't check any real state — it
  always goes to the login screen after a fixed delay.
- Several interactive rows/buttons across the merged features are `onTap: ()
  {}` no-ops, some with literal `// TODO: Navigate to … later` comments.
- The `Log out` button exists and is reachable but does nothing.
- `main` still has `/` registered by two different routes (`SplashPage` and
  `SetBaseUrlPage`) — a pre-existing bug from before this integration work.

Goal: **one coherent navigable app** — a user can open the app and reach
every screen intended to be reachable through normal taps, with no dead
ends, starting from a real state-driven entry flow (site connection + login
state) rather than a hardcoded redirect.

This is a wiring pass, not a feature-completion pass. Where a target screen
doesn't exist anywhere in the ten merged PRs, the corresponding trigger stays
a no-op — inventing new screens is out of scope.

## Current State (evidence, not proposal)

Gathered by direct code reading before any design work; see "Out of scope"
for what's deliberately not addressed.

| Area | Current behavior |
|---|---|
| `SplashPage._navigateToNext` | Fixed 3s delay, then unconditionally `context.go(AppRoutes.login)` |
| Site connection persistence | `feature_set_base_url` writes nothing to `LocalStorage` — no "site saved" state exists at all |
| Site lookup | `SiteSuggestionCubit` ignores the user's typed query; always looks up a hardcoded demo host |
| Login persistence | `LoginCubit._persistToken` writes `AppConstants.tokenKey` — this part works correctly |
| `/` route | Claimed by both `AppRoutes.splash` and `SetBaseUrlPage` (pre-existing bug) |
| `AppRoutes.reconnect` | Does not exist — `ReconnectPage` has zero route registration anywhere |
| `UserAccountOverlay` "Log out" | Calls `_showNotImplemented(context, 'Log out')` |
| `ReconnectPage` login button | `onPressed: isEnabled ? () {} : null` — enables/disables but never calls anything |
| `LoginCubit.login()` | Requires both `username` and `password`; no username is persisted anywhere today |
| Dashboard bottom nav (5 tabs) | Fully working — cubit-driven body swap, not GoRouter pushes. Not a bug, left as-is |
| `feature_more` More menu | "App settings" row real; Calendar/QR rows and all 4 bottom-nav icons are no-ops; avatar tap is a no-op |
| `feature_app_settings` | "About" row real; General/Space Usage/Sync rows are no-ops |
| `feature_set_base_url` gear/help/QR | All three are no-ops; QR specifically opens a `QrInfoDialog` instead of navigating anywhere |
| Course card taps (`MyCoursesPage`, `AvailableCoursesPage`) | Navigate to `feature_dashboard/DetailsPage` — a third screen, not `CourseDetailsScreen` or `CourseOverviewScreen` |
| `CourseDetailsScreen`, `CourseOverviewScreen` | Both routed (`AppRoutes.courseDetails`, `AppRoutes.courseOverview`) but zero `push`/`go` calls anywhere reach them |
| Notification screens | Both `NotificationScreen` (singular route) and `NotificationsPage` (plural route) are unreached by any push; no bell icon exists anywhere; the bottom nav's "notifications" tab uses a third, separate embedded path |

## Design

### 1. Persisted state & the site "Connect" action

Add `AppConstants.siteUrlKey` (new `LocalStorage` key, alongside the existing
`tokenKey`). `SiteVerificationCard` gains a "Connect" button that appears once
site verification succeeds; tapping it:
1. Persists the site URL under `siteUrlKey` — specifically, whatever host
   `SiteSuggestionCubit`'s successful state currently resolved to (today,
   always the hardcoded demo host regardless of what the user typed; see
   non-goal below). No new resolution logic is added here.
2. Navigates onward — to `AppRoutes.login` if no token exists, else straight
   to `AppRoutes.dashboard`.

**Non-goal:** `SiteSuggestionCubit` ignoring the typed query and always
resolving a hardcoded host is a pre-existing defect in PR #14's own code, not
a navigation-wiring gap. This design persists whatever the flow currently
resolves to; the lookup itself is untouched.

### 2. Entry flow decision tree

`SplashPage._navigateToNext` replaces its hardcoded redirect with:

```
after splash delay:
  site saved? ──no──> AppRoutes.setBaseUrl
       │yes
       ▼
  logged in (has token)? ──no──> AppRoutes.reconnect
       │yes
       ▼
  AppRoutes.dashboard
```

- "Site saved" = `LocalStorage.get(AppConstants.siteUrlKey) != null`.
- "Logged in" = the existing `isLoggedIn` callback already threaded into
  `AppRouter.getRouter` from `main.dart` (currently computed but never read)
  — its already-correct try/catch-guarded token check is reused as-is.
- `SetBaseUrlPage` moves off `/` onto its own real route,
  `AppRoutes.setBaseUrl`. `AppRoutes.splash = '/'` becomes the sole owner of
  the root path, fixing the pre-existing duplicate-route bug.
- `AppRoutes.reconnect` is registered for the first time, pointing at
  `ReconnectPage`.

### 3. Log out wiring

`UserAccountOverlay`'s "Log out" button (reachable today via dashboard header
→ avatar → account overlay) replaces its `_showNotImplemented` call with:

```
Log out tapped
  -> clear tokenKey only (siteUrlKey stays — matches official Moodle app
     behavior: logging out doesn't forget your site)
  -> context.go(AppRoutes.reconnect)
```

**Non-goal:** no "forget this site / switch site" action is added anywhere.
Log out always lands on Reconnect, never back on Set-Base-URL.

### 4. Reconnect's own actions

`ReconnectPage` needs its own wiring or the entry-flow redirect just
relocates the dead end:

- **Username persistence (new):** real login (`LoginCubit._persistToken`)
  additionally persists the submitted username under a new
  `AppConstants.usernameKey`, alongside the token.
- **Login button:** reads `usernameKey` back, calls the same
  `LoginCubit.login(username: saved, password: typed)` used by the real
  login screen. On success, `context.go(AppRoutes.dashboard)`.
  Precondition: per the entry-flow tree in §2, Reconnect is only ever
  reached via Log out (§3), which by definition requires a prior successful
  login — so `usernameKey` is guaranteed to be set whenever this screen is
  shown. There is no direct path to Reconnect for a device that has never
  logged in.
- **Help icon** → `AppRoutes.help` (same destination as Set-Base-URL's help
  link).
- **QR button** → `AppRoutes.qrScanner` (same destination as every other
  "scan a QR code" trigger in the app — one consistent target).
- **Back arrow, "Forgot password"** stay no-ops: no natural "back" screen
  exists from an entry-flow destination, and no forgot-password screen
  exists anywhere in any of the ten merged PRs despite the `AppRoutes.
  forgotPassword` constant existing.

### 5. Screen-level wiring fixes

Connecting existing widgets to destinations that already exist and are
already routed — no new screens, no new architecture:

| Widget | Wiring |
|---|---|
| More menu: Calendar row | → `AppRoutes.calendar` |
| More menu: QR row | → `AppRoutes.qrScanner` |
| More menu: bottom-nav icons (Dashboard / Courses / Chat / Notifications) | → `AppRoutes.dashboard` / `myCourses` / `messages` / `notifications` |
| More menu: avatar tap | → existing `UserAccountOverlay` (same one dashboard header already shows) |
| Set-Base-URL page: gear icon | → `AppRoutes.baseUrlSettings` |
| Set-Base-URL page: help link | → `AppRoutes.help` |
| Set-Base-URL page: QR button | → `AppRoutes.qrScanner` (replaces `QrInfoDialog`-only behavior) |
| `DetailsPage` (course profile, already the wired entry point) | Add "Enter course" action → `AppRoutes.courseOverview` (`CourseOverviewScreen`) |
| `DashboardHeader` | Add bell `IconButton` next to the search icon → `push(AppRoutes.notifications)` (full-screen `NotificationsPage`, not embedded) |

### Course screen decision (rationale)

Three screens currently compete for "show course details": `DetailsPage`
(292 lines, cubit-bound to real dashboard course data — the one actually
wired today), `CourseDetailsScreen` (28 lines + static widgets, same kind of
content as `DetailsPage` — a genuine unwired duplicate), and
`CourseOverviewScreen` (94 lines + content/folder/video-preview widgets — a
materially different "course home/content" screen, not a duplicate of
either). Decision: keep `DetailsPage` as the course-tap entry point (already
data-bound, no reason to re-wire something working), add `CourseOverviewScreen`
as its "Enter course" follow-on destination, and leave `CourseDetailsScreen`
unrouted as the true duplicate.

## Out of Scope

Gathered in one place for clarity:

- The site-lookup API bug (ignores typed input, always queries a hardcoded
  host) — pre-existing defect in PR #14, not a wiring gap.
- `CourseDetailsScreen`, `feature_calendar/CalendarScreen`,
  `feature_dashboard`'s placeholder `MorePage`, `feature_notification/
  NotificationScreen` (singular route) — all stay orphaned and unrouted, not
  deleted. A future cleanup pass can remove them.
- More menu's Blog/Tags rows, App Settings' General/Space Usage/Sync rows,
  Reconnect's "Forgot password" — no corresponding screens exist anywhere in
  any of the ten merged PRs; nothing to wire them to without building new
  screens from scratch.
- A "forget this site / switch site" action.
- Redesigning or restyling any existing screen. The three new interactive
  elements this design requires — a "Connect" button on
  `SiteVerificationCard`, a bell icon on `DashboardHeader`, and an "Enter
  course" action on `DetailsPage` — are minimal, functional additions
  (matching the existing style of each screen), not a visual redesign.
  Everything else in this spec is wiring an `onTap`/`onPressed` that
  already exists to a destination that already exists.

## Testing / Verification

No widget tests are added as part of this work (per project owner's
decision — verification is manual). After implementation:

1. `fvm flutter run` (fresh state — no stored site URL or token).
2. App should land on Set-Base-URL, not Splash-hardcoded-to-Login.
3. Complete Connect → Login → should land on Dashboard.
4. From Dashboard, tap avatar → Log out → should land on Reconnect (not
   Set-Base-URL).
5. On Reconnect, submit password → should re-authenticate and land back on
   Dashboard.
6. Force-quit and relaunch after step 5 → should land on Dashboard directly
   (site + token both persisted).
7. Tap through: More → Calendar, More → QR, More bottom-nav icons, Set-Base-
   URL gear/help/QR (from a fresh install, before connecting), course card →
   DetailsPage → Enter course → CourseOverviewScreen, dashboard header bell
   → Notifications.
8. Confirm Blog/Tags/General/Space Usage/Sync rows remain visibly inert (no
   crash, no navigation) — this is expected, not a bug.
