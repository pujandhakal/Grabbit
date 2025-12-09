import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabbit/pages/Shop/shop_dashboard_page.dart';
import 'package:grabbit/pages/login_page.dart';
import 'package:grabbit/pages/user/home_page.dart';
import 'package:grabbit/pages/intro_page.dart';

void main() { 
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.varelaRoundTextTheme(),
      ),
      home: LoginPage(),
    );
  }
}
