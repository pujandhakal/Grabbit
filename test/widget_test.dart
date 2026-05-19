import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/app/app.dart';
import 'package:grabbit/app/router/app_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';
import 'package:grabbit/features/auth/domain/entities/user_role.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:grabbit/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:grabbit/features/marketplace/data/repositories/api_shops_repository.dart';
import 'package:grabbit/features/marketplace/data/repositories/mock_shops_repository.dart';
import 'package:grabbit/features/profile/data/repositories/shop_profile_repository.dart';
import 'package:grabbit/features/profile/domain/entities/shop_profile.dart';
import 'package:grabbit/features/requests/data/repositories/api_requests_repository.dart';
import 'package:grabbit/features/requests/data/repositories/mock_requests_repository.dart';

void main() {
  testWidgets('app boots into login', (tester) async {
    final container = _containerWithAuth(role: null);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Grabbit'), findsOneWidget);
  });

  testWidgets('shell navigation switches between main tabs', (tester) async {
    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.home);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Grabbit'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Grabbit'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-requests')));
    await tester.pumpAndSettle();

    expect(find.text('My Requests'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('My Requests'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-chats')));
    await tester.pumpAndSettle();

    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Search chats...'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Search chats...'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('chat detail opens without bottom navigation', (tester) async {
    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go('${RoutePaths.chatDetail}?shop=Tech%20Haven');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Type a message...'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-chats')), findsNothing);
    expect(find.byKey(const ValueKey('nav-profile')), findsNothing);
  });

  testWidgets('request card opens responses page without bottom navigation',
      (tester) async {
    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.requests);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Red Hoodie, Size L').first);
    await tester.pumpAndSettle();

    expect(find.text('Responses'), findsOneWidget);
    expect(find.text('8 shops have responded'), findsOneWidget);
    expect(find.text('Red Hoodie, Size L'), findsOneWidget);
    expect(find.text('Fashion Hub Kathmandu'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Street Style Nepal'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Street Style Nepal'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-requests')), findsNothing);
    expect(find.byKey(const ValueKey('nav-profile')), findsNothing);
  });

  testWidgets('view store opens store details without bottom navigation',
      (tester) async {
    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.requests);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Red Hoodie, Size L').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('View Store').first);
    await tester.pumpAndSettle();

    expect(find.text('Store Details'), findsOneWidget);
    expect(find.text('Fashion Hub Kathmandu'), findsOneWidget);
    expect(find.text('850m away'), findsOneWidget);
    expect(find.text('Open Now'), findsOneWidget);
    expect(find.text('About Store'), findsOneWidget);
    expect(find.text('Customer Reviews'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Recent Activity'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Recent Activity'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Location'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Get Direction'), findsOneWidget);
    expect(find.byTooltip('Contact Store'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-requests')), findsNothing);
    expect(find.byKey(const ValueKey('nav-profile')), findsNothing);
  });

  testWidgets('sign up screen renders create account flow', (tester) async {
    final container = _containerWithAuth(role: null);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: SignUpScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Join Grabbit'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.widgetWithText(InkWell, 'Create Account'), findsOneWidget);
  });

  testWidgets('shop shell navigation switches between shop tabs',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = _containerWithAuth(role: UserRole.shop);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.shopDashboard);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Shop Dashboard'), findsNothing);
    expect(find.text('Kathmandu Electronics'), findsOneWidget);
    expect(find.text('New Requests Near You'), findsOneWidget);
    expect(find.text('Filter & Sort Requests'), findsOneWidget);
    expect(find.text('Looking for Red Hoodie'), findsOneWidget);
    expect(find.text('iPhone 14 Pro Case'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('shop-nav-requests')));
    await tester.pumpAndSettle();

    expect(find.text('Incoming Requests'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('shop-nav-chats')));
    await tester.pumpAndSettle();

    expect(find.text('Shop Chats'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('shop-nav-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Verify Your Store'), findsOneWidget);
  });
}

ProviderContainer _containerWithAuth({required UserRole? role}) {
  return ProviderContainer(
    overrides: [
      authControllerProvider.overrideWith(() => _FakeAuthController(role)),
      requestsRepositoryProvider.overrideWithValue(
        const MockRequestsRepository(),
      ),
      shopsRepositoryProvider.overrideWithValue(const MockShopsRepository()),
      shopProfileProvider.overrideWith(
        (ref) async => const ShopProfile(
          businessName: 'Kathmandu Electronics',
          initials: 'KE',
          categories: ['Electronics'],
          addressText: 'New Baneshwor, Kathmandu',
          phone: '9800000000',
          description: 'Electronics, accessories, and repairs.',
          specialties: ['Electronics', 'Accessories'],
          openStatus: 'Open Now',
          closingTime: 'Closes 9:00 PM',
          typicalResponseTime: '15 minutes',
          landmark: 'Near Civil Hospital',
          isVerified: true,
          rating: 4.8,
          reviewCount: 127,
        ),
      ),
    ],
  );
}

class _FakeAuthController extends AuthController {
  _FakeAuthController(this.role);

  final UserRole? role;

  @override
  Future<UserEntity?> build() async {
    if (role == null) {
      return null;
    }

    return UserEntity(
      id: '1',
      name: role == UserRole.shop ? 'Fashion Hub' : 'Pujan Dhakal',
      email: role == UserRole.shop ? 'shop@example.com' : 'pujan@example.com',
      phone: '',
      role: role!,
      token: '',
    );
  }
}
