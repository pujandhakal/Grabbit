import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';

/// Which edge the radar's emitting node is anchored to. Ripples always sweep
/// outward from the node toward the opposite edge.
enum RadarNodeSide { left, right }

/// A point of interest the radar discovers, placed at a fractional position
/// within the strip. [glyph] hints at what it represents (a shop, a request…).
class RadarPin {
  const RadarPin({
    required this.fx,
    required this.fy,
    required this.color,
    required this.glyph,
  });

  /// Horizontal position as a fraction of the available width (0..1).
  final double fx;

  /// Vertical position as a fraction of the available height (0..1).
  final double fy;
  final Color color;
  final IconData glyph;
}

/// A sonar-style "discovery" animation: an anchored node emits expanding ripples
/// and the [pins] around it "ping" (brighten + grow) as each wavefront passes.
///
/// Used to depict Grabbit's match loop from either side — a shop discovering
/// nearby requests, or a customer's request reaching nearby shops.
class AppDiscoveryRadar extends StatefulWidget {
  const AppDiscoveryRadar({
    required this.nodeIcon,
    required this.pins,
    this.nodeSide = RadarNodeSide.right,
    this.nodeColor = AppColors.primaryDark,
    this.ringColor = AppColors.primary,
    this.durationMs = 3400,
    super.key,
  });

  final IconData nodeIcon;
  final List<RadarPin> pins;
  final RadarNodeSide nodeSide;
  final Color nodeColor;
  final Color ringColor;
  final int durationMs;

  @override
  State<AppDiscoveryRadar> createState() => _AppDiscoveryRadarState();
}

class _AppDiscoveryRadarState extends State<AppDiscoveryRadar>
    with SingleTickerProviderStateMixin {
  static const int _ringCount = 3;
  static const double _nodeInset = 14;
  static const double _nodeRadius = 24;
  static const double _pingSigma = 16;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.maybeOf(context);
    final shouldReduceMotion = (mediaQuery?.disableAnimations ?? false) ||
        (mediaQuery?.accessibleNavigation ?? false);

    if (shouldReduceMotion) {
      _controller.stop();
      _controller.value = 0.5;
      return;
    }

    if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Pulse intensity (0..1) for a pin [distance] from the node, based on how
  /// close the nearest expanding ring front is to it.
  double _pingIntensity(double progress, double distance, double maxRadius) {
    var best = 0.0;
    for (var i = 0; i < _ringCount; i++) {
      final frac = (progress + i / _ringCount) % 1;
      final radius = lerpDouble(_nodeRadius, maxRadius, frac)!;
      final delta = (radius - distance) / _pingSigma;
      final pulse = math.exp(-delta * delta);
      if (pulse > best) best = pulse;
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final isLeft = widget.nodeSide == RadarNodeSide.left;
            final nodeCenter = Offset(
              isLeft
                  ? _nodeInset + _nodeRadius
                  : width - _nodeInset - _nodeRadius,
              height / 2,
            );
            // Reach a touch past the far edge so rings fade out as they leave.
            final maxRadius =
                (isLeft ? width - nodeCenter.dx : nodeCenter.dx) + 8;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = _controller.value;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _RadarPainter(
                          progress: progress,
                          center: nodeCenter,
                          minRadius: _nodeRadius,
                          maxRadius: maxRadius,
                          ringCount: _ringCount,
                          color: widget.ringColor,
                        ),
                      ),
                    ),
                    for (final pin in widget.pins)
                      _buildPin(
                          pin, width, height, nodeCenter, maxRadius, progress),
                    Positioned(
                      left: isLeft ? _nodeInset : null,
                      right: isLeft ? null : _nodeInset,
                      top: height / 2 - _nodeRadius,
                      child: Container(
                        width: _nodeRadius * 2,
                        height: _nodeRadius * 2,
                        decoration: BoxDecoration(
                          color: widget.nodeColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: widget.nodeColor.withValues(alpha: 0.30),
                          ),
                        ),
                        child: Icon(
                          widget.nodeIcon,
                          color: widget.nodeColor,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPin(
    RadarPin pin,
    double width,
    double height,
    Offset nodeCenter,
    double maxRadius,
    double progress,
  ) {
    const pinSize = 22.0;
    final cx = pin.fx * width;
    final cy = pin.fy * height;
    final distance = (Offset(cx, cy) - nodeCenter).distance;
    final intensity = _pingIntensity(progress, distance, maxRadius);
    final scale = 1 + 0.4 * intensity;
    final opacity = 0.45 + 0.55 * intensity;

    return Positioned(
      left: cx - pinSize / 2,
      top: cy - pinSize / 2,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: pinSize,
            height: pinSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: pin.color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(color: pin.color.withValues(alpha: 0.45)),
            ),
            child: Icon(pin.glyph, color: pin.color, size: 12),
          ),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter({
    required this.progress,
    required this.center,
    required this.minRadius,
    required this.maxRadius,
    required this.ringCount,
    required this.color,
  });

  final double progress;
  final Offset center;
  final double minRadius;
  final double maxRadius;
  final int ringCount;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Soft origin glow under the node so the rings read as emanating from it.
    canvas.drawCircle(
      center,
      minRadius + 4,
      Paint()..color = color.withValues(alpha: 0.10),
    );

    for (var i = 0; i < ringCount; i++) {
      final frac = (progress + i / ringCount) % 1;
      final radius = lerpDouble(minRadius, maxRadius, frac)!;
      final alpha = (1 - frac) * 0.45;
      if (alpha <= 0) continue;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = color.withValues(alpha: alpha);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.center != center ||
        oldDelegate.maxRadius != maxRadius;
  }
}
