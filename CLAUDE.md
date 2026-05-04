# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project shape

Grabbit is a Flutter mobile client (`lib/`) talking to a Node.js + Express + MongoDB backend (`server/`). The README at the repo root is outdated — it describes a React frontend; ignore that. The real client is Flutter. The MERN-style "frontend/backend" split it mentions does not exist in this tree.

## Commands

Flutter client (run from repo root):
- `flutter pub get` — install Dart dependencies after pulling or editing `pubspec.yaml`.
- `flutter run` — launch on the connected device/emulator. Default entrypoint is `lib/main.dart`, which boots `LoginPage`.
- `flutter analyze` — static analysis using `analysis_options.yaml` (extends `package:flutter_lints/flutter.yaml`).
- `flutter test` — run widget/unit tests in `test/`. Single test: `flutter test test/<file>.dart` or `flutter test --plain-name "<test name>"`.
- `flutter pub run flutter_launcher_icons` — regenerate launcher icons after changing `assets/images/grabbit_logo.png` (config lives in `pubspec.yaml` under `flutter_launcher_icons:`).

Backend (run from `server/`):
- `npm install` — install Node dependencies.
- `npm run dev` — start with nodemon (auto-reload).
- `npm start` — start once with `node ./index.js`. Listens on `0.0.0.0:3000`.

## Client ↔ server wiring

- The Flutter client hits the backend over plain HTTP at a hardcoded LAN IP — see `lib/services/auth_service.dart` (`http://192.168.1.69:3000/api/signup`). When working on networked features, expect to update that base URL to match the dev machine's IP, or run the backend locally and use the device emulator's host alias.
- The backend listens on `0.0.0.0:3000` (`server/index.js`) and connects to a MongoDB Atlas cluster via a connection string also hardcoded in `server/index.js`. Treat that as a dev-only setup — don't surface or commit credential changes without asking.
- Routes live in `server/routes/` (currently only `auth.js`, mounted at root in `index.js`). The signup route returns `{ msg }` on 400 and `{ err }` on 500.
- Client error handling lives in `lib/constants/error_handling.dart` (`httpErrorHandle`). It currently reads `body['msg']` for 400 and `body['error']` for 500 — note the 500 case mismatches the server's `{ err }` payload. Fix on either side when touching error flows.

## Flutter app architecture

Two parallel user journeys share the same client:

- **User flow** (`lib/pages/user/`) — entry after login is `UserMainScreen`, a stateful bottom-nav shell with four tabs (`HomePage`, `MyRequestsScreen`, `ChatListScreen`, `UserProfilePage`) plus a central floating "+" that pushes `PostRequestPage`. The active tab is just an index into a `_screens` list — adding a tab means editing both the list and `_buildNavItem` calls in `lib/pages/user/user_main_screen.dart`.
- **Shop flow** (`lib/pages/Shop/`) — currently just `shop_dashboard_page.dart`. Login does not yet route here; the only way in today is via direct navigation. When wiring real auth, the `User.type` field (`"user"` vs shop) is what should drive which root screen is mounted.

Top-level pages (`intro_page.dart`, `login_page.dart`, chat screens) live directly under `lib/pages/`.

### Widgets vs pages

`lib/util/` is the project's component library — every reusable card/tile/button lives here, named by purpose (`live_request_card.dart`, `join_groupbuy_card.dart`, `chat_bubble.dart`, etc.). Shop-specific widgets are nested under `lib/util/Shop/`. **Pages compose util widgets; util widgets do not import pages.** When building a new screen, scan `lib/util/` first — most card patterns already exist.

### Auth + models

- `lib/models/user.dart` mirrors `server/models/user.js`. The Mongoose schema does not store `phone`, `type`, or `token` consistently with the Dart model — when adding fields, update both sides.
- `lib/services/auth_service.dart` is the only service today. It constructs a `User`, posts JSON, and pipes the response through `httpErrorHandle`. New API calls should follow the same shape: build a model, POST/GET via `package:http`, route the response through `httpErrorHandle` with an `onSuccess` callback.
- `lib/main.dart` always opens `LoginPage` — there is no token persistence or auto-login yet. The login button currently navigates straight to `UserMainScreen` without calling the backend (see `login_page.dart`); the signup form is the only path that actually hits `/api/signup`.

### Styling conventions

- Theme is set once in `main.dart` via `GoogleFonts.varelaRoundTextTheme()` — don't re-apply font families per-widget.
- The app's brand gradient is `[Color(0xff00B8DB), Color(0xff009689)]` (cyan→teal), used for the primary CTA, the login icon badge, and the central FAB. Reuse those exact hex values rather than introducing close variants.
- SVG icons are loaded from `assets/images/` via `flutter_svg`. New SVGs must be added to the `assets:` block in `pubspec.yaml` (currently the whole `assets/images/` directory is included).

## Things to know before changing

- `pubspec.yaml` declares Dart SDK `>=3.6.0 <4.0.0`. Flutter version is whatever satisfies that — there's no FVM config.
- There are no integration tests, no CI config, and no lint rules beyond `flutter_lints` defaults.
- The `server/` directory has its own `node_modules/` checked-in status governed by the root `.gitignore` — verify before adding npm deps.
