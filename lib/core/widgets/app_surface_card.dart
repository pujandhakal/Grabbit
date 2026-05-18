import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';

class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 28,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.22),
            blurRadius: 40,
            spreadRadius: -4,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.12),
            blurRadius: 14,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    required this.icon,
    this.backgroundColor = AppColors.primarySoft,
    this.foregroundColor = AppColors.primaryDark,
    this.size = 48,
    super.key,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size / 2.8),
      ),
      child: Icon(icon, color: foregroundColor),
    );
  }
}
