import 'package:flutter/material.dart';

class FilterCardGroupbuy extends StatefulWidget {
  const FilterCardGroupbuy({super.key});

  @override
  State<FilterCardGroupbuy> createState() => _FilterCardGroupbuyState();
}

class _FilterCardGroupbuyState extends State<FilterCardGroupbuy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 20,
        left: 20,
        top: 16,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    );
  }
}
