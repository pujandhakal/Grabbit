import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  const QuickActionCard(
      {super.key, required this.color, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 120,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //icon
          Container(
            height: 48,
            width: 48,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.45),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2))
                ],
                color: color),
            child: Icon(
              // Icons.shopping_bag_outlined,
              icon,
              size: 24,
              color: Colors.white,
            ),
          ),

          SizedBox(
            height: 12,
          ),

          //text
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
