import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';

class AppSoftBackground extends StatelessWidget {
  const AppSoftBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -40,
            child: _GlowCircle(
              size: 260,
              color: AppColors.backgroundTint,
            ),
          ),
          Positioned(
            top: 40,
            right: -80,
            child: _GlowCircle(
              size: 240,
              color: Color(0x22FFFFFF),
            ),
          ),
          Positioned(
            bottom: 40,
            right: -50,
            child: _GlowCircle(
              size: 200,
              color: Color(0x1A26B8A2),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
