import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';

enum AppStatusTone {
  primary,
  accent,
  blue,
  neutral,
}

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    required this.label,
    this.tone = AppStatusTone.primary,
    super.key,
  });

  final String label;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    late final Color background;
    late final Color foreground;

    switch (tone) {
      case AppStatusTone.primary:
        background = AppColors.primarySoft;
        foreground = AppColors.primaryDark;
      case AppStatusTone.accent:
        background = AppColors.accentSoft;
        foreground = AppColors.accent;
      case AppStatusTone.blue:
        background = AppColors.blueSoft;
        foreground = AppColors.blue;
      case AppStatusTone.neutral:
        background = const Color(0xFFF2F5F4);
        foreground = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
