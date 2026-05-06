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
    expect(find.text('Home'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-chats')));
    await tester.pumpAndSettle();

    expect(find.text('Search chats...'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-profile')));
    await tester.pumpAndSettle();

    expect(find.text('My Profile'), findsOneWidget);
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
