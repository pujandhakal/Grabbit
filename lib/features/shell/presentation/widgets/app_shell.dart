import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({
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
      extendBody: true,
      body: navigationShell,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => context.push(RoutePaths.postRequest),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Container(
          height: 82,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  navKey: const ValueKey('nav-home'),
                  label: 'Home',
                  selected: navigationShell.currentIndex == 0,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_outlined,
                  onTap: () => _onDestinationSelected(0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  navKey: const ValueKey('nav-requests'),
                  label: 'Requests',
                  selected: navigationShell.currentIndex == 1,
                  icon: Icons.receipt_long_outlined,
                  selectedIcon: Icons.receipt_long_outlined,
                  onTap: () => _onDestinationSelected(1),
                ),
              ),
              const SizedBox(width: 72),
              Expanded(
                child: _NavItem(
                  navKey: const ValueKey('nav-chats'),
                  label: 'Chats',
                  selected: navigationShell.currentIndex == 2,
                  icon: Icons.chat_bubble_outline_rounded,
                  selectedIcon: Icons.chat_bubble_outline_rounded,
                  onTap: () => _onDestinationSelected(2),
                ),
              ),
              Expanded(
                child: _NavItem(
                  navKey: const ValueKey('nav-profile'),
                  label: 'Profile',
                  selected: navigationShell.currentIndex == 3,
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_outline_rounded,
                  onTap: () => _onDestinationSelected(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.navKey,
    required this.label,
    required this.selected,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  });

  final Key navKey;
  final String label;
  final bool selected;
  final IconData icon;
  final IconData selectedIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: navKey,
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Align(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 52,
            padding: EdgeInsets.symmetric(
              horizontal: selected ? 18 : 0,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF323232) : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: selected
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(selectedIcon, color: Colors.white, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  )
                : Icon(
                    icon,
                    color: Colors.white.withValues(alpha: 0.62),
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}
