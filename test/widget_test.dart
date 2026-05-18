import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/app/app.dart';
import 'package:grabbit/app/router/app_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/features/auth/presentation/screens/sign_up_screen.dart';

void main() {
  testWidgets('app boots into login', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: GrabbitApp()));
    await tester.pumpAndSettle();

    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Grabbit'), findsOneWidget);
  });

  testWidgets('shell navigation switches between main tabs', (tester) async {
    final container = ProviderContainer();
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
    final container = ProviderContainer();
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
    final container = ProviderContainer();
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
    final container = ProviderContainer();
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
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SignUpScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Join Grabbit'), findsOneWidget);
    expect(find.widgetWithText(InkWell, 'Create Account'), findsOneWidget);
  });
}
