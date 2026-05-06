# Grabbit

A Real-Time Platform Connecting Buyers with Local Shops

## Overview

Grabbit is a platform designed to bridge the gap between consumers and local shops. It allows users to post real-time requests for specific products, enabling nearby shops to respond with offers if they have the item in stock. This promotes efficient shopping, supports local businesses, and fosters direct buyer-seller connections without the need for shops to maintain online inventories.


## Problems Addressed

Grabbit tackles common challenges in local shopping:
1. Consumers often struggle to find specific items in nearby shops.
2. Wasted time visiting multiple stores or relying on delayed online shopping.
3. Local shops miss sales because potential customers don't know what they offer.

## Solution

1. Grabbit allows users to post product requests in real-time.
2. Nearby shops can respond only if they have the requested item. The user picks the best offer.
3. Promotes unique, local products and builds direct buyer-seller connections.

## How It Works

1. User signs up and posts a request for a product.
2. Nearby shops see the request and respond if available.
3. User compares responses and chooses a shop with the best offer.
4. Direct connection is made for purchase (user goes in-person to purchase).

## Key Features

1. No shop inventory setup required.
2. GroupBuy discounts based on collective interest – shops offer deals unlocked when enough users join.
3. Real-time request and response system.
4. Shop ratings and reviews.

## Business Model

- **Users**: Freemium model for all users.
- **Shops**:
  - **Freemium Features**: Respond to a limited number of requests for free.
  - **Premium Features**: Unlimited responses, featured listings, analytics, and in-app promotions.

## Technologies Used

- **UI Design**: Figma
- **Mobile Client**: Flutter (Dart)
- **Backend**: Node.js + Express
- **Database**: MongoDB (Atlas)

## Feasibility

1. No inventory uploads for the shop.
2. Simple, intuitive UI for both users and vendors.

## Future Scope

1. Offline request drafting with sync when reconnected.
2. Analytics dashboard for shopkeepers.
3. Smart matching based on location, urgency, and product type.

## Team

- **Team Name**: Visioneers
- **Institution**: Everest Engineering College
- **Members**:
  - Saurav Pant
  - Pujan Dhakal

## Repository Layout

- `lib/` — Flutter app (entrypoint `lib/main.dart`).
  - `pages/` — screens, split into `user/` and `Shop/` flows.
  - `util/` — reusable widgets and cards composed by pages.
  - `services/` — API clients (e.g. `auth_service.dart`).
  - `models/`, `constants/` — data models and shared helpers.
- `server/` — Node.js + Express backend.
  - `index.js` — entrypoint, listens on port 3000.
  - `routes/` — Express route handlers.
  - `models/` — Mongoose schemas.
- `assets/images/` — bundled icons and SVGs (declared in `pubspec.yaml`).

## Installation and Setup

### Prerequisites

- Flutter SDK (Dart `>=3.6.0 <4.0.0`)
- Node.js (v18+) and npm
- A MongoDB connection string (Atlas or local)
- Android Studio / Xcode for running on an emulator or device

### 1. Clone the repository

```
git clone https://github.com/your-repo/grabbit.git
cd grabbit
```

### 2. Run the backend

```
cd server
npm install
npm run dev      # nodemon, auto-reloads on change
# or: npm start
```

The server listens on `0.0.0.0:3000`. The MongoDB URI is currently set inline in `server/index.js` — replace it with your own connection string before running.

### 3. Run the Flutter client

From the repo root:

```
flutter pub get
flutter run
```

The client makes HTTP calls to a hardcoded LAN address (see `lib/services/auth_service.dart`, e.g. `http://192.168.1.69:3000`). Update the host to match the machine running the backend — your dev machine's LAN IP for a physical device, or `10.0.2.2` for the Android emulator.

### 4. Useful commands

- `flutter analyze` — static analysis.
- `flutter test` — run widget/unit tests.
- `flutter pub run flutter_launcher_icons` — regenerate launcher icons after replacing `assets/images/grabbit_logo.png`.

## Demo

For a live demo, refer to the project presentation or contact the team.

## Contributing

Contributions are welcome. Please fork the repository and open a pull request with your changes.

## License

This project is licensed under the MIT License.