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
      body: _AnimatedBranchSwitcher(navigationShell: navigationShell),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        child: Container(
          height: 82,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.22),
                blurRadius: 40,
                spreadRadius: -4,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.10),
                blurRadius: 12,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  navKey: const ValueKey('nav-home'),
                  selected: navigationShell.currentIndex == 0,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_outlined,
                  onTap: () => _onDestinationSelected(0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  navKey: const ValueKey('nav-requests'),
                  selected: navigationShell.currentIndex == 1,
                  icon: Icons.receipt_long_outlined,
                  selectedIcon: Icons.receipt_long_outlined,
                  onTap: () => _onDestinationSelected(1),
                ),
              ),
              _AddNavButton(onTap: () => context.push(RoutePaths.postRequest)),
              Expanded(
                child: _NavItem(
                  navKey: const ValueKey('nav-chats'),
                  selected: navigationShell.currentIndex == 2,
                  icon: Icons.chat_bubble_outline_rounded,
                  selectedIcon: Icons.chat_bubble_outline_rounded,
                  onTap: () => _onDestinationSelected(2),
                ),
              ),
              Expanded(
                child: _NavItem(
                  navKey: const ValueKey('nav-profile'),
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

class _AddNavButton extends StatelessWidget {
  const _AddNavButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.32),
            blurRadius: 18,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: const SizedBox(
            width: 52,
            height: 52,
            child: Icon(Icons.add, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.navKey,
    required this.selected,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  });

  final Key navKey;
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
        customBorder: const StadiumBorder(),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(end: selected ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            builder: (context, t, _) {
              return Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.lerp(
                    Colors.transparent,
                    AppColors.primarySoft,
                    t,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Transform.scale(
                  scale: 0.88 + 0.12 * t,
                  child: Icon(
                    selected ? selectedIcon : icon,
                    color: Color.lerp(
                      AppColors.textMuted,
                      AppColors.primaryDark,
                      t,
                    ),
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AnimatedBranchSwitcher extends StatefulWidget {
  const _AnimatedBranchSwitcher({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<_AnimatedBranchSwitcher> createState() =>
      _AnimatedBranchSwitcherState();
}

class _AnimatedBranchSwitcherState extends State<_AnimatedBranchSwitcher>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _lastIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 1,
    );
    _lastIndex = widget.navigationShell.currentIndex;
  }

  @override
  void didUpdateWidget(_AnimatedBranchSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != _lastIndex) {
      _lastIndex = widget.navigationShell.currentIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(curved),
        child: widget.navigationShell,
      ),
    );
  }
}
