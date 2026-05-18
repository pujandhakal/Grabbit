import 'package:flutter/material.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';

class AppStickyPage extends StatelessWidget {
  const AppStickyPage({
    required this.header,
    required this.child,
    this.headerPadding = const EdgeInsets.fromLTRB(16, 18, 16, 14),
    this.bottomSafeArea = false,
    super.key,
  });

  final Widget header;
  final Widget child;
  final EdgeInsetsGeometry headerPadding;
  final bool bottomSafeArea;

  @override
  Widget build(BuildContext context) {
    return AppSoftBackground(
      child: SafeArea(
        bottom: bottomSafeArea,
        child: Column(
          children: [
            Padding(
              padding: headerPadding,
              child: header,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.bottom,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Expanded(child: textColumn),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
          ],
        ),
        if (bottom != null) ...[
          const SizedBox(height: 16),
          bottom!,
        ],
      ],
    );
  }
}
