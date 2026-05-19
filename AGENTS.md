# Repository Guidelines

## Project Structure & Module Organization
`lib/` now uses a feature-first Flutter layout. `lib/app/` contains bootstrap, routing, and theme setup. `lib/core/` contains shared config, networking, realtime connection setup, errors, and reusable widgets. `lib/features/` contains vertical slices such as `auth`, `requests`, `chat`, `profile`, `marketplace`, `shop_dashboard`, `customer_shell`, and `shop_shell`. Customer and shop interfaces are separate shells and should keep role-specific screens inside their owning feature. Each feature keeps its own `data`, `domain`, and `presentation` layers when needed. Tests live in `test/`, mirroring features where practical. Static assets remain in `assets/images/`. The backend stays isolated in `server/`.

## Build, Test, and Development Commands
From the repo root:

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
flutter analyze
flutter test
```

Use `flutter pub get` after changing dependencies, `flutter run` to launch locally, `flutter analyze` for linting, and `flutter test` for widget/unit tests. Use `http://10.0.2.2:3000` for the Android emulator. When testing from a physical phone, pass the laptop's LAN IP instead, for example `--dart-define=API_BASE_URL=http://192.168.x.x:3000`. For the backend:

```bash
cd server
npm install
npm run dev
```

## Coding Style & Naming Conventions
Follow `flutter_lints` and keep Dart formatted with `dart format .`. Use 2-space indentation, `PascalCase` for classes, `camelCase` for members, and `snake_case.dart` for file names. Keep feature code inside its owning module; only move code into `core/` when it is generic across features. Do not add direct `http` calls, route pushes, or `BuildContext`-driven side effects inside repositories.

## Architecture & State Management
Use Riverpod for dependency injection and shared state. Providers live close to the feature they serve, for example `features/auth/presentation/controllers/`. Use `go_router` for navigation via `lib/app/router/app_router.dart`; do not reintroduce scattered `Navigator.push` flows for top-level routes. Put API access behind `core/network/api_client.dart` and expose feature repositories through interfaces. Realtime request updates use Socket.IO through `core/realtime/realtime_connection.dart`; keep socket event handling centralized there and invalidate feature providers rather than mutating UI state directly.

## Requests & Shop Responses
Customer request posting and shop responses are dynamic through the backend. Keep request DTO mapping in `features/requests/data/models/`, repository contracts in `features/requests/domain/repositories/`, and UI behavior in `features/requests/presentation/`. Shops can create and edit their own responses; backend routes should enforce role checks, category matching, and ownership before writing. When adding request or response fields, update the backend DTO, Flutter model, mock repository, and affected tests together.

## Testing Guidelines
Place tests under `test/` with names ending in `_test.dart`. Prefer feature-local tests such as `test/features/auth/...`. Add repository tests for API mapping and controller tests for async state transitions. Run `flutter test` before opening a PR; the repo currently expects both routing smoke tests and auth flow tests to stay green.

## Security & Configuration Tips
Do not commit secrets or device-specific URLs. The Flutter client reads its base URL from `--dart-define=API_BASE_URL=...` with a default of `http://10.0.2.2:3000`. Physical-device testing needs a temporary LAN IP in the run command, not in source files. The backend still contains a hardcoded MongoDB connection string in `server/index.js`; treat it as dev-only and do not expand that pattern in new code.
