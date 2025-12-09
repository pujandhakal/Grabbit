import 'package:flutter/material.dart';

class GradientIconCard extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final double iconSize;
  final double padding;
  final double radius;
  final Color? shadowColor;

  const GradientIconCard({
    Key? key,
    required this.icon,
    required this.gradientColors,
    this.iconSize = 20,
    required this.padding,
    this.radius = 14,
    this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding), // Proportional padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: iconSize,
      ),
    );
  }
}
