# CLAUDE.md

This file provides repository-specific guidance for coding agents working in this project.

## Project shape

Grabbit is a Flutter client in `lib/` with a Node.js + Express + MongoDB backend in `server/`. The active Flutter architecture is feature-first:

- `lib/app/` - bootstrap, theme, router
- `lib/core/` - shared config, networking, errors, reusable widgets
- `lib/features/` - vertical feature modules such as `auth`, `home`, `requests`, `chat`, `profile`, `shop`, and `shell`

Legacy Flutter folders (`pages`, `util`, `services`, `models`, `constants`) were removed. New work should follow the current structure rather than recreating screen-first folders.

## Commands

Flutter client (run from repo root):
- `flutter pub get` - install Dart dependencies after editing `pubspec.yaml`
- `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000` - run against a local backend on Android emulator
- `flutter analyze` - static analysis using `flutter_lints`
- `flutter test` - run widget/unit tests
- `flutter test test/features/auth/presentation/auth_controller_test.dart` - run one focused test file

Backend (run from `server/`):
- `npm install`
- `npm run dev`
- `npm start`

## Architecture rules

- Use Riverpod for state management and dependency injection. Shared async feature state belongs in feature controllers/providers, not in widgets.
- Use `go_router` for app navigation. Top-level routes are defined in `lib/app/router/app_router.dart`; avoid scattering route construction across screens.
- Keep networking behind `lib/core/network/api_client.dart`. Repositories should depend on abstractions and return domain entities, not raw `http.Response`.
- Reusable code goes in `core/` only if it is genuinely cross-feature. Feature-specific widgets, controllers, and repository code stay inside the owning feature.
- Avoid passing `BuildContext` into repositories or network code. UI feedback such as snackbars belongs in presentation.

## Client-server wiring

- The Flutter app reads the backend URL from `AppConfig.defaultBaseUrl`, which comes from `--dart-define=API_BASE_URL=...`.
- The current default is `http://10.0.2.2:3000`, which is correct for Android emulator talking to a backend running on the same machine.
- The backend listens on `0.0.0.0:3000` in `server/index.js`.
- The signup flow is the only real API-backed auth flow today. It posts to `/api/signup` through the auth repository.
- `server/index.js` still contains a hardcoded MongoDB connection string. Treat that as a dev-only leftover, not a pattern to copy.

## Current app behavior

- App entrypoint is `lib/main.dart`, which boots `ProviderScope` and `GrabbitApp`.
- Initial route is `/login`.
- Main authenticated shell is a `StatefulShellRoute.indexedStack` with tabs for home, requests, chats, and profile.
- `post-request` and `shop-dashboard` are separate leaf routes outside the bottom-nav shell.
- Login is still a UI-only transition to the shell. Signup is wired to the backend. Do not assume token persistence or a real login API exists yet.

## Testing expectations

- Keep tests under `test/`, preferably mirroring the feature structure.
- When changing repositories/controllers, add targeted unit tests.
- When changing routing or screen composition, keep at least one widget-level smoke test covering the path.
- Before finishing, run `flutter analyze` and `flutter test`.
