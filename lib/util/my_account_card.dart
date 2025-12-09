import 'package:flutter/material.dart';

class MyAccountCard extends StatelessWidget {
  final IconData iconName;
  final String title;

  const MyAccountCard({super.key, required this.iconName, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Color(0xffF0FDFA),
              ),
              child: Icon(
                iconName,
                color: Color(0xff009689),
                size: 20,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Icon(
          Icons.chevron_right,
          size: 20,
          color: Color(0xff99A1AF),
        ),
      ],
    );
  }
}
