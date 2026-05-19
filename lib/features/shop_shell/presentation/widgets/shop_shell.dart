import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/theme/app_theme.dart';

class ShopShell extends StatelessWidget {
  const ShopShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        indicatorColor: AppColors.primarySoft,
        destinations: const [
          NavigationDestination(
            key: ValueKey('shop-nav-dashboard'),
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            key: ValueKey('shop-nav-requests'),
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox_rounded),
            label: 'Requests',
          ),
          NavigationDestination(
            key: ValueKey('shop-nav-chats'),
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          NavigationDestination(
            key: ValueKey('shop-nav-profile'),
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Shop',
          ),
        ],
      ),
    );
  }
}
