# MOODLE_SET_BASE_URL_MASTER_SPEC.md

## Purpose

This document is the **single source of truth** for implementing the Moodle-style **Set Base URL** flow in this Flutter project.

The app already opens to the **Set Base URL** page on launch.  
Continue from the current progress and finish the remaining work so the behavior and UI match the official Moodle app as closely as possible.

Use the uploaded screenshots as the visual reference for every page and interaction.

---

## Highest Priority Rules

### 1) Modify only `lib/`
This is an enterprise-level project.

You are allowed to make changes **only inside the `lib/` directory**.

Do **not** change anything outside `lib/`, including but not limited to:

- `pubspec.yaml`
- `android/`
- `ios/`
- `web/`
- `windows/`
- `linux/`
- `macos/`
- `test/`
- `assets/`
- `.github/`
- build files
- Gradle files
- Podfiles
- CI/CD files
- project settings
- flavor config
- localization config
- any root-level files

If anything seems to require a change outside `lib/`, stop and solve it inside `lib/` instead.

### 2) Preserve existing progress
Do **not** restart the feature from scratch.

Continue from the current implementation.

If something is wrong, fix only the broken part and keep going.

### 3) No hardcoded values
Do not hardcode values when constants or reusable values can be used.

Avoid hardcoding:

- colors
- strings
- sizes
- spacing
- padding
- margin
- radius
- durations
- animation values

Use centralized constants or existing theme values whenever possible.

### 4) Keep files small and reusable
Split code into many small files.

Prefer keeping each Dart file under about 100 lines whenever practical.

Use reusable widgets and reusable helpers.

---

## Main Goal

Implement the full **Set Base URL** experience so it behaves like the official Moodle mobile app.

The following must be accurate:

- UI layout
- spacing
- font sizes
- font weights
- colors
- loading states
- empty states
- suggestion list behavior
- navigation behavior
- dialogs
- help pages
- QR scanner page
- app settings page

Target approximately **99% visual accuracy** with the provided screenshots.

---

## API Requirement

Use this API endpoint for Moodle site info / suggestions logic:

**URL:**  
`https://lmsmobile.ahnafmuttaki.com/webservice/rest/server.php`

**Parameters:**

- `moodlewsrestformat=json`
- `wstoken=5dc0f086abc4b82a1562b01a20637705`
- `wsfunction=core_webservice_get_site_info`

Use the existing networking style if available.

The networking layer should be reusable for future Moodle APIs.

---

## Search / Suggestions Behavior

The search box must behave like the official Moodle app.

When the user starts typing:

- call the API with debounce
- do not spam requests
- cancel / ignore previous in-flight requests if a newer query comes in
- show loading while fetching
- show suggestions dynamically
- show empty state when nothing matches
- show error state when the request fails
- keep the UI responsive

The suggestions must update exactly based on what the user types, matching the official app behavior as closely as possible.

If the current implementation does not return all expected suggestions, investigate and fix it.

---

## Label Behavior

The **"Your site"** label must behave like the Moodle app.

### Initial state
- black
- normal weight

### When the field gets focus
- black
- bold

### When focus is lost without typing anything
- red
- normal weight

### When the field is focused again after being invalid
- red
- bold

### When the 3rd character is typed
- turn green immediately
- stay bold while focused

Use the screenshot colors exactly.

Do not approximate colors.

---

## Screens to Implement

Implement all pages and states shown in the screenshots:

- Connect to Moodle
- Search suggestions list
- Search loading state
- Help page
- QR code scanner page
- QR info dialog
- App settings page

Navigation between these pages must work like the official app.

Tap actions must open the correct screen in the correct way.

---

## UI / Pixel Perfect Rules

Use the screenshots as the visual spec.

Match as closely as possible:

- top bar alignment
- title font weight
- icon sizes
- button shapes
- text positioning
- spacing between items
- divider positions
- loader placement
- dialog sizing
- list row height
- image placement
- search field layout
- keyboard overlap behavior

The whole experience should look and feel like the screenshots.

If any part is currently incorrect, fix it rather than layering new code on top.

---

## Architecture Rules

Follow the existing project architecture.

Reuse:

- existing theme
- existing constants
- existing widgets
- existing helpers
- existing DI
- existing state management
- existing networking patterns

Do **not** introduce a second architecture.

Use Clean Architecture concepts where appropriate:

- Presentation
- Domain
- Data

If needed, create:

- entity
- model
- repository
- repository implementation
- use case
- remote data source
- API service
- cubit / bloc
- states / events

---

## Code Quality Rules

Follow SOLID and DRY.

Prefer:

- `const` constructors
- `final` variables
- small methods
- small widgets
- reusable components
- clear file names
- separation of concerns

Do not duplicate logic.

Do not make a single large widget file.

---

## Error Handling

Handle properly:

- no internet
- timeout
- server error
- invalid response
- unknown error

Show user-friendly UI for each state.

---

## Deliverables After Implementation

After finishing, provide:

1. Newly created files
2. Modified files
3. What each file does
4. Confirmation that only `lib/` was modified
5. Confirmation that no hardcoded values were introduced
6. Confirmation that the implementation matches the screenshots as closely as possible
7. Mention any remaining differences, if any, and fix them instead of leaving them unresolved

---

## Final Reminder

This project must stay clean, maintainable, modular, and enterprise-safe.

Only modify `lib/`.

Continue from the current progress.

Use the screenshots as the reference for everything.
