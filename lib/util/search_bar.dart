import 'package:flutter/material.dart';

class SearchBars extends StatelessWidget {
  const SearchBars({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 15)),
      elevation: WidgetStateProperty.all(0.5),
      backgroundColor: WidgetStateProperty.all(Color(0xffF3F4F6)),
      hintText: "Search or request a product",
      hintStyle: WidgetStateProperty.all(TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff99A1AF))),
      leading: Icon(
        Icons.search,
        color: Color(0xff6A7282),
        size: 19,
      ),
      trailing: {
        Icon(
          Icons.mic_none_outlined,
          color: Color(0xff6A7282),
          size: 19,
        ),
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.qr_code_outlined,
          color: Color(0xff6A7282),
          size: 19,
        ),
      },
    );
  }
}
