import 'package:flutter/material.dart';
import 'package:grabbit/util/Shop/gradient_icon.dart';

class ShopDashboardCard extends StatelessWidget {
  final String topRightText;
  final String cardName;
  final String number;
  final Color color;
  final IconData iconName;
  final List<Color> gradients;

  const ShopDashboardCard(
      {super.key,
      required this.topRightText,
      required this.cardName,
      required this.number,
      required this.color,
      required this.iconName,
      required this.gradients});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 170,
      // height: 182,
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.25),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientIconCard(
                  icon: iconName,
                  gradientColors: gradients,
                  padding: 12),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  topRightText,
                  style: TextStyle(fontSize: 12, color: Color(0xff4A5565)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            cardName,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff4A5565),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            number,
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
