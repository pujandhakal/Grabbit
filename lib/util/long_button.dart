import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final String btnName;
  final Color color;
  // final VoidCallback onTap;

  const LongButton({
    super.key,
    required this.btnName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            btnName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
