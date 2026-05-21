import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';

class BrandBadge extends StatelessWidget {
  const BrandBadge({
    this.size = 88,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2.6),
        color: Colors.white.withValues(alpha: 0.86),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2.9),
        child: Image.asset(
          'assets/logos/grabbit_logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
